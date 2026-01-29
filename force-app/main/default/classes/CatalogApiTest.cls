@IsTest
private class CatalogApiTest {

    @IsTest
    static void testCatalogCalloutOnProductActivation() {

        // Register REST mock
        Test.setMock(HttpCalloutMock.class, new CatalogMock());

        // 1️⃣ Create inactive Product
        Product2 p = new Product2(
            Name = 'Test Product',
            ProductCode = 'SKU-100',
            IsActive = false
        );
        insert p;

        // 2️⃣ Create Standard Pricebook Entry (MANDATORY)
        Id stdPricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = stdPricebookId,
            Product2Id   = p.Id,
            UnitPrice    = 100,
            IsActive     = true
        );
        insert pbe;

        // 3️⃣ Activate Product (trigger fires)
        p.IsActive = true;

        Test.startTest();
        update p;   // Trigger → Queueable → REST Callout
        Test.stopTest();

        // 4️⃣ Verify catalogId saved
        Product2 updated =
            [SELECT Catalog_Id__c FROM Product2 WHERE Id = :p.Id];

        System.assertEquals('123', updated.Catalog_Id__c);

    }
}