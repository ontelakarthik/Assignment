trigger Product3Trigger on Product2 (
    after insert,
    after update,
    after delete
) {
    Product3TriggerHandler handler = new Product3TriggerHandler();

    handler.afterChange(
        Trigger.isDelete ? Trigger.old : Trigger.new
    );
}