import { LightningElement, wire, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductCatalogController.getProducts';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class ProductCatalog extends LightningElement 
{

    searchKey = '';
    products;
    draftValues = [];
    wiredResult;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Family', fieldName: 'Family' },
        { label: 'Active', fieldName: 'IsActive', type: 'boolean', editable: true },
        { label: 'List Price', fieldName: 'ListPrice__c', type: 'number', editable: true }
    ];
    @wire(getProducts, { searchKey: '$searchKey' })
    wiredProducts(result) {
        this.wiredResult = result;
        if (result.data) {
            this.products = result.data;
        }
    }
    handleSearch(event)
    {
        this.searchKey = event.target.value;
    }
    async handleSave(event) 
    {

        const records = event.detail.draftValues.map(draft => ({fields: { ...draft }}));

        try {
            await Promise.all(records.map(record => updateRecord(record)));

            this.dispatchEvent( new ShowToastEvent({title: 'Success',message: 'Products updated successfully',variant: 'success'}));

            this.draftValues = [];
            await refreshApex(this.wiredResult);

        } catch (error)
        {
            this.dispatchEvent(new ShowToastEvent({title: 'Error', message: error.body.message,variant: 'error'}));
        }
    }
}
