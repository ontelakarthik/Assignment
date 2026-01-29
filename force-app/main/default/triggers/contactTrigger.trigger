trigger contactTrigger on Contact (before insert,before update) 
{
    if(trigger.isbefore && (trigger.isInsert||trigger.isupdate))
    {
        for(contact con : trigger.new)
        {
            if(con.Phone == null || con.Email ==  null)
            {
                con.addError('while creating a record is required  mobile or email ');
            }
        }
    }

}