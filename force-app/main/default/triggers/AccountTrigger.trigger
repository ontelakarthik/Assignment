trigger AccountTrigger on Account (before insert)
{
    {
        for(Account acc : Trigger.new){
            if(acc.Rating  == null || acc.Industry == null|| acc.fax == null)
            {
                acc.adderror('The fields Rating,Industry,Fax are required');
            }
        }
    }
}