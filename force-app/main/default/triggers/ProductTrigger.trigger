trigger ProductTrigger on Product2 (after insert)
{

    List<Product2> productUpdate = new List<Product2>();
      Product_Config__c config = Product_Config__c.getAll().values()[0];

    for(Product2 p : Trigger.new){
        if(p.Family == null){
            Product2 pd = new Product2(Id = p.Id,Family = config.Default_Family__c);
            productUpdate.add(pd);
        }
    }

    if(!productUpdate.isEmpty()){
        update productUpdate;
    }
}