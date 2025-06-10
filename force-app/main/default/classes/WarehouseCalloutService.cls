public with sharing class WarehouseCalloutService {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void getEquipments() {
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        
        try {
            HttpResponse response = http.send(request);
            
            List<Product2> lstEquipments = new List<Product2>();
            
            if (response.getStatusCode() == 200){
                List<EquipmentDTO> lstDtos = EquipmentDTO.fromJson(response.getBody());
                
                for (EquipmentDTO dto : lstDtos) {
                    if (dto.sku == null || dto.sku.trim().equals('')) {
                        System.debug('Registro ignorado por falta de SKU: ' + dto);
                        continue;
                    }
                    
                    Product2 eq = new Product2();
                    eq.ProductCode = dto.id;
                    eq.Name = dto.name;
                    eq.Replacement_Part__c = dto.replacement;
                    eq.Cost__c = dto.cost;
                    eq.Current_Inventory__c = dto.quantity;
                    eq.Lifespan_Months__c = dto.lifespan;
                    eq.Maintenance_Cycle__c = dto.maintenanceperiod;
                    eq.StockKeepingUnit = dto.sku;
                    
                    lstEquipments.add(eq);
                }
                
                if (!lstEquipments.isEmpty()) {
                    upsert as user lstEquipments;
                }
            } else {
                System.debug('Erro na resposta do callout: ' + response.getStatusCode() + ' - ' + response.getBody());
            }
        } catch (Exception e) {
            System.debug('Erro no callout: ' + e.getMessage());
        }
    }
}