trigger ProductActiveCountTrigger on Product2 (
    after insert, after update, after delete
) {
    Set<Id> catIds = new Set<Id>();

    if(Trigger.isInsert || Trigger.isUpdate)
    {
        for(Product2 p : Trigger.new)
        {
            if(p.Product_Cateory__c != null)
            {
                catIds.add(p.Product_Cateory__c);
            }
        
    }

    if(Trigger.isUpdate)
    {
        for(Product2 oldP : Trigger.old)
        {
            Product2 newP = Trigger.newMap.get(oldP.Id);
            if(oldP.Product_Cateory__c!= newP.Product_Cateory__c)
            {
                if(oldP.Product_Cateory__c != null) catIds.add(oldP.Product_Cateory__c);
            }
        }
    }

    if(Trigger.isDelete)
    {
        for(Product2 p : Trigger.old)
        {
            if(p.Product_Cateory__c!= null)
            {
                catIds.add(p.Product_Cateory__c);
            }
        }
    }

    if(catIds.isEmpty()) return;

   Map<Id, Integer> countMap = new Map<Id, Integer>();

for(AggregateResult ar : [ SELECT Product_Cateory__c cat, COUNT(Id) total FROM Product2 WHERE IsActive = TRUE 
                          AND Product_Cateory__c IN :catIds
                           GROUP BY Product_Cateory__c])
{
    countMap.put((Id)ar.get('cat'), (Integer)ar.get('total'));
}

    List<Product_Cateory__c> categoriesToUpdate = new List<Product_Cateory__c>();
    for(Id cid : catIds)
    {
        Integer countVal = countMap.containsKey(cid) ? countMap.get(cid) : 0;
        categoriesToUpdate.add(new Product_Cateory__c(Id = cid, Active_Product_Count__c = countVal));
    }

    update categoriesToUpdate;
}
}