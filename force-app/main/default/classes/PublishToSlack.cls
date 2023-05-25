public class PublishToSlack {
	
    public static void publish_To_Slack(String msg){	//Metodo que envie el mensaje a slack
        //Definiendo e inicializando url y canal
        String url = 'https://hooks.slack.com/services/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'; 
        String channel = '#tareacompletadas';
		
        //Creando el JSON
        String json_string = create_JSON(msg, channel).getAsString();
        
        List<String> params = new List<String>{url, 'POST', json_string};
            
        //Encolando las solicitudes
        System.enqueueJob(new encolada(params));
    }
    
    public class encolada implements System.Queueable, Database.AllowsCallouts {
        //Creamos la lista de parametros
        private final List<String> params;
        
        //Definimos el Constructor
        public encolada(List<String> params) {
            this.params = params;
        }
         
        //Llamamos al metodo execute
        public void execute(System.QueueableContext context) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(params[0]);
            request.setMethod(params[1]);
            request.setBody(params[2]);
            Http http = new Http();
            HttpResponse response = http.send(request);
        }
    }
    
    public static JSONGenerator create_JSON(String msg, String channel){	//Metodo que crea el JSON a enviar
        JSONGenerator json = JSON.createGenerator(True);
        json.writeStartObject();
        json.writeStringField('text', msg);
        json.writeStringField('channel', channel);
        json.writeEndObject();
        
        return json;
    }
}