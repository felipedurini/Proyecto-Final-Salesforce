import { LightningElement, api, wire } from 'lwc';
import getRecursos from '@salesforce/apex/Controlador.getRecursos';
import { refreshApex } from '@salesforce/apex';

export default class ResourceContainer extends LightningElement {

    @api recordId;

    resources;
    project;
    users;

    @wire(getRecursos, { proId: '$recordId' })
    wiredResources( result ) {

        this.refreshResources = result;

        const { data, error } = result;

        if (data) {

            this.resources = [];

            for (let role in data.roles_usuarios_map) {
                console.log('este es el for');
                console.log(role);
                console.log(data.roles_usuarios_map[role]);
                this.resources.push({ role: role, users: data.roles_usuarios_map[role] });
            }

            this.project = [];
        
            this.project = data.proyecto;

        }else if (error) {

            console.error(error);
        }

    }

    refresh() {

        return refreshApex(this.refreshResources);
    }

}