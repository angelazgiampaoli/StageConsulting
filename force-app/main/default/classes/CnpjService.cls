public class CnpjService {

    public class CnpjRequest {
        @InvocableVariable(required=true)
        public String cnpj;
    }

    public class CnpjResponse {
        @InvocableVariable
        public Boolean sucesso;
        @InvocableVariable
        public String razaoSocial;
        @InvocableVariable
        public String nomeFantasia;
        @InvocableVariable
        public String situacaoCadastral;
        @InvocableVariable
        public String cnaePrincipalDescricao;
        @InvocableVariable
        public String logradouro;
        @InvocableVariable
        public String numero;
        @InvocableVariable
        public String complemento;
        @InvocableVariable
        public String bairro;
        @InvocableVariable
        public String cep;
        @InvocableVariable
        public String municipio;
        @InvocableVariable
        public String uf;
        @InvocableVariable
        public String telefone;
        @InvocableVariable
        public String erro;
    }

    @InvocableMethod(label='Consultar CNPJ')
    public static List<CnpjResponse> consultarCNPJ(List<CnpjRequest> requests) {
        List<CnpjResponse> responses = new List<CnpjResponse>();

        for (CnpjRequest req : requests) {
            CnpjResponse resp = new CnpjResponse();

            try {
                Http http = new Http();
                HttpRequest httpReq = new HttpRequest();
                httpReq.setEndpoint('https://brasilapi.com.br/api/cnpj/v1/' + req.cnpj);
                httpReq.setMethod('GET');
                httpReq.setTimeout(10000);
                httpReq.setHeader('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36');


                HttpResponse httpResp = http.send(httpReq);

                if (httpResp.getStatusCode() == 200) {
                    Map<String, Object> resultado = (Map<String, Object>) JSON.deserializeUntyped(httpResp.getBody());
                    resp.sucesso = true;
                    resp.razaoSocial = (String) resultado.get('razao_social');
                    
					String nomeFantasia = (String) resultado.get('nome_fantasia');
					resp.nomeFantasia = String.isBlank(nomeFantasia) ? (String) resultado.get('razao_social') : nomeFantasia;
                    
                    resp.situacaoCadastral = (String) resultado.get('descricao_situacao_cadastral');
                    resp.cnaePrincipalDescricao = (String) resultado.get('cnae_fiscal_descricao');
                    resp.logradouro = (String) resultado.get('logradouro');
                    resp.numero = String.valueOf(resultado.get('numero'));
                    resp.complemento = (String) resultado.get('complemento');
                    resp.bairro = (String) resultado.get('bairro');
                    resp.cep = String.valueOf(resultado.get('cep'));
                    resp.municipio = (String) resultado.get('municipio');
                    resp.uf = (String) resultado.get('uf');
                    resp.telefone = (String) resultado.get('ddd_telefone_1');                    
                    System.debug(resp);
                    
                } else {
                    resp.sucesso = false;
                    resp.erro = 'CNPJ não encontrado ou inválido.';
                }

            } catch (Exception e) {
                resp.sucesso = false;
                resp.erro = 'Erro ao consultar o CNPJ: ' + e.getMessage();
            }

            responses.add(resp);
        }

        return responses;
    }
}