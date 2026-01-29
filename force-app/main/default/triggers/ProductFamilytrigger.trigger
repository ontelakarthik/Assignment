trigger ProductFamilytrigger on Product2 (before Update)
{
    if (Trigger.isBefore && Trigger.isUpdate)
     {
        ProductFamilytriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap);
    }
}