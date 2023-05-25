@isTest
public class TestRegistrarRecursosTrigger {
	//Test if(TN_isIn && (TN_size==1))
	@isTest
    static void Test_una_insercion(){
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
        
        Project_Resource__c p_r2 = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-23'), 
                                                          Date_End__c = Date.valueOf('2023-02-23'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro.Id);
        
        //Ejecutar Prueba
        Test.startTest();
        Database.SaveResult insertada = Database.insert(p_r);
        Database.SaveResult insertada2 = Database.insert(p_r2,false);
        //List<Project_Resource__c> p_r2_Lista = new List<Project_Resource__c>{p_r2};
        //List<Database.SaveResult> insertada3 = Database.insert(p_r2_Lista);
        //Database.SaveResult[] insertada4 = Database.insert(p_r2_Lista);
        Test.stopTest();
        
        //Verificar Resultados
        //insertada
        System.assert(insertada.isSuccess());
        
        List<Project_Resource__c> p_r_select = [SELECT Project__c
                                                FROM Project_Resource__c
                                                WHERE Project__c = :pro.Id];
        
        System.assert(p_r_select.size()==1);
        
        System.assertEquals(insertada.getId(), p_r_select[0].Id);
        
        //insertada2
        System.assert(!insertada2.isSuccess());
        System.assert(insertada2.getErrors().size() == 1);
        System.assertEquals('¡This resource can not be inserted! Your allocation date:\n' +
                      		'2023-01-23 - 2023-02-23' +
                      		'\nIs overlaping with an allocated date assigned to another project:\n' +
                      		'2023-01-01 - 2023-01-30', insertada2.getErrors()[0].getMessage());
        
    }
    
    //Test if(TN_isUp && (TN_size==1))
    @isTest
    static void Test_una_actualizacion(){
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
                                                          Date_End__c = Date.valueOf('2023-01-22'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro.Id);
        insert p_r;
        
        Project_Resource__c p_r2 = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-24'), 
                                                          Date_End__c = Date.valueOf('2023-02-23'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro.Id);
        
        insert p_r2;
        
        
        p_r.Date_End__c = Date.valueOf('2023-01-23');
        p_r2.Date_Start__c = Date.valueOf('2023-01-20');
        
        //Ejecutar Prueba
        Test.startTest();
        Database.SaveResult insertada = Database.update(p_r);
        Database.SaveResult insertada2 = Database.update(p_r2,false);
        //List<Project_Resource__c> p_r2_Lista = new List<Project_Resource__c>{p_r2};
        //List<Database.SaveResult> insertada3 = Database.insert(p_r2_Lista);
        //Database.SaveResult[] insertada4 = Database.insert(p_r2_Lista);
        Test.stopTest();
        
        //Verificar Resultados
        //insertada
        System.assert(insertada.isSuccess());
        
        List<Project_Resource__c> p_r_select = [SELECT Project__c, Date_End__c
                                                FROM Project_Resource__c
                                                WHERE Project__c = :pro.Id];
        
        System.assert(p_r_select.size() == 2);
        
        System.assertEquals(p_r.Date_End__c, p_r_select[0].Date_End__c);
        
        //insertada2
        System.assert(!insertada2.isSuccess());
        System.assert(insertada2.getErrors().size() == 1);
        System.assertEquals('¡This resource can not be update! Your allocation date:\n' +
                      		'2023-01-20 - 2023-02-23' +
                      		'\nIs overlaping with an allocated date assigned to another project:\n' +
                      		'2023-01-01 - 2023-01-23', insertada2.getErrors()[0].getMessage());
        
    }
    
    //Test if(TN_size > 1)
    @isTest 
    static void Test_multiple(){
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
                                                          Date_End__c = Date.valueOf('2023-01-23'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro.Id);
        insert p_r;
        
        Project_Resource__c p_r2 = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-24'), 
                                                           Date_End__c = Date.valueOf('2023-02-19'), 
                                                           Hours_Assigned_Resource__c = 0,
                                                           Resource__c = usuario_prueba[0].Id,
                                                           Project__c = pro.Id);
        
        insert p_r2;
        
        //Lista correcta
        Project_Resource__c  p_r3 = p_r.clone();
        p_r3.Date_Start__c = Date.valueOf('2023-02-20');
        p_r3.Date_End__c = Date.valueOf('2023-02-21');
        
		Project_Resource__c  p_r4 = p_r.clone();
        p_r4.Date_Start__c = Date.valueOf('2023-02-22');
        p_r4.Date_End__c = Date.valueOf('2023-02-23');
        
        Project_Resource__c  p_r5 = p_r.clone();
        p_r5.Date_Start__c = Date.valueOf('2023-02-24');
        p_r5.Date_End__c = Date.valueOf('2023-02-25');

        List<Project_Resource__c> p_r_correcta_Lista = new List<Project_Resource__c>();
        p_r_correcta_Lista.add(p_r3);
        p_r_correcta_Lista.add(p_r4);
        p_r_correcta_Lista.add(p_r5);
        
