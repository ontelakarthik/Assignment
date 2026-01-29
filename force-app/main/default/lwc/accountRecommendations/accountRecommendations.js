import { LightningElement, api, wire } from 'lwc';
import fetchRecommendations
    from '@salesforce/apex/AccountRecommendationController.fetchRecommendations';
import getRecommendations
    from '@salesforce/apex/AccountRecommendationController.getRecommendations';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class AccountRecommendations extends LightningElement {

    @api recordId;
    recommendations;
    wiredResult;

    columns = [
        { label: 'Product', fieldName: 'Product__r.Name' },
        { label: 'Score', fieldName: 'Score__c', type: 'number' },
        { label: 'Date', fieldName: 'Recommendation_Date__c', type: 'date' }
    ];

    @wire(getRecommendations, { accountId: '$recordId' })
    wiredRecs(result) {
        this.wiredResult = result;
        if (result.data) {
            this.recommendations = result.data;
        }
    }

    handleClick() {
        fetchRecommendations({ accountId: this.recordId })
            .then(() => {
                this.showToast(
                    'Success',
                    'Recommendations requested successfully',
                    'success'
                );
                return refreshApex(this.wiredResult);
            })
            .catch(error => {
                this.showToast(
                    'Error',
                    error.body.message,
                    'error'
                );
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }
}