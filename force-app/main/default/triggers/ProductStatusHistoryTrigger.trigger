trigger ProductStatusHistoryTrigger on Product2 (after update)
{
    List<Product_Status_History__c> historyList = new List<Product_Status_History__c>();

   
    for (Product2 newProd : Trigger.new) 
    {
        Product2 oldProd = Trigger.oldMap.get(newProd.Id);

        if (oldProd.IsActive == true && newProd.IsActive == false)
        {

            Product_Status_History__c history = new Product_Status_History__c();

            history.Product__c = newProd.Id;
            history.Old_Status__c = oldProd.IsActive;
            history.New_Status__c = newProd.IsActive;

            historyList.add(history);
        }
    }
    if(!historyList.isEmpty())
    {
        insert historyList;
    }
}