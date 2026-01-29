trigger ContactTrigger1 on Contact (before insert,before update) 
{
        for(contact con : Trigger.new)
        {
            if(con.accountid == null){
                con.adderror('Each Contact must be associated with an Account');
            }
        }
    }