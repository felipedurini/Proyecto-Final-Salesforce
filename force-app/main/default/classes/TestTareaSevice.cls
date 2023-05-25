@isTest
public class TestTareaSevice {
	//Test del metodo obtener_Tareas
    @isTest
    static void Test_obtener_Tareas(){
        Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                        Date_End__c = Date.valueOf('2023-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        insert pro;
        
        
        Project_Resource__c p_r = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                          Date_End__c = Date.valueOf('2023-01-30'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = UserInfo.getUserId(),
                                                          Project__c = pro.Id);
        insert p_r;
        
		Task__c tarea = new Task__c(Date_Start__c = Date.valueOf('2023-01-02'), 
                                    Date_End__c = Date.valueOf('2023-01-12'),
                                	Project_Resource__c = p_r.Id);
        
		insert tarea;
        
        //Ejecutar Prueba
        Test.startTest();
        TareasSevice servicio = new TareasSevice();
        TareasSevice.Tareas insertada = servicio.obtener_Tareas();
        Test.stopTest();
        
        //Verificar Resultados
        System.assertEquals(True, insertada.id_proyecto_tareas_mapa.containsKey('Project of: Prueba'));
        System.assertEquals(tarea.Id, insertada.id_proyecto_tareas_mapa.get('Project of: Prueba')[0].Id);
        
    }
    
    @isTest
    static void Test_registrar_Horas(){
        
        Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                        Date_End__c = Date.valueOf('2023-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        insert pro;
        
        
        Project_Resource__c p_r = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                          Date_End__c = Date.valueOf('2023-01-30'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = UserInfo.getUserId(),
                                                          Project__c = pro.Id);
        insert p_r;
        
		Task__c tarea = new Task__c(Date_Start__c = Date.valueOf('2023-01-02'), 
                                    Date_End__c = Date.valueOf('2023-01-12'),
                                    Worked_Hours__c = 0,
									Status__c = 'Not Started',
                                	Project_Resource__c = p_r.Id);
        
		insert tarea;
        
        String strJSON = '{' +
                			 '"Id": "' + tarea.Id + '",' +
                			 '"Worked_Hours__c": "12"' +
                		  '}';
        	
        
        //Ejecutar Prueba
        Test.startTest();
        TareasSevice.registrar_Horas(strJSON);
        Test.stopTest();
        
        //Verificar Resultados
        List<Task__c> tareas_lista = [SELECT Name, Status__c, Worked_Hours__c
                                      FROM Task__c
                                      WHERE Id = :tarea.Id];
        
        System.assertEquals('In Progress', tareas_lista[0].Status__c);
        System.assertEquals(12, tareas_lista[0].Worked_Hours__c.intValue());
    }
}