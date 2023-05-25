public class VariablesEstructuras {
	/*
    public static boolean trigger_Finalizo = False;
  	public static List<Project_Resource__c> recursos_No_Insertados = new List<Project_Resource__c>();

  	public static void set_trigger_Finalizo(Boolean buleano) {
    	trigger_Finalizo = buleano;
  	}
	
    public static boolean get_trigger_Finalizo(){
        return trigger_Finalizo;
    }
    
  	public static void set_recursos_No_Insertados(Project_Resource__c pr) {
    	recursos_No_Insertados.add(pr);
  	}

    public static void clear_recursos_No_Insertados(){
        recursos_No_Insertados.clear();
    }    
    
  	public static List<Project_Resource__c> get_recursos_No_Insertados() {
    	return recursos_No_Insertados;
  	}
    */
	
    /*
    Map<String, List<Project_Roles__r>> roles_pr_map = new Map<String, List<Project_Roles__r>>();
    Set<String> user_roles_set = new Set<String>();
            //almaceno todos los usuarios que no pueden trabajar en el proyecto
             for(Project_Resource__c p_r: p_recursos1_lista){
                    user_Id_set.add(p_r.Resource__c);   
             }
             //mapa de roles por usuario
             Map<String, List<User>> roles_usuarios_map = new Map<String, List<User>>();
        	 List<User> usuarios_lista_totales = new List<User>();
             for(Project_Role__c p_role: pro.Project_Roles__r){
                 //List<User> usuarios_rol_lista = [SELECT Id, Name, Rate_Hourly__c, UserRole.Name
                                                  //FROM User
                                                  //WHERE UserRole.Name = :p_role.Role__c AND Id NOT IN: user_Id_set];
                                                  //
                 
                 if(!roles_pr_map.get(p_role.Role__c)){
                     roles_pr_map.put(p_role.Role__c, new List<Project_Roles__r>())
                 }
                 //roles_usuarios_map.put(p_role.Role__c, usuarios_rol_lista);
                 //usuarios_lista_totales.addAll(usuarios_rol_lista);
             }
    		List<User> usuarios_rol_lista = [SELECT Id, Name, Rate_Hourly__c, UserRole.Name
                                                  FROM User
                                                  WHERE UserRole.Name IN: p_role.Role__c AND Id NOT IN: user_Id_set];
    
    		for(User lil_user: usuarios_rol_lista){
        	roles_pr_map.get(lil_user.UserRole.Name).add(lil_user)
    		}

		*/
}