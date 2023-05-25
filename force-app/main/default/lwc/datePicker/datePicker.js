import { LightningElement, track, api } from 'lwc';

export default class DatePicker extends LightningElement {

    @api min;
    @api max;
    @track fromDate = '';
    @track toDate = '';
    // minDate;
    // maxDate;

    // renderedCallback() {

    //     // Set the minimum and maximum dates
    //     this.minDate = new Date(this.min).toISOString().split('T')[0];
    //     this.maxDate = new Date(this.max).toISOString().split('T')[0];

    //     // this.minDate = project.Date_Start__c;
    //     // this.maxDate = project.Date_End__c;

    //     console.log('proyecto?');
    //     console.log(JSON.stringify(this.min));
    //     console.log(JSON.stringify(this.max));

    // }

    handleFromDateChange(event) {

        this.fromDate = event.target.value;

        console.log(this.fromDate);

        const sendstartdate = new CustomEvent('sendstartdate', {
            
            detail: {

                selectedStartDate: this.fromDate
            }
        });
        this.dispatchEvent(sendstartdate);

    }

    handleToDateChange(event) {

        this.toDate = event.target.value;

        console.log(this.toDate);

        const sendenddate = new CustomEvent('sendenddate', {
            
            detail: {
    
                selectedEndDate: this.toDate
            }
        });
        
        this.dispatchEvent(sendenddate);

    }

    clearDate() {
        const inputEl = this.template.querySelectorAll('lightning-input');
        console.log(inputEl);
        inputEl[0].value = '';
        inputEl[1].value = '';
    }
}