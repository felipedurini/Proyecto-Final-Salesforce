trigger TriggerTask on Task__c (After update) {
	TaskTrigger.filtrar(Trigger.New, Trigger.Old);
}