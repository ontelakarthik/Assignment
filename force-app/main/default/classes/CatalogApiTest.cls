@IsTest
private class CatalogApiTest 
{

    @IsTest
    static void testCatalogCalloutOnProductActivation() 
{

        Test.setMock(HttpCalloutMock.class, new CatalogMock());
        Product2 p = new Product2(Name = 'Test Product',ProductCode = 'SKU-100',IsActive = false);
        insert p;

        Id stdPricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = stdPricebookId, Product2Id   = p.Id, UnitPrice    = 100, IsActive     = true);
        insert pbe;

        p.IsActive = true;

        Test.startTest();
        update p;  
        Test.stopTest();

    
        Product2 updated =[SELECT Catalog_Id__c FROM Product2 WHERE Id = :p.Id];

        System.assertEquals('123', updated.Catalog_Id__c);

    }
}
