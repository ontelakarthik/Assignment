public class CatalogCalloutService 
{

    @future(callout=true)
    public static void sendProducts(List<Id> productIds) 
{

        List<Product2> products = [SELECT Id, Name, ProductCode, List_Price__c FROM Product2 WHERE Id IN :productIds];

        Http http = new Http();

        for (Product2 prod : products)
{

            try {
                
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
                HttpResponse res = http.send(req);
                if (res.getStatusCode() == 200) 
{

                    Map<String, Object> responseMap =
                        (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                    String catalogId = (String) responseMap.get('catalogId');

                    update new Product2(Id = prod.Id,Catalog_Id__c = catalogId);

                } 
                else {
                    insert new API_Log__c(
                        Product__c = prod.Id,
                        Status_Code__c = res.getStatusCode(),
                        Message__c = res.getBody()
                    );
                }

            } catch (Exception e) 
{
                    insert new API_Log__c(Product__c = prod.Id,Status_Code__c = 500, Message__c = e.getMessage()
                );
            }
        }
    }
}
