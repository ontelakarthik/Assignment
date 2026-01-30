trigger ProductFamilyPrevent on Product2 (before update)
{
    ProductFamilyPreventHandler.beforeUpdate(Trigger.new,Trigger.oldMap);
}
