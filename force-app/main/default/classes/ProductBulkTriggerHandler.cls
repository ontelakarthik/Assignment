public class ProductBulkTriggerHandler {

    public static void beforeSave(
        List<Product2> newList,
        Map<Id, Product2> oldMap
    ) {
        // bulk-safe validations
    }

    public static void afterSave(
        List<Product2> newList,
        Map<Id, Product2> oldMap
    ) {
        
}
}