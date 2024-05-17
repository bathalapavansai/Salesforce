@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
	@isTest
    Static void testCallout(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.StartTest();
        System.enqueuejob(new WarehouseCalloutService());
        Test.StopTest();
        List<Product2> products=[Select Id,QuantityUnitOfMeasure FROM Product2 WHERE Name='Generator 1000 kW'];
        System.assertEquals(5,Integer.valueOf(products[0].QuantityUnitOfMeasure),'Quantity is not matching');
    }
}