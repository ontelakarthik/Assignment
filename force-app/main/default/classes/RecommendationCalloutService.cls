public with sharing class RecommendationCalloutService
{

    public static List<Map<String, Object>> getRecommendations(Id accountId) 
{

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:Recommendation_API/recommendations?accountId=' + accountId);
        req.setTimeout(20000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) 
{
            throw new CalloutException( 'Failed with status: ' + res.getStatus()
            );
        }

        return (List<Map<String, Object>>)
            JSON.deserializeUntyped(res.getBody());
    }
}
