import { LightningElement, track, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import ToastLine from '@salesforce/resourceUrl/ToastLine';

export default class PopUp extends LightningElement {

    @api user;
    @api dates;
    popUpBody;
    popUpDates;

    @track isModalOpen = false;

    openModal() {

        this.isModalOpen = true;

        const index = Object.keys(this.dates).indexOf(`${this.user}`);

        const filteredDates = Object.values(this.dates)[index];

            if(filteredDates.length == 0){

                console.log('if');
    
                this.popUpBody = 'The Resource is free over the duration of this project.'
            }
            else{

                console.log('else');

                this.popUpBody = `The resource can't be allocated on the following dates:\n`
                this.popUpDates = ''

                for(let item of filteredDates){

                    this.popUpDates += `[${item.Date_Start__c} - ${item.Date_End__c}]\n`

                }
                    
            }
        
    }

    closeModal(){

        this.isModalOpen = false;
    }

    renderedCallback() {

        loadStyle(this, ToastLine)
        .then(() => console.log('Files loaded.'))
        .catch(error => console.log("Error " + error.body.message))

    }
}