trigger Product2Trigger on Product2 (
    before insert,
    before delete
) {
    Product2TriggerHandler handler = new Product2TriggerHandler();

    if (Trigger.isInsert && Trigger.isBefore) {
        handler.beforeInsert(Trigger.new);
    }

    if (Trigger.isDelete && Trigger.isBefore) {
        handler.beforeDelete(Trigger.old);
    }
}