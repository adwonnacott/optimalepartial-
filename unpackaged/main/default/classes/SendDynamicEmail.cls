public class SendDynamicEmail {
    
    @InvocableMethod(label='Send Dynamic Email' description='Send Email with input paramters')
    public static void execute(List<Requests> requestList) {
        if( requestList.size() > 0 ){ 
            String recordId = requestList[0].recId;
            
            Blood_Test__c bTestRec = [Select Id,Name,Results_Status__c  ,Contact__c,Testosterone__c ,Free_Testosterone__c , Sample_Date__c   from Blood_Test__c Where Id =: recordId LIMIT 1];
            Contact patientRec = [SELECT Date_of_Birth__c,LastName,Email,FirstName,Name,Patient_ID__c, Gender__c FROM Contact WHERE Id = :bTestRec.Contact__c LIMIT 1 ];
            
            Id emailtemp = requestList[0].templateId;
            OrgWideEmailAddress orgEmail = [SELECT Id, Address,DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'bloods@optimale.co.uk'];
            List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
            String[] toAddresses = new String[] {patientRec.Email};
                
                System.debug('@@@@ '+ patientRec.Email);
            System.debug('@@@@ '+ emailtemp);
            System.debug('@@@@ '+ orgEmail.Address);
            System.debug('@@@@ '+ orgEmail.DisplayName);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(emailtemp);
            mail.setCcAddresses(toAddresses);
            mail.setSaveAsActivity(true);
            mail.setWhatId( bTestRec.Id);
            mail.setTargetObjectId(patientRec.Id);
            mail.setOrgWideEmailAddressId(orgEmail.Id);
            //mail.setReplyTo(orgEmail.Address); 
            //mail.setSenderDisplayName(orgEmail.DisplayName); 
            emailMessages.add(mail);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMessages, false);
        }
    }
    
    public class Requests {
        @InvocableVariable(label='Record Id' description='Record Id' required=true)
        public String recId;
        
        @InvocableVariable(label='Email Temaplate Id' description='Record Id of the Email Temaplate' required=true)
        public String templateId;
    }

}