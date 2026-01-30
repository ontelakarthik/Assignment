trigger ActiveTrigger on Product2 (before update)
{
      for (Product2 p : Trigger.new) 
{

        Product2 oldP = Trigger.oldMap.get(p.Id);
        if (OldP.IsActive == false && oldP.Lauch_Date__c < Date.today()) 
        {
            p.IsActive = true;
        }
    }

}
