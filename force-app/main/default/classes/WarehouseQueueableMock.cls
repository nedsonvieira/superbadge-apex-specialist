@isTest
public class WarehouseQueueableMock implements Queueable {
    public static Boolean wasExecuted = false;
    
    public void execute(QueueableContext context) {
        wasExecuted = true;
        System.debug('Mock WarehouseCalloutService foi executado.');
    }
}