import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getTareas from '@salesforce/apex/Controlador.getTareas';
import setTareas from '@salesforce/apex/Controlador.setTareas';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class TaskLoading extends NavigationMixin(LightningElement) {

    @api recordId;
    isLoading = true;
    resources;
    resCombo;
    selectedResource;
    taskName;
    taskDescription;
    minDate;
    maxDate;
    selectedDateFrom;
    selectedDateTo;
    @track hours;
    status;
    project;
    inProgress = false;
    notProgress = false;
    refreshTasks;

    @wire(getTareas, { proId: '$recordId' })
    wiredTasks( result ) {

        this.refreshTasks = result;

        const { data, error } = result;

        if (data) {

            this.refreshTasks = data;

            this.project = data.proyecto;

            this.isLoading = false;

            if(this.project.Status__c == "In Progress"){

                this.inProgress = true;

            }else{

                this.notProgress = true;

            }
            
            this.resources = [];
            this.resources = data.proyecto_recursos_lista;

            console.log('acÃ¡ estan los datos');
            console.log(data);

            this.resCombo = [];

            for(let ids of this.resources){

                this.resCombo.push({ label: ids.Resource__r.Name, value: ids.Id });

            }

            this.loadedTasks = []
            this.loadedTasks = data.tareas;

            this.status = 'Not Started'; 

        } else if (error) {

            console.error(error);
        }

    }

    handleResource(event){

        this.selectedResource = event.target.value;

        console.log(event.target.value);
        
        this.template.querySelectorAll('.clearClass').forEach(element => {
            element.value = '';})

            const resourceWithTasks = this.loadedTasks.find(resource => resource.Project_Resource__c === this.selectedResource); 

            if (resourceWithTasks) {
    
                this.minDate = new Date(resourceWithTasks.Date_Start__c).toISOString().slice(0, 10);
                this.maxDate = new Date(resourceWithTasks.Date_End__c).toISOString().slice(0, 10);
    
            }else{

                const resourceToUse = this.resources.find(resource => resource.Id === this.selectedResource);

                this.minDate = new Date(resourceToUse.Date_Start__c).toISOString().slice(0, 10);
                this.maxDate = new Date(resourceToUse.Date_End__c).toISOString().slice(0, 10);
            }

    }

    handleTask(event){

        this.taskName = event.target.value;
    }

    handleDescription(event){

        this.taskDescription = event.target.value;
    }

    handleFrom(event){

        this.selectedDateFrom = event.target.value;

        this.handleHours(this.selectedDateFrom, this.selectedDateTo);

    }

    handleTo(event){

        this.selectedDateTo = event.target.value;

        this.handleHours(this.selectedDateFrom, this.selectedDateTo);

    }

    handleHours(selectedDateFrom, selectedDateTo){

        const startDate = new Date(selectedDateFrom);
        const endDate = new Date(selectedDateTo);
      
        let result = 0;
        let currentDate = new Date(startDate.getTime());
      
        while (currentDate <= endDate) {

            currentDate.setDate(currentDate.getDate() + 1);
            const weekDay = currentDate.getDay();
            if (weekDay !== 0 && weekDay !== 6) {
                result++;
            }

        }
      
        this.hours = result*8;
    }

    handleSubmit() {
    
        console.log('boton');

        const task = [{ Project_Resource__c: this.selectedResource, Name: this.taskName, Description__c: this.taskDescription, Date_Start__c: this.selectedDateFrom, Date_End__c: this.selectedDateTo, Assigned_Hours__c: this.hours, Status__c: this.status, Project__c: this.project.Id }];

        console.log(JSON.stringify(task));

        setTareas( {  strJSON : JSON.stringify(task) } )
        .then(()=>{

            const event = new ShowToastEvent({

                title: 'Task Created!',
                message: `You've succesfully created the task.`,
                variant: 'success'
            });
            this.dispatchEvent(event);

            let combobox = this.template.querySelector('lightning-combobox');
            combobox.value = null;

            this.template.querySelectorAll('.clearClass').forEach(element => {
                element.value = '';})

            refreshApex(this.refreshTasks);

        })
        .catch((error)=>{

            const event = new ShowToastEvent({

                title: `Error - Task couldn't be created.`,
                message: error.body.pageErrors[0].message,
                variant: 'error'
            });
            this.dispatchEvent(event);
        });

    }

    navigateToTaskTab() {

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task__c',
                actionName: 'home',
            },
        });
    }

}