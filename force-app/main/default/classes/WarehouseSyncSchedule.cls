public with sharing class WarehouseSyncSchedule implements Schedulable {
    // implement scheduled code here
    
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new WarehouseCalloutService());
    }
}