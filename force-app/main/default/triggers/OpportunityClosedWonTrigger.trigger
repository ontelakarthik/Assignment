trigger OpportunityClosedWonTrigger on Opportunity (after update)
{

    Set<Id> wonOppIds = new Set<Id>();
    for(Opportunity opp : Trigger.new)
    {
        if(opp.StageName == 'Closed Won')
        {
            wonOppIds.add(opp.Id);
        }
    }
    if(wonOppIds.isEmpty()) return;

    Map<Id, Decimal> revenueMap = new Map<Id, Decimal>();

    for(OpportunityLineItem oli : [SELECT Id, Quantity, UnitPrice FROM OpportunityLineItem WHERE OpportunityId IN :wonOppIds])
    {
       
        Decimal revenue = (oli.Quantity * oli.UnitPrice);
        revenueMap.put(oli.Id, revenue);
    }

    
    List<OpportunityLineItem> toUpdate = new List<OpportunityLineItem>();
    for(OpportunityLineItem oli : [ SELECT Id FROM OpportunityLineItem WHERE Id IN :revenueMap.keySet()])
    {
        oli.Total_Revenue__c = revenueMap.get(oli.Id);
        toUpdate.add(oli);
    }

   
    update toUpdate;
}