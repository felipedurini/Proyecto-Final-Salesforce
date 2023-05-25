@isTest
private class TestTaskAssignationService {
	//Test del metodo obtener_Proyecto_Recursos_Tarea
	@isTest
    static void Test_Obtener_Proyecto_Recursos_Tarea(){
        //Inicializar Data
        Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                        Date_End__c = Date.valueOf('2023-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        insert pro;
        
        List<User> usuario_prueba = [SELECT Name
                                     FROM User
                                     WHERE UserRole.Name = 'Developer'];
        
        Project_Resource__c p_r = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                          Date_End__c = Date.valueOf('2023-01-30'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro.Id);
        insert p_r;
        
        Task__c tarea = new Task__c(Date_Start__c = Date.valueOf('2023-01-02'), 
                                    Date_End__c = Date.valueOf('2023-01-12'),
                                	Project_Resource__c = p_r.Id);
        
		insert tarea;
        
        //Ejecutar Prueba
        Test.startTest();
        TaskAssignationService servicio = new TaskAssignationService();
        TaskAssignationService.Proyecto_Recursos_Tareas insertada = servicio.obtener_Proyecto_Recursos_Tarea(pro.Id);
        Test.stopTest();
        
        //Verificar Resultados
        System.assertEquals(pro.Id,insertada.proyecto.Id);
        List<Project_Resource__c> p_r_Lista = [SELECT Name, Resource__c, Project__c
                                               FROM Project_Resource__c
                                               WHERE Project__c =:pro.Id];
        
        Map<Id, Project_Resource__c> id_pr_mapa = new Map<Id, Project_Resource__c>(p_r_Lista);
        if(p_r_Lista.size() == insertada.proyecto_recursos_lista.size()){
           for(Project_Resource__c pr:insertada.proyecto_recursos_lista){
           		System.assertEquals(True, id_pr_mapa.containsKey(pr.Id));
           }
        }
        
        System.assertEquals(1,insertada.tareas.size());
        System.assertEquals(tarea.Id, insertada.tareas[0].Id);
        
    }   
    
    //Test del metodo obtener_Proyecto_Recursos_Tarea
	@isTest
    static void registrar_tareas(){
        //Inicializar Data
        //Inicializar Data
        Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                        Date_End__c = Date.valueOf('2023-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        insert pro;
        
        List<User> usuario_prueba = [SELECT Name
                                     FROM User
                                     WHERE UserRole.Name = 'Developer'];
        
        Project_Resource__c p_r = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                          Date_End__c = Date.valueOf('2023-01-30'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro.Id);
        insert p_r;
        
        String strJSON = '[' +
            				 '{' +
                                 '"Project_Resource__c": "' + p_r.Id + '",' +
                                 '"Name": "Tarea de Prueba",' +
            					 '"Description__c": "Esta es una Tarea de Prueba",' +
            					 '"Date_Start__c": "2023-01-02",' +
            					 '"Date_End__c": "2023-01-12",' +
            					 '"Assigned_Hours__c": "72",' +
								 '"Status__c": "Not Started"' +
            				 '}' +
                 		 ']';
		/* 
        Project_Resource__c:
        Name:
		Description__c:
		Date_Start__c:
		Date_End__c:
		Assigned_Hours__c:
        Status__c:
        */
        
        //Ejecutar Prueba
        Test.startTest();
        TaskAssignationService.registrar_tareas(strJSON);
        Test.stopTest();
        
        
        //Verificar Resultados
        List<Task__c> tareas_Lista = [SELECT Name
                                      FROM Task__c
                                      WHERE Project_Resource__c =:p_r.Id];
        
        System.assertEquals('Tarea de Prueba', tareas_Lista[0].Name);
        
    }
    
}