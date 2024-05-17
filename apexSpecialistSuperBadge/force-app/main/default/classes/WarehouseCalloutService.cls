public with sharing class WarehouseCalloutService implements Queueable,Database.AllowsCallouts {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    public void execute(QueueableContext context){
        List<Product2> wareHouseItems=new List<Product2>(); 
        HttpRequest req=new HttpRequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');
		req.setHeader('content-type','application/json');
        Http http=new Http();
        HttpResponse response=http.send(req);
        List<InventoryItem> items=(List<InventoryItem>)JSON.deserialize(response.getBody(),List<InventoryItem>.class);
        System.debug(items);
        for(InventoryItem item:items){
            //if(!item.replacement){
              //  continue;
            //}
            Product2 wareHouseProduct=new Product2(Name=item.name,
                                                   QuantityUnitOfMeasure=String.valueOf(item.quantity),
                                                   Replacement_Part__c=item.replacement,
                                                   Warehouse_SKU__c=String.valueOf(item.sku),
                                                   Lifespan_Months__c=item.lifespan,
                                                   Maintenance_Cycle__c=item.maintenanceperiod,
                                                   Cost__c=item.cost);
            wareHouseItems.add(wareHouseProduct);
        }
        Upsert wareHouseItems Warehouse_SKU__c;
    }
    
    Class InventoryItem{
        Boolean replacement;
        Integer quantity;
        String name;
        Integer maintenanceperiod;
        Integer lifespan;
        Integer cost;
        Integer sku;
    }
}