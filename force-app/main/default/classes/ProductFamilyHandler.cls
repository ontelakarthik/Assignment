public class ProductFamilyHandler {

    public static void afterUpdate(
        List<Product2> newList,
        Map<Id, Product2> oldMap
    ) {

       
        Map<Id, String> productToFamily = new Map<Id, String>();

        for (Product2 p : newList) {
            Product2 oldP = oldMap.get(p.Id);

            if (p.Family != oldP.Family) {
                productToFamily.put(p.Id, p.Family);
            }
        }

        if (productToFamily.isEmpty()) {
            return;
        }

        // Step 2: Update active PricebookEntries
        List<PricebookEntry> pbToUpdate = new List<PricebookEntry>();

        for (PricebookEntry pb : [
            SELECT Id, Product2Id
            FROM PricebookEntry
            WHERE IsActive = TRUE
            AND Product2Id IN :productToFamily.keySet()
        ]) {
            pb.Family_Copy__c =
                productToFamily.get(pb.Product2Id);
            pbToUpdate.add(pb);
        }

        if (!pbToUpdate.isEmpty()) {
            update pbToUpdate;
        }
    }
}