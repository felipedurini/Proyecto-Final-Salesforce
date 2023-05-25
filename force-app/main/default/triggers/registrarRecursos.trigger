trigger registrarRecursos on Project_Resource__c (before insert) {
		registrarRecursosTrigger.filtrar(Trigger.New, Trigger.isInsert, Trigger.isUpdate, Trigger.size);   	   	
}








/***
 * trigger registrarRecursos on Project_Resource__c (before insert, before update) {
    	registrarRecursosTrigger.Recursos_Validacion(Trigger.New, Trigger.isInsert, Trigger.isUpdate);   	
	}
 ***/