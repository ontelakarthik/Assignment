trigger contactTrigger3 on Contact (before delete) 
{
    if(Trigger.isBefore && Trigger.isDelete)
    {
        Set<id> accIds=new Set<id>();
        for(Contact con:Trigger.old)
        {
            if(con.AccountId!=Null)
            {
                accids.add(con.AccountId);
            }
        }
        Map<Id,Account> accmap=new Map<Id,Account>([Select Id,Active__c from Account Where Id IN: accIds]);
        
        for(Contact con:Trigger.old)
        {
            Account acc=accmap.get(con.AccountId);
            if(acc.Active__c=='No')
            {
                con.addError('Contact cannot be deleted as related Account is inactive ');
            }
        }
    }
}
