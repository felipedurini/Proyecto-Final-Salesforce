public class TaskTrigger {
	
    public static void filtrar(List<Task__c> TN, List<Task__c> TO){
        
        Map<Id, Task__c> id_tareas_mapa = new Map<Id, Task__c>(TO);
        List<Task__c> filtrado_TN = new List<Task__c>();
        for(Task__c t: TN){
            if((id_tareas_mapa.get(t.Id).Status__c != 'Completed') && t.Status__c == 'Completed'){
                filtrado_TN.add(t);
            }
        }
        
        if(!filtrado_TN.isEmpty()){
            publicar_Slack(filtrado_TN);
        }
    }
    
    public static void publicar_Slack(List<Task__c> filtrado_TN){
        
        List<Task__c> tareas_completas_Lista = [SELECT Name, Project__r.Name, Project_Resource__r.Resource__r.Name
                                                FROM Task__c
                                                WHERE Id IN :filtrado_TN];
        
        for(Task__c t: tareas_completas_Lista){
            String mensaje = t.Project_Resource__r.Resource__r.Name + ' termino la tarea: ' + t.Name.toUpperCase() +
                			 ' del proyecto "' + t.Project__r.Name + '"';
            
            PublishToSlack.publish_To_Slack(mensaje);
        }    
        
    }
}