trigger Productbulktrigger on Product2 (
    before insert,
    before update,
    after insert,
    after update
) {
    if (Trigger.isBefore) {
        ProductBulkTriggerHandler.beforeSave(
            Trigger.new,
            Trigger.oldMap
        );
    }

    if (Trigger.isAfter) {
        ProductBulkTriggerHandler.afterSave(
            Trigger.new,
            Trigger.oldMap
        );
    }
}