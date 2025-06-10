@isTest
public with sharing class MaintenanceRequestHelperTest {
    
    private static final String STATUS_NEW = 'New';
    private static final String STATUS_WORKING = 'Working';
    private static final String STATUS_CLOSED = 'Closed';
    private static final String TYPE_REPAIR = 'Repair';
    private static final String TYPE_ROUTINE_MAINTENANCE = 'Routine Maintenance';
    private static final String ORIGIN_WEB = 'Web';
    private static final String SUBJECT_TEST = 'Testing subject';
    
    @isTest
    private static void testPositiveMaintenanceRequest() {
        Vehicle__c vehicle = createTestVehicle();
        insert vehicle;
        
        Product2 equipment = createTestEquipment();
        insert equipment;
        
        Case maintenanceRequest = createTestMaintenanceRequest(vehicle.Id, equipment.Id);
        insert maintenanceRequest;
        
        Equipment_Maintenance_Item__c item = createTestItem(equipment.Id, maintenanceRequest.Id);
        insert item;
        
        Test.startTest();
        maintenanceRequest.Status = STATUS_CLOSED;
        update maintenanceRequest;
        Test.stopTest();
        
        Case newRequest = [SELECT Id, Subject, Type, Product__c, Date_Reported__c, Vehicle__c, Date_Due__c 
                          FROM Case 
                          WHERE Status = :STATUS_NEW LIMIT 1];
        
        Equipment_Maintenance_Item__c newItem = [SELECT Id 
                                                    FROM Equipment_Maintenance_Item__c 
                                                    WHERE Maintenance_Request__c = :newRequest.Id LIMIT 1];
        
        System.assertNotEquals(null, newItem, 'Peça de manutenção foi criada');
        System.assertNotEquals(null, newRequest.Subject, 'O campo Subject não é nulo');
        System.assertEquals(TYPE_ROUTINE_MAINTENANCE, newRequest.Type, 'O tipo de requisição deve ser igual a Routine Maintenance');
        System.assertEquals(equipment.Id, newRequest.Product__c, 'O Id do equipamento deve ser igual ao do equipamento da requisição');
        System.assertEquals(vehicle.Id, newRequest.Vehicle__c, 'O Id do veículo deve ser igual ao do veículo da requisição');
        System.assertEquals(System.today(), newRequest.Date_Reported__c, 'A data de relatório deve ser igual a data de hoje');
    }
    
    @isTest
    private static void testNegativeMaintenanceRequest() {
        Vehicle__c vehicle = createTestVehicle();
        insert vehicle;
        
        Product2 equipment = createTestEquipment();
        insert equipment;
        
        Case maintenanceRequest = createTestMaintenanceRequest(vehicle.Id, equipment.Id);
        insert maintenanceRequest;
        
        Equipment_Maintenance_Item__c item = createTestItem(equipment.Id, maintenanceRequest.Id);
        insert item;
        
        Test.startTest();
        maintenanceRequest.Status = STATUS_WORKING;
        update maintenanceRequest;
        Test.stopTest();
        
        List<Case> allRequests = [SELECT Id FROM Case];
        
        Equipment_Maintenance_Item__c existingItem = [SELECT Id 
                                                         FROM Equipment_Maintenance_Item__c 
                                                         WHERE Maintenance_Request__c = :maintenanceRequest.Id LIMIT 1];
        
        System.assertNotEquals(null, existingItem, 'O item de manutenção original deve existir.');
        System.assertEquals(1, allRequests.size(), 'Nenhuma nova solicitação de manutenção deve ser criada.');
    }
    
    @isTest
    private static void testBulkMaintenanceRequest() {
        List<Vehicle__c> lstVehicle = new List<Vehicle__c>();
        List<Product2> lstEquipment = new List<Product2>();
        List<Case> maintenanceRequests = new List<Case>();
        List<Equipment_Maintenance_Item__c> lstItem = new List<Equipment_Maintenance_Item__c>();
        
        for (Integer i = 0; i < 300; i++) {
            lstVehicle.add(createTestVehicle());
            lstEquipment.add(createTestEquipment());
        }
        insert lstVehicle;
        insert lstEquipment;
        
        for (Integer i = 0; i < 300; i++) {
            maintenanceRequests.add(createTestMaintenanceRequest(lstVehicle.get(i).Id, lstEquipment.get(i).Id));
        }
        insert maintenanceRequests;
        
        for (Integer i = 0; i < 300; i++) {
            lstItem.add(createTestItem(lstEquipment.get(i).Id, maintenanceRequests.get(i).Id));
        }
        insert lstItem;
        
        Test.startTest();
        for (Case req : maintenanceRequests) {
            req.Status = STATUS_CLOSED;
        }
        update maintenanceRequests;
        Test.stopTest();
        
        Integer newRequestsCount = [SELECT COUNT() FROM Case WHERE Status = :STATUS_NEW];
        System.assertEquals(300, newRequestsCount, '300 novas solicitações foram criadas corretamente.');
    }
    
    private static Vehicle__c createTestVehicle() {
        return new Vehicle__c(Name = 'Vehicle Test');
    }
    
    private static Product2 createTestEquipment() {
        return new Product2(
            Name = 'Equipment Test',
        Lifespan_Months__c = 10,
        Maintenance_Cycle__c = 10,
        Replacement_Part__c = true
            );
    }
    
    private static Case createTestMaintenanceRequest(Id vehicleId, Id equipmentId) {
        return new Case(
            Type = TYPE_REPAIR,
        Status = STATUS_NEW,
        Origin = ORIGIN_WEB,
        Subject = SUBJECT_TEST,
        Product__c = equipmentId,
        Vehicle__c = vehicleId
            );
    }
    
    private static Equipment_Maintenance_Item__c createTestItem(Id equipmentId, Id requestId) {
        return new Equipment_Maintenance_Item__c(
            Equipment__c = equipmentId,
        Maintenance_Request__c = requestId
            );
    }
}