trigger ProductFamily on Product2 (after update)
{
    ProductFamilyHandler.afterUpdate(Trigger.new, Trigger.oldMap);
}
