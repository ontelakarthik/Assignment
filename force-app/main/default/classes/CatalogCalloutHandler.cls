public class CatalogCalloutHandler
        implements Queueable, Database.AllowsCallouts {

    private List<Product2> productList;

    // Constructor
    public CatalogCalloutHandler(List<Product2> products) {
        this.productList = products;
    }

    // Called from Trigger
    public static void sendProducts(List<Product2> products) {
        System.enqueueJob(new CatalogCalloutHandler(products));
    }

    // Queueable execution
    public void execute(QueueableContext context) {

        Http http = new Http();

        for (Product2 prod : productList) {

            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://mock-catalog-api.com/products');
            req.setMethod('POST');

            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-api-key', 'YOUR_API_KEY');

            Map<String, Object> body = new Map<String, Object>{
                'name' => prod.Name,
                'sku'  => prod.ProductCode,
                'price'=> prod.List_Price__c
            };

            req.setBody(JSON.serialize(body));

            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                // 🔗 STEP-4 method call
                updateProductWithCatalogId(res.getBody(), prod.Id);
            }
        }
    }

    // ✅ STEP-4 METHOD (THIS IS WHAT YOU ASKED)
    private static void updateProductWithCatalogId(
            String responseBody,
            Id productId) {

        Map<String, Object> responseMap =
            (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        String catalogId = (String) responseMap.get('catalogId');

        if (catalogId != null) {
            Product2 p = new Product2(
                Id = productId,
                Catalog_Id__c = catalogId
            );
            update p;
        }
    }
}