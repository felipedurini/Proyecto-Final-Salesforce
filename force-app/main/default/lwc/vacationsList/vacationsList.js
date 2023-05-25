import { LightningElement, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getVacationByUser from '@salesforce/apex/ProjectsList.getVacationByUser';
import { refreshApex } from '@salesforce/apex';

export default class VacationsList extends LightningElement {

    userId = Id;
    requests = false;
    nothing = true;
    requestList;

    @wire(getVacationByUser, { userId: '$userId' })
    wiredVacations(result){

        this.refreshRequests = result;

        const { error, data } = result;

        if(data){

            if(data.length > 0){

                this.requests = true;
                this.nothing = false;

            }

            this.requestList = data;

            console.log(data);

        }else if(error){

            console.log(error);
        }
    }

    handleRefresh(){

        refreshApex(this.refreshRequests);
    }
}