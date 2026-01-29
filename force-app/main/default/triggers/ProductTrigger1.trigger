trigger ProductTrigger1 on Product2 (after update) {

    // List to store only newly activated products
    List<Product2> activatedProducts = new List<Product2>();

    for (Product2 newProd : Trigger.new) {
        Product2 oldProd = Trigger.oldMap.get(newProd.Id);

        // Check: IsActive changed from false → true
        if (oldProd != null && !oldProd.IsActive && newProd.IsActive) {
            activatedProducts.add(newProd);
        }
    }

    // Call handler only if we have activated products
    if (!activatedProducts.isEmpty()) {
        CatalogIntegrationHandler.syncProducts(activatedProducts);
    }
}