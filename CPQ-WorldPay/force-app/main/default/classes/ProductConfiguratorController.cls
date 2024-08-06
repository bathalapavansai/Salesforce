public with sharing class ProductConfiguratorController {
    @AuraEnabled(cacheable=true)
    public static String  getChildProducts(Id recordId) {
        List<SBQQ__ProductOption__c> productOptions= [Select id,SBQQ__ConfiguredSKU__r.Name,SBQQ__Feature__c,SBQQ__Feature__r.Name,SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.ProductCode,SBQQ__OptionalSKU__r.Description,SBQQ__Bundled__c  from SBQQ__ProductOption__c where SBQQ__ConfiguredSKU__c=:recordId WITH SECURITY_ENFORCED];
        String productName;
        Map<String,Feature> featureMap=new Map<String,Feature>(); 
        for(SBQQ__ProductOption__c productOption:productOptions){
            if(String.isBlank(productName)){
                productName=productOption.SBQQ__ConfiguredSKU__r.Name;
            }
            Product productDetail=new Product();
            productDetail.id=productOption.SBQQ__OptionalSKU__c;
            productDetail.name=productOption.SBQQ__OptionalSKU__r.Name;
            productDetail.code=productOption.SBQQ__OptionalSKU__r.ProductCode;
            productDetail.description=productOption.SBQQ__OptionalSKU__r.Description;
            productDetail.bundled=productOption.SBQQ__Bundled__c;

            if(featureMap.containsKey(productOption.SBQQ__Feature__c)){
                Feature feature=featureMap.get(productOption.SBQQ__Feature__c);
                feature.products.add(productDetail);
                featureMap.put(productOption.SBQQ__Feature__c,feature);
            }
            else{
                Feature feature=new Feature();
                feature.id=productOption.SBQQ__Feature__c;
                feature.name=productOption.SBQQ__Feature__r.Name;
                feature.products=new List<Product>{productDetail};
                featureMap.put(productOption.SBQQ__Feature__c,feature);
            }
        }
        ProductDetail prodDetail=new ProductDetail();
        prodDetail.id=recordId;
        prodDetail.name=productName;
        prodDetail.features=new List<Feature>();
       	prodDetail.features=featureMap.values();
        return JSON.serialize(prodDetail);
    }

    Class ProductDetail{
        String id;
        String name;
        List<Feature> features;
    }

    Class Feature{
        String id; 
        String name;
        List<Product> products;
    }

    Class Product{
        String id;
        String name;
        String code;
        String description;
        Boolean bundled;
    }
}