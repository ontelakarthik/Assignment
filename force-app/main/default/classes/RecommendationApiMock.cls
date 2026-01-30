@isTest
public class RecommendationApiMock implements HttpCalloutMock
{
    public HTTPResponse respond(HTTPRequest req)
{
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('[{"productId":"01t000000000001","score":90},' + '{"productId":"01t000000000002","score":75}]');
        return res;
    }
}