        //Lista incorrecta
        Project_Resource__c  p_r6 = p_r.clone();
        p_r6.Date_Start__c = Date.valueOf('2023-02-23');
        p_r6.Date_End__c = Date.valueOf('2023-02-27');
        
		Project_Resource__c  p_r7 = p_r.clone();
        p_r7.Date_Start__c = Date.valueOf('2023-02-23');
        p_r7.Date_End__c = Date.valueOf('2023-02-27');
        
        Project_Resource__c  p_r9 = p_r.clone();
        p_r9.Date_Start__c = Date.valueOf('2023-02-23');
        p_r9.Date_End__c = Date.valueOf('2023-02-27');

        List<Project_Resource__c> p_r_incorrecta_Lista = new List<Project_Resource__c>();
        p_r_incorrecta_Lista.add(p_r6);
        p_r_incorrecta_Lista.add(p_r7);
        p_r_incorrecta_Lista.add(p_r9);
        
        //Ejecutar Prueba
        Test.startTest();
        List<Database.SaveResult> insertada = Database.insert(p_r_correcta_Lista);
        Database.SaveResult[] insertada2 = Database.insert(p_r_incorrecta_Lista, false);
        //List<Project_Resource__c> p_r2_Lista = new List<Project_Resource__c>{p_r2};
        //List<Database.SaveResult> insertada3 = Database.insert(p_r2_Lista);
        //Database.SaveResult[] insertada4 = Database.insert(p_r2_Lista);
        Test.stopTest();
        
        //Verificar Resultados
        //insertada
        System.assertEquals(3, insertada.size());
        
        Integer i=0;
        for(Database.SaveResult dr: insertada){
            System.assert(dr.isSuccess());
            System.assertEquals(p_r_correcta_Lista[i].id, dr.getId());
            i++;
        }
        
        System.assert(insertada2.size() == 3);
    
        for(Database.SaveResult dr: insertada2){
            System.assert(!dr.isSuccess());
        }
        
