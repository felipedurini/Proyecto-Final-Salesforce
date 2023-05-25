import { LightningElement, api, wire } from 'lwc';
import getRecursos from '@salesforce/apex/Controlador.getRecursos';
import setRecursos from '@salesforce/apex/Controlador.setRecursos';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { loadStyle } from 'lightning/platformResourceLoader';
import ToastLine from '@salesforce/resourceUrl/ToastLine';
import { MessageContext, publish } from 'lightning/messageService';
import RMC from '@salesforce/messageChannel/ResourceMessageChannel__c';

export default class ResourceAllocations extends LightningElement {

    @api recordId;
    @wire(MessageContext)
    messageContext;

    isLoading = true;
    resources;
    project;
    users;
    userDates;
    preKickoff = false;
    notKickoff = false;
    clearGrandchildren;

    userToSendArray = [];

    @wire(getRecursos, { proId: '$recordId' })
    wiredResources( result ) {

        this.refreshResources = result;

        const {data, error} = result;

        if(data){

            console.log('acá estan los datos');
            console.log(data);

            this.project = data.proyecto;

            this.userDates = data.usuarios_id_fechas_map;

            this.resources = [];

            this.isLoading = false;

            console.log(this.project.Status__c);

            if(this.project.Status__c == "Pre-Kickoff"){

                this.preKickoff = true;

            }else{

                this.notKickoff = true;

            }

            for(let role in data.roles_usuarios_map){

                for(let prt of this.project.Project_Roles__r){

                    if(prt.Role__c == role){

                        const totalHours = prt.Quantity_Of_Hours__c;

                        for(let prh in data.roles_horas_asignadas_proyecto){

                            if(prh == role){
            
                                const assignedHours = data.roles_horas_asignadas_proyecto[role];
            
                                this.resources.push({ role: role, users: data.roles_usuarios_map[role], total: totalHours, hours: assignedHours });
                            }
                            
                        }
                    }
                }
                
            }

        }else if(error){

            console.error(error);
        }

    }

    handleUserToSendChange(event){
        
        const found = this.userToSendArray.find(element => element.Resource__c == event.detail.Resource__c);
        
        if(!Boolean(found)){
            const userToSend = event.detail;
            this.userToSendArray.push(userToSend);
        }
        console.log('usertosen');
        console.log(JSON.stringify(this.userToSendArray));

    }

    handleUserToDelete(event){

        const deleteUser = event.detail;

        const existingIndex = this.userToSendArray.find(element => element.Resource__c == deleteUser);

        this.userToSendArray.splice(this.userToSendArray.indexOf(existingIndex), 1);

        console.log(JSON.stringify(this.userToSendArray));
    }

    handleSubmit(){
    
        console.log('boton');

        console.log(JSON.stringify(this.userToSendArray));

        setRecursos({ strJSON: JSON.stringify(this.userToSendArray) })
        .then((data)=>{

            console.log(data);

            const event = new ShowToastEvent({

                title: 'Hours Allocated!',
                message: `You've succesfully allocated the resource/s.`,
                variant: 'success'
            });
            this.dispatchEvent(event);
            this.userToSendArray = [];
            refreshApex(this.refreshResources);

            this.handleSuccessfulSubmit();

        })
        .catch((error)=>{

            console.log('error');
            console.log(JSON.stringify(error));

            const event = new ShowToastEvent({

                title: `Error - Hour couldn't be allocated.`,
                message: error.body.pageErrors[0].message,
                variant: 'error'
            });
            this.dispatchEvent(event);
        });

    }

    renderedCallback() {

        loadStyle(this, ToastLine)
        .then(() => console.log('Files loaded.'))
        .catch(error => console.log("Error " + error.body.message))

    }

    handleSuccessfulSubmit() {

        const messagePayload = {

            clearInputs: true
        };

        publish(this.messageContext, RMC, {
            payload: messagePayload
        });
        console.log('mensaje enviado');
    }

}