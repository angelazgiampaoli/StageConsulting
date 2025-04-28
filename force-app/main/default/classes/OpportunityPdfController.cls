public class OpportunityPdfController {
    public Opportunity opportunity { get; set; }

    public OpportunityPdfController(ApexPages.StandardController stdController) {
        
        String opportunityId = ApexPages.currentPage().getParameters().get('id');
        this.opportunity = [SELECT Account.Name, DatadeInicio__c, CustoEstimadoProjeto__c, 
                            TempoEstimado__c, ValorProposta__c FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
    }

    public PageReference generatePdf() {
        PageReference pageRef = Page.ContractInfos; 
        pageRef.getParameters().put('id', opportunity.Id); 
        Blob pdfBlob = pageRef.getContentAsPDF();

        
        Attachment attachment = new Attachment();
        attachment.ParentId = opportunity.Id;
        attachment.Name = 'Proposta_' + opportunity.Name + '.pdf';
        attachment.Body = pdfBlob;
        attachment.ContentType = 'application/pdf';
        insert attachment;

        return null;
    }

    public void sendEmail() {
        
        PageReference pageRef = Page.ContractInfos;
        pageRef.getParameters().put('id', opportunity.Id);
        Blob pdfBlob = pageRef.getContentAsPDF();

        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                   
        email.setToAddresses(new String[] { opportunity.Account.Email__c });        
        email.setSubject('Proposta Comercial');
        email.setPlainTextBody('Olá, segue em anexo a proposta comercial.');
        

        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Proposta_' + opportunity.Name + '.pdf');
        attachment.setBody(pdfBlob);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}