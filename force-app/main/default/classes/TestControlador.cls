@isTest
public class TestControlador {
	@isTest
    static void Test_getRecursos(){
        //Incializar data
        Project__c pro = new Project__c(Name = 'Proyecto de Prueba');
        
        insert pro;
        
        //Inciar Testeo
        Test.startTest();
        ResourceAllocationService.Proyecto_Recursos_Clase obtenida = Controlador.getRecursos(pro.Id);
        Test.stopTest();
        
        //Validar 
        System.assertEquals(pro.Id, obtenida.proyecto.Id);
    }
    
    @isTest
    static void Test_setRecursos(){
        //Incializar data
        //List<Project_Resource__c> p_r_Lista = new List<Project_Resource__c>{new Project_Resource__c()};
        
        Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                        Date_End__c = Date.valueOf('2023-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        insert pro;
        
        List<User> usuario_prueba = [SELECT Name
                                     FROM User
                                     WHERE UserRole.Name = 'Developer'];
        
        String strJSON = '[' +
            				 '{' +
                                 '"Resource__c": "' + usuario_prueba[0].Id + '",' +
                                 '"Project__c": "' + pro.Id + '",' +
            					 '"Date_Start__c": "2023-01-02",' +
            					 '"Date_End__c": "2023-01-12",' +
            					 '"Hours_Assigned_Resource__c": "120"' +
            				 '}' +
                 		 ']';
        //insert p_r_Lista;
        
        //Inciar Testeo
        Test.startTest();
        Boolean insertada = Controlador.setRecursos(strJSON);
        Test.stopTest();
        
        List<Project_Resource__c> p_r_Lista2 = [SELECT Name, Hours_Assigned_Resource__c
                                                FROM Project_Resource__c]; 
        
        //Validar 
        System.assertEquals(120, p_r_Lista2[0].Hours_Assigned_Resource__c.intValue());
    }
    
    @isTest
    static void Test_getTareas(){
        //Incializar data
        Project__c pro = new Project__c(Name = 'Proyecto de Prueba');
        
        insert pro;
        
        //Inciar Testeo
        Test.startTest();
        TaskAssignationService.Proyecto_Recursos_Tareas obtenida = Controlador.getTareas(pro.Id);
        Test.stopTest();
        
        //Validar 
        System.assertEquals(pro.Id, obtenida.proyecto.Id);
    }
    
    @isTest
    static void Test_setTareas(){
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
            					 '"Assigned_Hours__c": "120",' +
								 '"Status__c": "Not Started"' +
            				 '}' +
                 		 ']';
        
        //Inciar Testeo
        Test.startTest();
        Boolean insertada = Controlador.setTareas(strJSON);
        Test.stopTest();
        
        List<Task__c> p_r_Lista2 = [SELECT Name, Assigned_Hours__c
                                    FROM Task__c]; 
        
        //Validar 
        System.assertEquals(120, p_r_Lista2[0].Assigned_Hours__c.intValue());
    }
    
    @isTest
    static void Test_getTareasHoras(){
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
        
        //Inciar Testeo
        Test.startTest();
        TareasSevice.Tareas obtenida = Controlador.getTareasHoras();
        Test.stopTest();
        
        //Validar 
        System.assertEquals(True, obtenida.id_proyecto_tareas_mapa.containsKey('Project of: Prueba'));
    }
    
    @isTest
    static void Test_setTareasHoras(){
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
        	
        
        //Inciar Testeo
        Test.startTest();
        Boolean insertada = Controlador.setTareasHoras(strJSON);
        Test.stopTest();
        
        List<Task__c> p_r_Lista2 = [SELECT Name, Assigned_Hours__c
                                    FROM Task__c]; 
        
        //Validar Resultados
        List<Task__c> tareas_lista = [SELECT Name, Status__c, Worked_Hours__c
                                      FROM Task__c
                                      WHERE Id = :tarea.Id];
        
        System.assertEquals('In Progress', tareas_lista[0].Status__c);
    }
    
    @isTest
    static void Test_SetTareasEstado(){
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
        
        //Inciar Testeo
        Test.startTest();
        Boolean insertada = Controlador.setTareasEstado(strJSON);
        Test.stopTest();
        
        List<Task__c> p_r_Lista2 = [SELECT Name, Assigned_Hours__c
                                    FROM Task__c]; 
        
        //Validar Resultados
        List<Task__c> tareas_lista = [SELECT Name, Status__c, Worked_Hours__c
                                      FROM Task__c
                                      WHERE Id = :tarea.Id];
        
        System.assertEquals('Completed', tareas_lista[0].Status__c);
    }
}