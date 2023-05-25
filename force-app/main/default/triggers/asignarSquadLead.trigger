trigger asignarSquadLead on Project__c (before update) {
	asignarSquadLeadTrigger.filtrar(Trigger.New, Trigger.Old);
}