@isTest
public with sharing class MaintenanceRequestHelperTest {
   
    @isTest
    static void testClosedRequest(){
        Case caseRec=New Case(Origin='Phone',Type='Repair');
        insert caseRec;
        
        Product2 product=new Product2(Name='Gear Rod',QuantityUnitOfMeasure='10',Warehouse_SKU__c='10000',Lifespan_Months__c=100,Cost__c=1000,ProductCode='GR100',Replacement_Part__c=true,Maintenance_Cycle__c=12);
        insert product;
        
        Equipment_Maintenance_Item__c item=new Equipment_Maintenance_Item__c(Quantity__c=10,Equipment__c=product.Id,Maintenance_Request__c=caseRec.Id);
        insert item;
        
        caseRec.Status='Working';
        update caseRec;
        List<Case> newCases=[Select id from case where Type='Routine Maintenance'];
        System.assertEquals(0,newCases.size(),'New case created for non closed case');
        caseRec.Status='Closed';
        update caseRec;
        newCases=[Select id from case where Type='Routine Maintenance'];
        System.assertEquals(1,newCases.size(),'New case not created for closed case');
    }
}