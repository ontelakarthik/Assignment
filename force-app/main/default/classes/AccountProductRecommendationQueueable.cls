public class AccountProductRecommendationQueueable
    implements Queueable, Database.AllowsCallouts {

    private Id accountId;

    public AccountProductRecommendationQueueable(Id accountId) {
        this.accountId = accountId;
    }

    public void execute(QueueableContext qc) {

        // 1️⃣ Prepare HTTP request
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');

        // Example endpoint (use Named Credential in real projects)
        req.setEndpoint(
            'callout:Recommendation_API/recommendations?accountId='
            + accountId
        );

        Http http = new Http();
        HttpResponse res = http.send(req);

        // 2️⃣ Validate response
        if (res.getStatusCode() != 200) {
            System.debug('Callout failed');
            return;
        }

        // 3️⃣ Parse JSON response
        List<Object> results =
            (List<Object>) JSON.deserializeUntyped(res.getBody());

        // 4️⃣ Prepare records for upsert
        List<Account_Product_Recommendation__c> recordsToUpsert =
            new List<Account_Product_Recommendation__c>();

        for (Object obj : results) {
            Map<String, Object> row =
                (Map<String, Object>) obj;

            String productId = (String) row.get('productId');
            Integer score = (Integer) row.get('score');

            Account_Product_Recommendation__c rec =
                new Account_Product_Recommendation__c();

            rec.Account__c = accountId;
            rec.Product__c = productId;
            rec.Score__c = score;

            // External ID for idempotent upsert
            rec.External_Key__c = accountId + '-' + productId;

            recordsToUpsert.add(rec);
        }

        // 5️⃣ Upsert records
        if (!recordsToUpsert.isEmpty()) {
            upsert recordsToUpsert
                Account_Product_Recommendation__c.External_Key__c;
        }
    }
}