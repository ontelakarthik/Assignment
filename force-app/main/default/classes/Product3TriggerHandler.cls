public class Product3TriggerHandle
{
    public void beforeDelete(List<Product2> products) 
{
        for (Product2 p : products)
{
            if (p.IsActive) 
{
                p.addError('Deactivate product before deleting');
            }
        }
    }

    public void afterChange(List<Product2> products)
{

        Set<Id> categoryIds = new Set<Id>();
        for (Product2 p : products) 
{
            if (p.Product_Cateory__c != null) 
{
                categoryIds.add(p.Product_Cateory__c);
            }
        }

        if (categoryIds.isEmpty()) return;

        Map<Id, Integer> countMap = new Map<Id, Integer>();
        for (AggregateResult ar : [SELECT Product_Cateory__c catId,COUNT(Id) totat FROM Product2 WHERE IsActive = TRUE AND Product_Cateory__c IN :categoryId GROUP BY Product_Cateory__c])
{
            countMap.put(
                (Id) ar.get('catId'),
                (Integer) ar.get('total')
            );
        }

       
        List<Product_Cateory__c> categoriesToUpdate = new List<Product_Cateory__c>();
        for (Id catId : categoryIds) {
            categoriesToUpdate.add(
                new Product_Cateory__c(
                    Id = catId,
                    Active_Product_Count__c =
                        countMap.containsKey(catId)
                        ? countMap.get(catId)
                        : 0
                )
            );
        }

        // 4️⃣ Single DML
        update categoriesToUpdate;
    }
}
