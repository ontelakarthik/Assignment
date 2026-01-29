public with sharing class ProductCatalogController {

    @AuraEnabled(cacheable=true)
    public static List<Product2> getProducts(String searchKey) {

        String key = '%' + searchKey + '%';

        return [
            SELECT Id, Name, Family, IsActive, List_Price__c
            FROM Product2
            WHERE Name LIKE :key
               OR Family LIKE :key
            ORDER BY Name
            LIMIT 50
        ];
    }
}