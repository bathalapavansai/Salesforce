import { LightningElement, api, wire } from 'lwc';
import getProducts from '@salesforce/apex/ProductConfiguratorController.getChildProducts';

export default class ProductConfigurator extends LightningElement {
    @api
    recordId;
    loaded=false;
    hasChildProducts=false;
    
    productName='';
    features;
    
    @wire(getProducts,{recordId:'$recordId'})
    wiredProducts({ error, data }) {
        if (data) {
            console.log(data);
            let productInfo=JSON.parse(data);
            this.productName=productInfo.name;
            this.features=productInfo.features;
            this.hasChildProducts=true;
            this.loaded=true;
        } else if (error) {
            // handle error
        }
    }
}