        System.assertEquals('You can not allocate the resource '
                             + usuario_prueba[0].Name
                             + ' on the indicated date: '
                             + p_r6.Date_Start__c + ' - '
                             + p_r6.Date_End__c + ' - ' + 
                             ', '
                             +
                             'You can not allocate the resource '
                             + usuario_prueba[0].Name
                             + ' on the indicated date: '
                             + p_r7.Date_Start__c + ' - '
                             + p_r7.Date_End__c + ' - ' + 
                             ', '
                             +
                             'You can not allocate the resource '
                             + usuario_prueba[0].Name
                             + ' on the indicated date: '
                             + p_r9.Date_Start__c + ' - '
                             + p_r9.Date_End__c + ' - ', insertada2[0].getErrors()[0].getMessage());
    }
    
    //Test de la funcion filtrar 
    @isTest
    static void Test_filtrar(){
        //Inicializar Data
        Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                        Date_End__c = Date.valueOf('2023-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        
        Project__c pro2 = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                         Date_End__c = Date.valueOf('2023-03-01'),
                                         Status__c = 'Pre-Kickoff',
                                         Name = 'Project of: Prueba2');
        
        List<Project__c> pro_Lista = new List<Project__c>();
        pro_Lista.add(pro);
        pro_Lista.add(pro2);
        
        insert pro_Lista;

        Project_Role__c pro_rol = new Project_Role__c(Role__c = 'Developer',
                                        			  Quantity_Of_Hours__c = 40,
                                        			  Project__c = pro_Lista[0].Id);
        
        Project_Role__c pro_rol2 = new Project_Role__c(Role__c = 'Consultant',
                                        			  Quantity_Of_Hours__c = 40,
                                        			  Project__c = pro_Lista[0].Id);
        
        
        Project_Role__c pro_rol3 = new Project_Role__c(Role__c = 'Architect',
                                        			   Quantity_Of_Hours__c = 40,
                                        			   Project__c = pro_Lista[0].Id);
   
        
		Project_Role__c pro_rol4 = new Project_Role__c(Role__c = 'Developer',
                                        			   Quantity_Of_Hours__c = 40,
                                        			   Project__c = pro_Lista[1].Id);
        
        Project_Role__c pro_rol5 = new Project_Role__c(Role__c = 'Consultant',
                                        			   Quantity_Of_Hours__c = 40,
                                        			   Project__c = pro_Lista[1].Id);
        
        
        Project_Role__c pro_rol6 = new Project_Role__c(Role__c = 'Architect',
                                        			   Quantity_Of_Hours__c = 40,
                                        			   Project__c = pro_Lista[1].Id);
        
        List<Project_Role__c> pro_rol_Lista = new List<Project_Role__c>();
        pro_rol_Lista.add(pro_rol);
        pro_rol_Lista.add(pro_rol2);
        pro_rol_Lista.add(pro_rol3);
        pro_rol_Lista.add(pro_rol4);
        pro_rol_Lista.add(pro_rol5);
        pro_rol_Lista.add(pro_rol6);
        
        insert pro_rol_Lista;        
        
        
        
        List<User> usuario_prueba = [SELECT Name
                                     FROM User
                                     WHERE UserRole.Name = 'Developer'];
        
        List<User> usuario_prueba2 = [SELECT Name
                                      FROM User
                                      WHERE UserRole.Name = 'Consultant'];
        
        List<User> usuario_prueba3 = [SELECT Name
                                      FROM User
                                      WHERE UserRole.Name = 'Architect'];
        
        
        Project_Resource__c p_r = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                           Date_End__c = Date.valueOf('2023-01-23'), 
                                                           Hours_Assigned_Resource__c = 20,
                                                           Resource__c = usuario_prueba2[0].Id,
                                                           Project__c = pro_Lista[0].Id);
        
        Project_Resource__c p_r2 = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                           Date_End__c = Date.valueOf('2023-01-23'), 
                                                           Hours_Assigned_Resource__c = 20,
                                                           Resource__c = usuario_prueba3[0].Id,
                                                           Project__c = pro_Lista[0].Id);
        
        List<Project_Resource__c> pr_Lista = new List<Project_Resource__c>();
        pr_Lista.add(p_r);
        pr_Lista.add(p_r2);
        
        insert pr_Lista;
        
        //Lista incorrectas
        Project_Resource__c  p_r4 = pr_Lista[0].clone();
        p_r4.Resource__c = usuario_prueba[0].Id;
        p_r4.Date_Start__c = Date.valueOf('2023-01-24');
        p_r4.Date_End__c = Date.valueOf('2023-02-23');
        p_r4.Hours_Assigned_Resource__c = 50;
        
        Project_Resource__c  p_r5 = pr_Lista[0].clone();
        p_r5.Date_Start__c = Date.valueOf('2023-01-24');
        p_r5.Date_End__c = Date.valueOf('2023-02-23');
        p_r5.Hours_Assigned_Resource__c = 30;
        
        Project_Resource__c  p_r6 = pr_Lista[1].clone();
        p_r6.Date_Start__c = Date.valueOf('2023-01-24');
        p_r6.Date_End__c = Date.valueOf('2023-02-23');
        p_r6.Hours_Assigned_Resource__c = 30;
        
        Project_Resource__c  p_r7 = pr_Lista[0].clone();
        p_r7.Resource__c = usuario_prueba[1].Id;
		p_r7.Project__c = pro_Lista[1].Id;
        p_r7.Hours_Assigned_Resource__c = 50;
        
		Project_Resource__c  p_r8 = pr_Lista[0].clone();
        p_r8.Resource__c = usuario_prueba2[1].Id;
		p_r8.Project__c = pro_Lista[1].Id;
        p_r8.Hours_Assigned_Resource__c = 50;
        
        Project_Resource__c  p_r9 = pr_Lista[1].clone();
        p_r9.Resource__c = usuario_prueba3[1].Id;
		p_r9.Project__c = pro_Lista[1].Id;
        p_r9.Hours_Assigned_Resource__c = 50;

        List<Project_Resource__c> p_r_incorrecta1_Lista = new List<Project_Resource__c>();
        p_r_incorrecta1_Lista.add(p_r4);
        p_r_incorrecta1_Lista.add(p_r5);
        p_r_incorrecta1_Lista.add(p_r6);
        
        List<Project_Resource__c> p_r_incorrecta2_Lista = new List<Project_Resource__c>();
        p_r_incorrecta2_Lista.add(p_r7);
        p_r_incorrecta2_Lista.add(p_r8);
        p_r_incorrecta2_Lista.add(p_r9);
        
        //Ejecutar Prueba
        Test.startTest();
        List<Database.SaveResult> insertada = Database.insert(p_r_incorrecta1_Lista, false);
        Database.SaveResult[] insertada2 = Database.insert(p_r_incorrecta2_Lista, false);
        //List<Project_Resource__c> p_r2_Lista = new List<Project_Resource__c>{p_r2};
        //List<Database.SaveResult> insertada3 = Database.insert(p_r2_Lista);
        //Database.SaveResult[] insertada4 = Database.insert(p_r2_Lista);
        Test.stopTest();
        
        //Verificar Resultados
        //insertada
        System.assertEquals(3, insertada.size());
        
        Integer i=0;
        for(Database.SaveResult dr: insertada){
            System.assert(!dr.isSuccess());
        }
        
        System.assertEquals('Assigned hours have been exceeded', insertada[0].getErrors()[0].getMessage());
        
        
        
        System.assert(insertada2.size() == 3);
    
        for(Database.SaveResult dr: insertada2){
            System.assert(!dr.isSuccess());
        }
        
        System.assertEquals('Assigned hours have been exceeded', insertada2[0].getErrors()[0].getMessage());
        
    }
}