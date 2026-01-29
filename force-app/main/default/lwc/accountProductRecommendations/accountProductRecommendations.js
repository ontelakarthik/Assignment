import { LightningElement, api, wire } from 'lwc';
import fetchRecommendations
    from '@salesforce/apex/AccountRecommendationController.fetchRecommendations';
import getRecommendations
    from '@salesforce/apex/AccountRecommendationController.getRecommendations';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class AccountProductRecommendations extends LightningElement {

    @api recordId;

    recommendations;
    error;
    wiredResult;

    // Load existing recommendations
    @wire(getRecommendations, { accountId: '$recordId' })
    wiredRecs(result) {
        this.wiredResult = result;
        if (result.data) {
            this.recommendations = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error.body.message;
            this.recommendations = undefined;
        }
    }

    // Button click
    handleClick() {
        fetchRecommendations({ accountId: this.recordId })
            .then(() => {
                this.showToast(
                    'Success',
                    'Recommendation process started',
                    'success'
                );

                // Wait for Queueable to finish, then refresh
                setTimeout(() => {
                    refreshApex(this.wiredResult);
                }, 3000);
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
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}