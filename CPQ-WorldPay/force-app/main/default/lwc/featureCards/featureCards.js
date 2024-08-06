import { LightningElement, api } from 'lwc';

const columns = [
    { label: 'Product Name', fieldName: 'name' },
    { label: 'Product Code', fieldName: 'code' },
    { label: 'Description', fieldName: 'description' },
    { label: 'Bundled', fieldName: 'bundled', type: 'booelan' },
];

export default class FeatureCards extends LightningElement {
    @api
    featuredetails;
    columns=columns;
    connectedCallback(){
        this.featureName=this.featuredetails.name;
        this.data=this.featuredetails.products;
    }
}