@isTest
public class AccountRecQueueableTest {

    @isTest
    static void testQueueableCallout() {

        // Create Account
        Account acc = new Account();
        acc.Name= 'Test Account';
        insert acc;

        // Create Products
        Product2 p1 = new Product2();
        p1.Name = 'Laptop';
        p1.IsActive = true;

        Product2 p2 = new Product2();
        p2.Name = 'Monitor';
        p2.IsActive = true;

        insert new List<Product2>{ p1, p2 };

        // Register HTTP Callout Mock
        Test.setMock(HttpCalloutMock.class, new RecommendationApiMock());

        // Execute Queueable
        Test.startTest();
        System.enqueueJob(
            new AccountProductRecommendationQueueable(acc.Id)
        );
        Test.stopTest();

        // Verify recommendation records
        List<Account_Product_Recommendation__c> recs = [
            SELECT Id
            FROM Account_Product_Recommendation__c
            WHERE Account__c = :acc.Id
        ];

        System.assertEquals(
            2,
            recs.size(),
            'Two recommendation records should be created'
        );
    }
}