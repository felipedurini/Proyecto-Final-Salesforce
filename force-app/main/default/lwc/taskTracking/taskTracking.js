import { LightningElement, wire } from 'lwc';
import getTareasHoras from '@salesforce/apex/Controlador.getTareasHoras';
import { refreshApex } from '@salesforce/apex';

export default class HoursLoading extends LightningElement {

    projects;
    image = true;
    wiredDataResult;

    @wire(getTareasHoras)
    wiredUserTasks(result) {

        this.wiredDataResult = result;

        const { data, error } = result;

        if (data) {

            this.projects = []

            for (let project in data.id_proyecto_tareas_mapa) {

                console.log('este es el for');
                console.log(data.id_proyecto_tareas_mapa[project]);
                this.projects.push({ project: project, tasks: data.id_proyecto_tareas_mapa[project] });
            }

            if(this.projects.length > 0){

                this.image = false;
            }
            console.log('tareas');
            console.log(JSON.stringify(this.projects));

        }else if(error){

            console.log(error);
        }

    }

    refresh() {

        refreshApex(this.wiredDataResult);
        this.image = true;
    }

}