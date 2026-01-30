trigger ActiveProduct on Product2 (after insert,after update,after delete)
{
    ActiveProductHandler.updateActiveProductCount( Trigger.new, Trigger.old);
}
