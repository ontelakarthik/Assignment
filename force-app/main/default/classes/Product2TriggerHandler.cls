public class Product2TriggerHandler 
{

    public void beforeInsert(List<Product2> products) 
{
        for (Product2 p : products)
{
            if (String.isBlank(p.Name))
{
                p.addError('Product Name is required');
            }
        }
    }

    public void beforeDelete(List<Product2> products) {
        for (Product2 p : products) {
            if (p.IsActive) {
                p.addError('You cannot delete an active product');
            }
        }
    }
}
