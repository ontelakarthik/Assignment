public class CatalogQueueableService implements Queueable, Database.AllowsCallouts {

    private List<Product2> products;

    // Constructor
    public CatalogQueueableService(List<Product2> products) {
        this.products = products;
    }

    // Queueable entry point
    public void execute(QueueableContext context) {

        for (Product2 prod : products) {
            callCatalogAPI(prod);
        }
    }

    private void callCatalogAPI(Product2 prod) {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://mock-catalog-api.com/products');
        req.setMethod('POST');

        req.setHeader('x-api-key', 'YOUR_API_KEY');
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> body = new Map<String, Object>{
            'name'  => prod.Name,
            'sku'   => prod.ProductCode,
            'price' => prod.List_Price__c
        };

        req.setBody(JSON.serialize(body));

        Http http = new Http();
        HttpResponse res;

        try {
            res = http.send(req);

            if (res.getStatusCode() == 200) {

                Map<String, Object> responseMap =
                    (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                String catalogId = (String) responseMap.get('catalogId');

                update new Product2(
                    Id = prod.Id,
                    Catalog_Id__c = catalogId
                );

            } else {
                logError(prod.Id, res.getStatusCode(), res.getBody());
            }

        } catch (Exception e) {
            logError(prod.Id, 500, e.getMessage());
        }
    }

    private void logError(Id productId, Integer statusCode, String message) {

        insert new API_Log__c(
            Product__c = productId,
            Status_Code__c = statusCode,
            Message__c = message
        );
    }
}