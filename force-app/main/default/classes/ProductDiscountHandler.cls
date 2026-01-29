public class ProductDiscountHandler
{

    public static void validateDiscount(List<Product2> newList,Map<Id, Product2> oldMap) 
{

       
        Product_Policy__c policy = Product_Policy__c.getInstance(UserInfo.getUserId());

    
        if (policy == null || policy.Max_Discount__c == null)
{
            return;
        }

        Decimal maxAllowed = policy.Max_Discount__c;

        for (Product2 p : newList) 
{
        Product2 oldP = oldMap.get(p.Id);

            if (p.Discount_Allowed__c != null && p.Discount_Allowed__c != oldP.Discount_Allowed__c && p.Discount_Allowed__c > maxAllowed ) 
{
                p.Discount_Allowed__c.addError('Discount cannot exceed ' + maxAllowed + '% for your role/profile.');
            }
        }
    }
}
