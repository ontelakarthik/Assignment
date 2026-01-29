public class ProductTriggerrHandler {

    public static void handleAfter(
        List<Product2> newList,
        Map<Id, Product2> oldMap
    ) {

        List<Product2> strategicProducts = new List<Product2>();

        for (Product2 p : newList) {
            if (p.Strategic__c == true) {
                strategicProducts.add(p);
            }
        }

        if (!strategicProducts.isEmpty()) {
            ConfidentialCostHelper.readConfidentialCosts(
                strategicProducts
            );
        }
    }
}