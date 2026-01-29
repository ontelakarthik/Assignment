public class ProductFamilyPreventHandler 
{

    public static void beforeUpdate(List<Product2> newList,Map<Id, Product2> oldMap)
{

      
        Set<Id> productIds = new Set<Id>();

        for (Product2 p : newList)
{
            Product2 oldP = oldMap.get(p.Id);

            if (p.Family != oldP.Family)
{
                productIds.add(p.Id);
            }
        }

        if (productIds.isEmpty()) return;
        Set<Id> productsWithOpenOpps = new Set<Id>();

        for (OpportunityLineItem oli : [SELECT Product2Id FROM OpportunityLineItem WHERE Product2Id IN :productIds AND Opportunity.StageName NOT IN ('Closed Won', 'Closed Lost')]) 
{
            productsWithOpenOpps.add(oli.Product2Id);
        }

        for (Product2 p : newList) 
{
            if (productsWithOpenOpps.contains(p.Id)) 
{
                p.Family.addError( 'Cannot change Product Family while open Opportunities exist.');
            }
        }
    }
}
