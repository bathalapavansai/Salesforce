@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    @isTest
    static void testSchedule(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

		String cron='0 0 1 * * ?';
        Test.startTest();
    
          String jobId = System.schedule('WarehouseSyncScheduleJob'+System.now(),cron,new WarehouseSyncSchedule());
    
          CronTrigger ct = [SELECT Id, CronExpression,CronJobDetail.Name, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
    
          System.assertEquals(cron,ct.CronExpression,'Cron Expression not matching');
    
          System.assertEquals(0, ct.TimesTriggered,'Job already executed');
    
       Test.stopTest();

	}
    
}