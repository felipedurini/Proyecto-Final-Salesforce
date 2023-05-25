@isTest
public class TestResourceAllocationService {
	//Test del metodo obtener_Proyecto_Recursos
	@isTest
    static void Test_obtener_Proyecto_Recursos_Clase(){
        //Inicializar Data
        Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2025-01-01'),
                                        Date_End__c = Date.valueOf('2025-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        
        Project__c pro2 = new Project__c(Date_Start__c = Date.valueOf('2024-01-01'),
                                        Date_End__c = Date.valueOf('2025-03-02'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba2');
        
        List<Project__c> pro_Lista = new List<Project__c>{pro};
        pro_Lista.add(pro2);
        
        insert pro_Lista;
        
        Project_Role__c pro_role = new Project_Role__c(Role__c = 'Developer',
                                                       Total_Price__c = 500000,
                                                       Quantity_Of_Hours__c = 5000,
                                                       Project__c = pro_Lista[0].Id);
        
        Project_Role__c pro_role2 = new Project_Role__c(Role__c = 'Consultant',
                                                       Total_Price__c = 500000,
                                                       Quantity_Of_Hours__c = 5000,
                                                       Project__c = pro_Lista[0].Id);
        
        List<Project_Role__c> pro_role_Lista = new List<Project_Role__c>{pro_role};
        pro_role_Lista.add(pro_role2);
            
        insert pro_role_Lista;
        
        List<User> usuario_prueba = [SELECT Name
                                     FROM User
                                     WHERE UserRole.Name = 'Developer'];
        
        List<User> usuario_prueba2 = [SELECT Name
                                      FROM User
                                      WHERE UserRole.Name = 'Consultant'];
        
        Project_Resource__c p_r = new Project_Resource__c(Date_Start__c = Date.valueOf('2025-01-01'), 
                                                          Date_End__c = Date.valueOf('2025-01-15'), 
                                                          Hours_Assigned_Resource__c = 300,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro_Lista[0].Id);
        
        Project_Resource__c p_r2 = new Project_Resource__c(Date_Start__c = Date.valueOf('2025-01-16'), 
                                                          Date_End__c = Date.valueOf('2025-01-30'), 
                                                          Hours_Assigned_Resource__c = 300,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro_Lista[0].Id);
        
        Project_Resource__c p_r3 = new Project_Resource__c(Date_Start__c = Date.valueOf('2024-01-01'), 
                                                          Date_End__c = Date.valueOf('2025-03-02'), 
                                                          Hours_Assigned_Resource__c = 300,
                                                          Resource__c = usuario_prueba2[0].Id,
                                                          Project__c = pro_Lista[1].Id);
        
        
        List<Project_Resource__c> p_r_Lista2 = new List<Project_Resource__c>{p_r, p_r2, p_r3};
        //p_r_Lista.add(p_r2);
        
        insert p_r_Lista2;
        
        //Ejecutar Prueba
        Test.startTest();
		ResourceAllocationService servicio = new ResourceAllocationService();
        ResourceAllocationService.Proyecto_Recursos_Clase insertada = servicio.obtener_Proyecto_Recursos_Clase(pro_Lista[0].Id);
        Test.stopTest();
        
        //Verificar Resultados
        System.assertEquals(pro_Lista[0].Id,insertada.proyecto.Id);
        //System.assertEquals(null,pro.Id);
        List<Project_Resource__c> p_r_Lista = [SELECT Name, Resource__c, Project__c
                                               FROM Project_Resource__c];
        
        if(insertada.roles_usuarios_map.containsKey('Developer')){
            System.assertEquals(2, insertada.roles_usuarios_map.get('Developer').size());
            System.assertEquals(usuario_prueba[0].Id, insertada.roles_usuarios_map.get('Developer')[0].Id);
        }else{
            System.assertEquals(True, insertada.roles_usuarios_map.containsKey('Developer'));
        }
        
        if(insertada.usuarios_id_fechas_map.containsKey(usuario_prueba[0].Id)){
            System.assertEquals(2, insertada.usuarios_id_fechas_map.get(usuario_prueba[0].Id).size());
            Map<Id, Project_Resource__c> id_pr_mapa = new Map<Id, Project_Resource__c>
                										     (insertada.usuarios_id_fechas_map.get(usuario_prueba[0].Id));
            System.assertEquals(True, id_pr_mapa.containsKey(p_r_Lista2[0].Id));
            System.assertEquals(True, id_pr_mapa.containsKey(p_r_Lista2[1].Id));
            //System.assertEquals(p_r_Lista2[0].Id, insertada.usuarios_id_fechas_map.get(usuario_prueba[0].Id)[0].Id);
            //System.assertEquals(p_r_Lista2[1].Id, insertada.usuarios_id_fechas_map.get(usuario_prueba[0].Id)[1].Id);
        }else{
            System.assertEquals(True, insertada.usuarios_id_fechas_map.containsKey(usuario_prueba[0].Id));
        }
        
    }
    
    @isTest
    static void Test_obtener_Proyecto_Recursos_Clase2(){
        //Inicializar Data
        Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2025-01-01'),
                                        Date_End__c = Date.valueOf('2025-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        
        insert pro;
        
        Project_Role__c pro_role = new Project_Role__c(Role__c = 'Developer',
                                                       Total_Price__c = 500000,
                                                       Quantity_Of_Hours__c = 5000,
                                                       Project__c = pro.Id);
        
            
        insert pro_role;
        
        List<User> usuario_prueba = [SELECT Name
                                     FROM User
                                     WHERE UserRole.Name = 'Developer'];      
        
        //Ejecutar Prueba
        Test.startTest();
		ResourceAllocationService servicio = new ResourceAllocationService();
        ResourceAllocationService.Proyecto_Recursos_Clase insertada = servicio.obtener_Proyecto_Recursos_Clase(pro.Id);
        Test.stopTest();
        
        //Verificar Resultados
        System.assertEquals(pro.Id,insertada.proyecto.Id);
        
        System.assertEquals(0, insertada.roles_horas_asignadas_proyecto.get('Vacio'));
        
    }
    
    //Test del metodo obtener_Proyecto_Recursos
	@isTest
    static void registrar_recursos(){
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
        
        String strJSON = '[' +
            				 '{' +
                                 '"Resource__c": "' + usuario_prueba[0].Id + '",' +
                                 '"Project__c": "' + pro.Id + '",' +
            					 '"Date_Start__c": "2023-01-02",' +
            					 '"Date_End__c": "2023-01-12",' +
            					 '"Hours_Assigned_Resource__c": "72"' +
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
        ResourceAllocationService.registrar_recursos(strJSON);
        Test.stopTest();
        
        
        //Verificar Resultados
        List<Project_Resource__c> pr_Lista = [SELECT Resource__c, Date_Start__c, Date_End__c, 
                                              		 Hours_Assigned_Resource__c
                                      	      FROM Project_Resource__c
                                      	      WHERE Project__c = :pro.Id];
        
        System.assertEquals(usuario_prueba[0].Id, pr_Lista[0].Resource__c);
        System.assertEquals(Date.valueOf('2023-01-02'), pr_Lista[0].Date_Start__c);
        System.assertEquals(Date.valueOf('2023-01-12'), pr_Lista[0].Date_End__c);
        System.assertEquals(72, pr_Lista[0].Hours_Assigned_Resource__c.intValue());
    }

}