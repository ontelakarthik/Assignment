public class ProductFamilytriggerHandler {

    public static void beforeUpdate(
        List<Product2> newList,
        Map<Id, Product2> oldMap
    ) {
        System.debug('🔥 Handler entered');

        Set<Id> changedProductIds = new Set<Id>();

        for (Product2 newProd : newList) {
            Product2 oldProd = oldMap.get(newProd.Id);

            System.debug('Old Family=' + oldProd.Family +
                         ' New Family=' + newProd.Family);

            if (oldProd.Family != newProd.Family) {
                changedProductIds.add(newProd.Id);
            }
        }

        System.debug('Changed Product Ids=' + changedProductIds);

        if (changedProductIds.isEmpty()) {
            System.debug('❌ No family change detected');
            return;
        }

        List<OpportunityLineItem> oliList = [
            SELECT Product2Id, Opportunity.IsClosed
            FROM OpportunityLineItem
            WHERE Product2Id IN :changedProductIds
            AND Opportunity.IsClosed = false
        ];

        System.debug('OLI found=' + oliList.size());

        Set<Id> blockedProductIds = new Set<Id>();
        for (OpportunityLineItem oli : oliList) {
            blockedProductIds.add(oli.Product2Id);
        }

        for (Product2 newProd : newList) {
            if (blockedProductIds.contains(newProd.Id)) {
                newProd.Family.addError(
                    '❌ BLOCKED: Product is used in open Opportunities'
                );
            }
        }
    }
}