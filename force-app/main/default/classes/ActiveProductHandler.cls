public class ActiveProductHandler
{


    public static void updateActiveProductCount(List<Product2> newList,List<Product2> oldList)
{

        Set<Id> categoryIds = new Set<Id>();
        if (newList != null)
{
            for (Product2 p : newList)
{
                if (p.Product_Cateory__c != null) 
{
                    categoryIds.add(p.Product_Cateory__c);
                }
            }
        }

       
        if (oldList != null)
{
            for (Product2 p : oldList) 
{
                if (p.Product_Cateory__c != null) 
{
                    categoryIds.add(p.Product_Cateory__c);
                }
            }
        }

        if (categoryIds.isEmpty()) 
{
            return;
        }

      
        Map<Id, Integer> categoryToCount = new Map<Id, Integer>();

        for (AggregateResult ar : [SELECT Product_Cateory__c categoryId,COUNT(Id) total FROM Product2 WHERE IsActive = TRUE AND Product_Cateory__c IN :categoryIds  GROUP BY Product_Cateory__c])
{
            categoryToCount.put((Id) ar.get('categoryId'),(Integer) ar.get('total'));
        }

        List<Product_Cateory__c> categoriesToUpdate =
            new List<Product_Cateory__c>();

        for (Id catId : categoryIds) {
           Product_Cateory__c pc = new Product_Cateory__c();
            pc.Id = catId;
            pc.Active_Product_Count__c =
                categoryToCount.containsKey(catId)
                ? categoryToCount.get(catId)
                : 0;
            categoriesToUpdate.add(pc);
        }

        if (!categoriesToUpdate.isEmpty()) {
            update categoriesToUpdate;
        }
    }
}
