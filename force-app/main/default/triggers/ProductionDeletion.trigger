trigger ProductionDeletion on Product2 (before delete) 
{
    Set<Id> productIds = new Set<Id>();
    for(Product2 p : Trigger.old){
        productIds.add(p.Id);
    }

    List<OpportunityLineItem> usedProducts = [
        SELECT Id, Product2Id, Opportunity.StageName
        FROM OpportunityLineItem
        WHERE Product2Id IN :productIds
        AND Opportunity.StageName NOT IN ('Closed Won', 'Closed Lost')
    ];

    if(!usedProducts.isEmpty()){
        for(Product2 prod : Trigger.old){
            prod.addError('You cannot delete this Product because it is used on an active Opportunity.');
        }
    }
}