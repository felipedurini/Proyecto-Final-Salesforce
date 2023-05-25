@isTest
public class TestAsignarSquadLeadTrigger {
	
    //Test_filtrar
    @isTest
    static void Test_Filtrar(){
        
        List<User> usuario_prueba = [SELECT Name
                                     FROM User
                                     WHERE UserRole.Name = 'Developer'];
        
    	Project__c pro = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                        Date_End__c = Date.valueOf('2023-03-01'),
                                        Status__c = 'Pre-Kickoff',
                                        Name = 'Project of: Prueba');
        
        Project__c pro2 = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                         Date_End__c = Date.valueOf('2023-03-01'),
                                         Status__c = 'Pre-Kickoff',
                                         Name = 'Project of: Prueba2');
        
        Project__c pro3 = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                         Date_End__c = Date.valueOf('2023-03-01'),
                                         Status__c = 'Pre-Kickoff',
                                         Name = 'Project of: Prueba3');
        
        Project__c pro4 = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                         Date_End__c = Date.valueOf('2023-03-01'),
                                         Status__c = 'Pre-Kickoff',
                                         Name = 'Project of: Prueba4',
                                         Squad_Lead__c = usuario_prueba[0].Id);
        
        Project__c pro5 = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                         Date_End__c = Date.valueOf('2023-03-01'),
                                         Status__c = 'Pre-Kickoff',
                                         Name = 'Project of: Prueba5',
                                         Squad_Lead__c = usuario_prueba[0].Id);
        
        Project__c pro6 = new Project__c(Date_Start__c = Date.valueOf('2023-01-01'),
                                         Date_End__c = Date.valueOf('2023-03-01'),
                                         Status__c = 'Pre-Kickoff',
                                         Name = 'Project of: Prueba6',
                                         Squad_Lead__c = usuario_prueba[0].Id);
        
        List<Project__c> pro_Lista = new List<Project__c>{pro, pro2, pro3, pro4, pro5, pro6}; 
        
        insert pro_Lista;
        
        
        Project_Resource__c p_r = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                          Date_End__c = Date.valueOf('2023-01-30'), 
                                                          Hours_Assigned_Resource__c = 0,
                                                          Resource__c = usuario_prueba[0].Id,
                                                          Project__c = pro_Lista[0].Id);
        
        Project_Resource__c p_r2 = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                           Date_End__c = Date.valueOf('2023-01-30'), 
                                                           Hours_Assigned_Resource__c = 0,
                                                           Resource__c = usuario_prueba[0].Id,
                                                           Project__c = pro_Lista[1].Id);
        
        Project_Resource__c p_r3 = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                           Date_End__c = Date.valueOf('2023-01-30'), 
                                                           Hours_Assigned_Resource__c = 0,
                                                           Resource__c = usuario_prueba[1].Id,
                                                           Project__c = pro_Lista[3].Id);
        
        Project_Resource__c p_r4 = new Project_Resource__c(Date_Start__c = Date.valueOf('2023-01-01'), 
                                                           Date_End__c = Date.valueOf('2023-01-30'), 
                                                           Hours_Assigned_Resource__c = 0,
                                                           Resource__c = usuario_prueba[0].Id,
                                                           Project__c = pro_Lista[4].Id);
        
        
        
        List<Project_Resource__c> p_r_Lista = new List<Project_Resource__c>{p_r, p_r2, p_r3, p_r4};
        
        insert p_r_Lista;
        
        pro_Lista[0].Squad_Lead__c = usuario_prueba[0].Id;
        pro_Lista[1].Squad_Lead__c = usuario_prueba[1].Id;
        pro_Lista[2].Squad_Lead__c = usuario_prueba[0].Id;
        pro_Lista[3].Squad_Lead__c = usuario_prueba[1].Id;
        pro_Lista[4].Squad_Lead__c = usuario_prueba[1].Id;
        pro_Lista[5].Squad_Lead__c = usuario_prueba[1].Id;
        
        //Ejecutar Prueba
        Test.startTest();
        List<Database.SaveResult> insertada = Database.update(pro_Lista, False);
        Test.stopTest();
        
        //Verificar Resultados
        
        Integer i=0;
        for(Database.SaveResult dr: insertada){
            
            if(i == 0){
            	System.assert(dr.isSuccess());
                
        	}else if(i == 1){
                System.assert(!dr.isSuccess());
                System.assertEquals('This resource can not be assigned because it is not allocated to the project',
                                   dr.getErrors()[0].getMessage());
            }else if(i == 2){
                System.assert(!dr.isSuccess());
				System.assertEquals('To select a Squad Lead, first allocated resources to the project',
                                   dr.getErrors()[0].getMessage());
            }else if(i == 3){
            	System.assert(dr.isSuccess());
                
        	}else if(i == 4){
                System.assert(!dr.isSuccess());
                System.assertEquals('This resource can not be assigned because it is not allocated to the project',
                                   dr.getErrors()[0].getMessage());
            }else if(i == 5){
                System.assert(!dr.isSuccess());
				System.assertEquals('To select a Squad Lead, first allocated resources to the project',
                                   dr.getErrors()[0].getMessage());
            }
            
            i++;
        }
        
    }
    
}