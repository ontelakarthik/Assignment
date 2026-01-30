trigger OpportunityLineItemMarginTrigger on OpportunityLineItem (before insert)
{

    Set<Id> pdIds = new Set<Id>();
    for (OpportunityLineItem oli : Trigger.new) 
    {
        if (oli.PricebookEntryId != null) 
        {
            pdIds.add(oli.PricebookEntryId);
        }
    }

    Map<Id, Decimal> pdCostMap = new Map<Id, Decimal>();

    for (PricebookEntry pd : [SELECT Id, Product2.Product_Cost__c FROM PricebookEntry WHERE Id IN :pdIds])
    {
        Decimal cost = pd.Product2.Product_Cost__c != null ? pd.Product2.Product_Cost__c : 0; pdCostMap.put(pd.Id, cost);
    }

    for (OpportunityLineItem oli : Trigger.new)
    {

        if (pdCostMap.containsKey(oli.PricebookEntryId) && oli.UnitPrice != null && oli.Quantity != null) 
        {
            Decimal cost = pdCostMap.get(oli.PricebookEntryId);
            Decimal revenue = oli.UnitPrice * oli.Quantity;
            Decimal totalCost = cost * oli.Quantity;

            oli.Line_Margin__c = revenue - totalCost;
        }
    }
}
