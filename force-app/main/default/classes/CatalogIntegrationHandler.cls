public class CatalogIntegrationHandler {

    public static void syncProducts(List<Product2> products) {
        System.enqueueJob(new CatalogQueueable(products));
    }
}