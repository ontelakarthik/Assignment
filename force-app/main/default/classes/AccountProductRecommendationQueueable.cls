public class AccountProductRecommendationQueueable implements Queueable, Database.AllowsCallouts
{

    private Id accountId;

    public AccountProductRecommendationQueueable(Id accountId)
{
        this.accountId = accountId;
    }

    public void execute(QueueableContext qc)
{

       
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');

        
        req.setEndpoint('callout:Recommendation_API/recommendations?accountId='+ accountId );

        Http http = new Http();
        HttpResponse res = http.send(req);

    
        if (res.getStatusCode() != 200) 
{
            System.debug('Callout failed');
            return;
        }

        
        List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());

        
        List<Account_Product_Recommendation__c> recordsToUpsert = new List<Account_Product_Recommendation__c>();

        for (Object obj : results) 
{
        Map<String, Object> row =(Map<String, Object>) obj;

            String productId = (String) row.get('productId');
            Integer score = (Integer) row.get('score');

            Account_Product_Recommendation__c rec = new Account_Product_Recommendation__c();

            rec.Account__c = accountId;
            rec.Product__c = productId;
            rec.Score__c = score;

            
            rec.External_Key__c = accountId + '-' + productId;

            recordsToUpsert.add(rec);
        }

      
        if (!recordsToUpsert.isEmpty()) {
            upsert recordsToUpsert
                Account_Product_Recommendation__c.External_Key__c;
        }
    }
}
