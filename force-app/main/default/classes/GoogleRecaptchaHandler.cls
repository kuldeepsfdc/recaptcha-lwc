public with sharing class GoogleRecaptchaHandler {

    @AuraEnabled
    public static List<String> fetchBaseURL() {
        List<String> allowedURLs = new List<String>();

        allowedURLs.add(URL.getOrgDomainUrl().toExternalForm());
        allowedURLs.add(URL.getSalesforceBaseUrl().toExternalForm());
        allowedURLs.add(URL.getOrgDomainUrl().toExternalForm().replace('https://d5i00000cydq7ean-dev-ed.develop.my.salesforce.com'));
        allowedURLs.add(URL.getOrgDomainUrl().toExternalForm().replace('https://d5i00000cydq7ean-dev-ed.develop.my.salesforce.com'));

        return allowedURLs;
    }
        
    @AuraEnabled
    public static Boolean isVerified(String recaptchaResponse, String recaptchaSecretKey){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.google.com/recaptcha/api/siteverify');
        request.setMethod('POST');
        request.setBody('secret=' + recaptchaSecretKey + '&response=' + recaptchaResponse);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            System.debug(response.getBody());
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            if (result.containsKey('success') && result.get('success') == true) {                
                return true;      
            } else {
                return false;
            }
        }
        
        return false;
    }
}
