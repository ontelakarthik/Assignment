@isTest
public class AccountRecQueueableTest 
{

    @isTest
    static void testQueueableCallout()
{

        Account acc = new Account();
        acc.Name= 'Test Account';
        insert acc;

        Product2 p1 = new Product2();
        p1.Name = 'Laptop';
        p1.IsActive = true;

        Product2 p2 = new Product2();
        p2.Name = 'Monitor';
        p2.IsActive = true;

        insert new List<Product2>{ p1, p2 };
        Test.setMock(HttpCalloutMock.class, new RecommendationApiMock());

        Test.startTest();
        System.enqueueJob(new AccountProductRecommendationQueueable(acc.Id));
        Test.stopTest();

        List<Account_Product_Recommendation__c> recs = [ SELECT Id FROM Account_Product_Recommendation__c WHERE Account__c = :acc.Id];

        System.assertEquals(2,recs.size(),'Two recommendation records should be created');
    }
}
