public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> newOrders, Map<Id,Case> oldOrdersMap) {
        // TODO: Complete the method to update workorders
        Set<Id> validIds = new Set<Id>();
        
        for (Case c : newOrders) {
            if (c.Status == 'Closed' && oldOrdersMap.get(c.Id).Status != 'Closed'
                &&
            (c.Type == 'Repair' || c.Type == 'Routine Maintenance')) {
                validIds.add(c.Id);
            }
        }
        
        if (validIds.isEmpty()) {
            return;
        }
        
        Map<Id, Case> closedRequestsMap = new Map<Id, Case>();
        for (Case c : [
            SELECT Id, Vehicle__c, Product__c,
                (SELECT Id, Equipment__c, Quantity__c 
                 FROM Equipment_Maintenance_Items__r)
            FROM Case 
            WHERE Id IN :validIds WITH SECURITY_ENFORCED
        ]) {
            closedRequestsMap.put(c.Id, c);
        }
        
        Map<Id,Decimal> maintenanceCyclesMap = new Map<ID,Decimal>();
        AggregateResult[] results = [
            SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c)cycle 
            FROM Equipment_Maintenance_Item__c 
            WHERE Maintenance_Request__c IN :ValidIds WITH SECURITY_ENFORCED
            GROUP BY Maintenance_Request__c 
        ];
        
        for (AggregateResult ar : results) {
            Decimal cycle = (Decimal) ar.get('cycle');
            
            if (cycle != null) {
                maintenanceCyclesMap.put((Id) ar.get('Maintenance_Request__c'), cycle);
            }
        }
        
        
        List<Case> lstNewRequests = new List<Case>();
        
        for (Case c : closedRequestsMap.values()) {
            Case nr = new Case();
            nr.ParentId = c.Id;
            nr.Vehicle__c = c.Vehicle__c;
            nr.Product__c = c.Product__c;
            nr.Subject = 'New Maintenance';
            nr.Type = 'Routine Maintenance';
            nr.Status = 'New';
            nr.Origin = 'Web';
            nr.Date_Reported__c = Date.Today();
            
            if (maintenanceCyclesMap.containsKey(c.Id)) {
                nr.Date_Due__c = Date.today().addDays((Integer) maintenanceCyclesMap.get(c.Id));
            }
            
            lstNewRequests.add(nr);
        }
        
        if (!lstNewRequests.isEmpty()) {
            insert newRequestsLst;
        }
        
        List<Equipment_Maintenance_Item__c> itemsToClone = new List<Equipment_Maintenance_Item__c>();
        for (Case c : newRequestsLst) {
            Case parentRequest = closedRequestsMap.get(c.ParentId);
            
            if (parentCase != null && parentCase.Equipment_Maintenance_Items__r != null) {
                for (Equipment_Maintenance_Item__c item : parentCase.Equipment_Maintenance_Items__r) {
                    Equipment_Maintenance_Item__c clonedItem = new Equipment_Maintenance_Item__c();
                    clonedItem.Maintenance_Request__c = c.Id;
                    clonedItem.Equipment__c = item.Equipment__c;
                    clonedItem.Quantity__c = item.Quantity__c;
                    
                    itemsToClone.add(clonedItem);
                }
            }
        }
        
        if (!itemsToClone.isEmpty()) {
            insert itemsToClone;
        }
    }
}