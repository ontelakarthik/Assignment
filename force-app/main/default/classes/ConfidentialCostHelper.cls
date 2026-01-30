public without sharing class ConfidentialCostHelper 
{

    public static void readConfidentialCosts(List<Product2> products)
{

     
        Set<Id> productIds = new Set<Id>();
        for (Product2 p : products) 
{
            productIds.add(p.Id);
        }

       
        List<Confidential_Cost__c> costList = [SELECT Product__c, Internal_Cost__c FROM Confidential_Cost__c WHERE Product__c IN :productIds];
        System.debug('Confidential Costs: ' + costList);
    }
}
