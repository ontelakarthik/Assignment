trigger contactTrigger2 on Contact (before insert) 
{
    for(contact con : trigger.new)
    {
        if(con.LeadSource == 'web'){
              if(con.MailingStreet == null ||con.MailingCity == null ||con.MailingState == null ||con.MailingPostalCode == null ||con.MailingCountry == null)
            {
                con.addError('Mailing Address Street, City, State, Postal Code, Country is required when Lead Source is Web');
            }
        }
    }
}