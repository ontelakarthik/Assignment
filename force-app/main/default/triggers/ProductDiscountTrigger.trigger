trigger ProductDiscountTrigger on Product2 (before update) 
{
    if (Trigger.isBefore && Trigger.isUpdate)
{
        ProductDiscountHandler.validateDiscount(Trigger.new,Trigger.oldMap);
    }
}
