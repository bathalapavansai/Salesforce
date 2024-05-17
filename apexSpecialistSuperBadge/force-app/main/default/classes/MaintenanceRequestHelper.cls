public with sharing class MaintenanceRequestHelper {
    
    public static void beforeUpdate(Map<Id,Case> oldMap,Map<Id,Case> newMap){
        createFutureCheckupCases(oldMap,newMap);
    }
    
    static void createFutureCheckupCases(Map<Id,Case> oldMap,Map<Id,Case> newMap){
        List<Case> routineCheckupCases= new List<Case>();
        Map<Id,Case> caseWithItems=new Map<Id, Case>([SELECT Id,(SELECT Id,Equipment__c,equipment__r.Maintenance_Cycle__c  FROM Equipment_Maintenance_Items__r) FROM Case WHERE id IN :newMap.KeySet()]);

        for(Id caseId:newMap.keySet()){
            Case caseRec=newMap.get(caseId);
            Case caseRecOld=oldMap.get(caseId);
            if(caseRecOld.Status==caseRec.status || caseRec.Status!='Closed' || (caseRec.Type!='Repair' && caseRec.Type!='Routine Maintenance') ){
                return;
            }
            Integer maintenanceDays=null;

            for(Equipment_Maintenance_Item__c item:caseWithItems.get(caseRec.Id).Equipment_Maintenance_Items__r){
                if(maintenanceDays==null || maintenanceDays>item.Equipment__r.Maintenance_Cycle__c){
                    maintenanceDays=(Integer)item.Equipment__r.Maintenance_Cycle__c;
                }
            }
            System.debug('maintenanceDays: '+maintenanceDays);
            Case newCase = new Case(Vehicle__c=caseRec.Vehicle__c,Subject='Checkup for '+caseRec.CaseNumber,Type='Routine Maintenance',ParentId=caseRec.Id,Date_Reported__c=System.Today(),Date_Due__c=System.Today().addDays(maintenanceDays));
            routineCheckupCases.add(newCase);
        }
        insert routineCheckupCases;
        insertCaseItems(routineCheckupCases,caseWithItems);
    }
    
    Static void insertCaseItems(List<Case> newCases,Map<Id,Case> newMap){
        List<Equipment_Maintenance_Item__c> routineCheckupItems= new List<Equipment_Maintenance_Item__c>();
        for(Case newCase: newCases){
            Case caseRec=newMap.get(newCase.ParentId);
            for(Equipment_Maintenance_Item__c item:caseRec.Equipment_Maintenance_Items__r){
                routineCheckupItems.add(new Equipment_Maintenance_Item__c(Equipment__c=item.Equipment__c,Maintenance_Request__c=newCase.Id));
            }    
        }
        insert routineCheckupItems;
    }     
    
}