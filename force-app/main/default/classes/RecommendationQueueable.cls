public class RecommendationQueueable implements Queueable, Database.AllowsCallouts 
    {

    private Id accountId;

    public RecommendationQueueable(Id accountId)
     {
        this.accountId = accountId;

    }

    public void execute(QueueableContext context)
     {

        
        List<Map<String, Object>> apiResults = RecommendationCalloutService.getRecommendations(accountId);

        
        Map<String, Id> productMap = new Map<String, Id>();
        for (Product2 p : [SELECT Id, ProductCode FROM Product2 WHERE ProductCode != NULL])
{
            productMap.put(p.ProductCode, p.Id);
        }

        
        List<Account_Product_Recommendation__c> records = new List<Account_Product_Recommendation__c>();

        for (Map<String, Object> rec : apiResults)
{

            String code = (String) rec.get('productCode');
            Decimal score = (Decimal) rec.get('score');

            if (productMap.containsKey(code)) 
{
                records.add(new Account_Product_Recommendation__c(Account__c = accountId,Product__c = productMap.get(code),Score__c = score,Source__c = 'External API',Recommendation_Date__c = Date.today(),External_Key__c = accountId + '-' + productMap.get(code)));
            }
        }

        
        if (!records.isEmpty()) {
            upsert records External_Key__c;
        }
    }
}
