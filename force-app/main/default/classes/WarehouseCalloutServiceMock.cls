@isTest
public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    
    public static HttpResponse respond(HttpRequest request) {
        
        System.assertEquals('https://th-superbadge-apex.herokuapp.com/equipment', request.getEndpoint(), 'Endpoint esperado.');
        System.assertEquals('GET', request.getMethod(), 'Método HTTP esperado.');
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"}]');
        response.setStatusCode(200);
        
        return response;
    }
    
}