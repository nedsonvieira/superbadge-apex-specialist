@isTest
private class WarehouseCalloutServiceTest {
    
    @isTest
    static void testWarehouseQueueableExecution() {
        Test.startTest();
        System.enqueueJob(new WarehouseQueueableMock());
        Test.stopTest();
        
        System.assertEquals(true, WarehouseQueueableMock.wasExecuted, 'O job WarehouseQueueableMock deveria ter sido executado.');
    }
}