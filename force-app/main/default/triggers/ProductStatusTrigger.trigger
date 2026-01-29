trigger ProductStatusTrigger on Product2 (after update) {

    List<Product_Status_History__c> logs = new List<Product_Status_History__c>();

    for (Product2 newProd : Trigger.new) {

        Product2 oldProd = Trigger.oldMap.get(newProd.Id);

        if (oldProd.IsActive == true && newProd.IsActive == false) {

            Product_Status_History__c log = new Product_Status_History__c();
            log.Product__c = newProd.Id;
            log.Old_Status__c = oldProd.IsActive;
            log.New_Status__c = newProd.IsActive;

            logs.add(log);
        }
    }

    if (!logs.isEmpty()) {
        insert logs;
    }
}