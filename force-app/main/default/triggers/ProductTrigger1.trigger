trigger ProductTrigger1 on Product2 (after update) 
{
    List<Product2> activatedProducts = new List<Product2>();

    for (Product2 newProd : Trigger.new) 
{
Product2 oldProd = Trigger.oldMap.get(newProd.Id);
        if (oldProd != null && !oldProd.IsActive && newProd.IsActive) 
{
            activatedProducts.add(newProd);
        }
    }

    if (!activatedProducts.isEmpty()) 
{
        CatalogIntegrationHandler.syncProducts(activatedProducts);
    }
}
