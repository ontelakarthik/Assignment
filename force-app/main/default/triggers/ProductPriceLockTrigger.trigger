trigger ProductPriceLockTrigger on Product2 (before update)
{

    for (Product2 pd : Trigger.new)
    {
        Product2 oldpd = Trigger.oldMap.get(pd.Id);

            if (pd.Price_Locked__c == true &&
            pd.List_Price__c != oldPd.List_Price__c)
              {
            pd.List_Price__c.addError('List Price cannot be modified when Price is locked.');
        }
    }
}