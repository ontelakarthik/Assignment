public with sharing class AccountRecommendationController {

    @AuraEnabled
    public static void fetchRecommendations(Id accountId) {
        System.enqueueJob(
            new AccountProductRecommendationQueueable(accountId)
        );
    }

    @AuraEnabled(cacheable=true)
    public static List<Account_Product_Recommendation__c>
        getRecommendations(Id accountId) {

        return [
            SELECT Id,
                   Product__r.Name,
                   Score__c
            FROM Account_Product_Recommendation__c
            WHERE Account__c = :accountId
        ];
    }
}