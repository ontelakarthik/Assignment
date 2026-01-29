trigger OpportunityTrigger on Opportunity (before insert,before update) 
{
    if(trigger.isinsert && trigger.isupdate){
        for(opportunity opp : Trigger.new){
            if(opp.amount>10000)
            {
                opp.stagename = 'ClosedWon';
            }
        }
    }

}