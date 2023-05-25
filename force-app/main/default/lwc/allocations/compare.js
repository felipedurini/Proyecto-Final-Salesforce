import { LightningElement, api, track, wire } from 'lwc';
import getRecursos from '@salesforce/apex/Controlador.getRecursos';
import setRecursos from '@salesforce/apex/Controlador.setRecursos';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class allocations extends LightningElement {
  
    @api recordId;
    @track selectedValue;
    resources;
    projectDates;
    userDates;
    multipleUsers = [];
    @track isCheckedLead = false;
    @track isChecked = false;
    counterUsers = 0;
    @track workingDays;
    rolesHours;
    //@track dynamicPicker;
    //dates = false;
    // @track minDate;
    // @track maxDate;


    @wire(getRecursos, { proId: '$recordId' })
    wiredResources({ error, data }) {

        if (data) {

            this.resources = [];
            console.log('acÃ¡ estan los datos');
            console.log(data);
            
            this.projectDates = [];
            this.projectDates = data.proyecto;

            this.projectDates = [];
            this.userDates = data.usuarios_id_fechas_map;


            let i=0;

            
            for (let role in data.roles_usuarios_map) {
                
                console.log('este es el for');
                console.log(role);
                console.log(data.roles_usuarios_map[role]);
                let arrOfUsers = []
                //i do all this to create the cssClass field. salesforce makes their objects a proxy if you manipulate them. so i have to stringify and parse everything
                for (let user of data.roles_usuarios_map[role]){
                    let stringU = JSON.stringify(user)
                    stringU=JSON.parse(stringU)
                    stringU.cssClass = 'a' + stringU.Id;
                    arrOfUsers.push(stringU); 
                }
                arrOfUsers = JSON.stringify(arrOfUsers);
                arrOfUsers = JSON.parse(arrOfUsers);
                this.resources[i]={ role: role, users: arrOfUsers, assigned: data.roles_horas_asignadas_proyecto[`${role}`]};
                for(let pr of data.proyecto.Project_Roles__r){
                    if(this.resources[i].role === pr.Role__c)
                    this.resources[i].Quantity_Of_Hours__c = pr.Quantity_Of_Hours__c
                }

                // if (typeof data.roles_horas_asignadas_proyecto === 'object') {
                //     const roles_horas_asignadas_proyecto_array = Array.isArray(data.roles_horas_asignadas_proyecto)
                //       ? data.roles_horas_asignadas_proyecto
                //       : [data.roles_horas_asignadas_proyecto];
                  
                //     for (let rh of roles_horas_asignadas_proyecto_array) {
                //       if (this.resources[i].role === rh.key) {
                //           this.resources[i].HoursLeft = this.resources[i].Quantity_Of_Hours__c - rh.value; 
                //           this.resources[i].HoursLeft = this.resources[i].Quantity_Of_Hours__c - rh.value; 
                //     }
                //       console.log(rh);
                //     }
                // }

                // for(let rh of data.roles_horas_asignadas_proyecto){
                //     if(this.resources[i].role === rh.key)
                //     this.resources[i].HoursLeft = this.resources[i].Quantity_Of_Hours__c - rh.value; 
                //     console.log(rh);
                // }
                i++;
            }

        } else if (error) {

            console.error(error);
        }

    }

    handleCheckboxChange(event) {

        this.isChecked = event.target.checked;
    
        if (this.isChecked) {
            
            const found = this.multipleUsers.find(element => element.Resource__c == event.target.value);
            if(!Boolean(found)){
            let userToSend = { Resource__c: event.target.value, Project__c: this.recordId };
            this.multipleUsers.push(userToSend);
            }

            //this variable will be used to count the checks and to validate that the checked users are the same as the ones in the sent array
            this.counterUsers++;
            
            this.dynamicPicker = 'a' + event.target.value
            console.log(this.counterUsers);
            console.log('inside check true');
            console.log(JSON.stringify(this.multipleUsers));
    
        }else{

            const found = this.multipleUsers.find(element => element.Resource__c == event.target.value);
            const index = this.multipleUsers.indexOf(found);
            this.multipleUsers.splice(index, 1);
            this.counterUsers--;

            //cuando deselecciono el user se borra la fecha
            
            /* let datePicker = this.template.querySelector(`#start`)
            console.log(datePicker);
            datePicker.value = ''; */
        } 
    }

    getWorkingDays(startDateStr, endDateStr) {
        // Convert date strings to Date objects
        const startDate = new Date(startDateStr);
        const endDate = new Date(endDateStr);
      
        let result = 0;
        let currentDate = new Date(startDate.getTime());
      
        while (currentDate <= endDate) {
          currentDate.setDate(currentDate.getDate() + 1);
          const weekDay = currentDate.getDay();
      
          if (weekDay !== 0 && weekDay !== 6) {
            result++;
          } 
        }
        return result*8;
      }

    updateStartDate(event) {  
        //checks if an object with the user id exists in the array
        const found = this.multipleUsers.find(element => element.Resource__c == event.target.value);
        //if it doesnt, found is undefined, therefore it creates an object with the user id and the startdate and pushes it to multipleusers
        if(!Boolean(found)){
        let userToSend = { Resource__c: event.target.value, Project__c: this.recordId };
        userToSend.Date_Start__c = event.detail.selectedStartDate;
        this.multipleUsers.push(userToSend);
        console.log(JSON.stringify(this.multipleUsers));
        } 
        //if it isnt undefined it means found exists and has an id value so it sets its startdate
        found.Date_Start__c = event.detail.selectedStartDate;
        //if user has enddate, calculate working hours (from mon to fri * 8)
        if(Boolean(found.Date_End__c)){
            found.Hours_Assigned_Resource__c = this.getWorkingDays(found.Date_Start__c, found.Date_End__c)
        }

        console.log(JSON.stringify(this.multipleUsers));
    }


    updateEndDate(event) {
        const found = this.multipleUsers.find(element => element.Resource__c == event.target.value);

        if(!Boolean(found)){
            let userToSend = { Resource__c: event.target.value, Project__c: this.recordId };
            userToSend.Date_End__c = event.detail.selectedEndDate;
            this.multipleUsers.push(userToSend);
            console.log(JSON.stringify(this.multipleUsers));
        } 
        
        found.Date_End__c = event.detail.selectedEndDate;
        if(Boolean(found.Date_Start__c)){
            found.Hours_Assigned_Resource__c = this.getWorkingDays(found.Date_Start__c, found.Date_End__c)
        }
        console.log(JSON.stringify(this.multipleUsers));
    }

    handleSelected(event){
        this.isCheckedLead = event.target.checked;
        this.selectedValue = this.isChecked ? event.target.value : null;
      }

    handleSubmit(){
       /*  console.log(this.multipleUsers.length);
        console.log(JSON.stringify(this.multipleUsers)); */

        console.log(this.counterUsers);
        console.log('multiple length');
        console.log(this.multipleUsers.length);
        
            //to check if all the fields are completed, it multiplies the array by the required fields (4)
            const valuesToHave = this.multipleUsers.length * 5
            let counter = 0
            for (let user of this.multipleUsers){
                for(let item in user){
                    counter++
                }
            }
            if (counter < valuesToHave) {
                console.log('primer if');
                const event = new ShowToastEvent({
                    title: `Missing something?`,
                    message: `Please complete all the fields of the users you want to allocate.`,
                    variant: 'warning'
                });
                this.dispatchEvent(event);
            }
            //al users must have check
            else if(this.multipleUsers.length > this.counterUsers || this.multipleUsers.length ===0){
                console.log('else if');
                const event = new ShowToastEvent({
                    title: `Missing something?`,
                    message: `Please check all the users you want to allocate.`,
                    variant: 'warning'
                });
                this.dispatchEvent(event);
            }
            else{

                setRecursos( {  strJSON : JSON.stringify(this.multipleUsers) } )
                
                .then(()=>{

                    const event = new ShowToastEvent({

                        title: 'Resources Allocated!',
                        message: `You've succesfully assigned the resources to the current proyect.`,
                        variant: 'success'
                    });
                    this.dispatchEvent(event);
                    //timeout to refresh the page so that assigned users dissapear
                    setTimeout(() => {
                        location.reload();
                    }, 2000);
                })
                .catch((error)=>{

                    console.log('error');
                    console.log(error);

                    const event = new ShowToastEvent({

                        title: `Error - Resources couldn't be inserted.`,
                        message: error.body.pageErrors[0].message,
                        variant: 'error'
                    });
                    this.dispatchEvent(event);
                });
            }

    }

}