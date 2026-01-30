trigger Summarytrigger on Opportunity (after update)
{
    List<Id> OppIds = new List<Id>();
    for (Opportunity opp : Trigger.new) 
    {
        if (opp.StageName == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won') 
        {
            OppIds.add(opp.Id);
        }
    }

    if (OppIds.isEmpty()) return; 
 
    Map<Id, Decimal> amountMap = new Map<Id, Decimal>();
    Map<Id, Decimal> qtyMap = new Map<Id, Decimal>();

    for (AggregateResult ar : [SELECT Product2Id, SUM(TotalPrice) totalAmount, SUM(Quantity) totalUnits FROM OpportunityLineItem WHERE OpportunityId IN :OppIds GROUP BY Product2Id]) 
{
        amountMap.put((Id)ar.get('Product2Id'), (Decimal)ar.get('totalAmount'));
        qtyMap.put((Id)ar.get('Product2Id'), (Decimal)ar.get('totalUnits'));
    }

 
    List<Product_Sales_Summary__c> summaryList = new List<Product_Sales_Summary__c>();

    for (Id productId : amountMap.keySet())
{
        summaryList.add(new Product_Sales_Summary__c(Product__c = productId, Product_Key__c = productId,Total_Sales_Amount__c = amountMap.get(productId),Total_Units__c = qtyMap.get(productId)));
    }

    upsert summaryList Product_Key__c;
}
