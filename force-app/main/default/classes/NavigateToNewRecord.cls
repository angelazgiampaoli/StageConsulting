public with sharing class NavigateToNewRecord {
    @InvocableMethod(label='Navegar para Novo Registro' description='Redireciona o usuário para um registro recém-criado.')
    public static List<NavigateOutput> navigate(List<NavigateInput> inputs) {
        List<NavigateOutput> outputs = new List<NavigateOutput>();
        NavigateOutput output = new NavigateOutput();

        
        String recordId = inputs[0].recordId;
        System.debug('ID: ' + recordId );

        if (String.isNotBlank(recordId)) {
            output.recordId = recordId;
            outputs.add(output);
        }
		System.debug ('Output ' + outputs );
        return outputs;
    }

    public class NavigateInput {
        @InvocableVariable(label='ID do Registro' required=true)
        public String recordId;
    }

    public class NavigateOutput {
        @InvocableVariable
        public String recordId;
    }
}