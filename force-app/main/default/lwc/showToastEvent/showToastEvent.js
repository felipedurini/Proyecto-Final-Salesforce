import { LightningElement } from 'lwc';
import { showToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowToastEvent extends LightningElement {

showToast(){

    const toastEvent = new showToastEvent({

        title: 'Project not completed',
        message: `The project wasn't set as completed because it has unfinished task/s.`,
        variant: 'error'

    })
    this.dispatchEvent(toastEvent)
}

}