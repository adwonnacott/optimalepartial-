/**
 * @description QAdam Reminder Process
 * @date Mar-29-2024
 */
global class QAdamReminderBatch implements Database.Batchable<sObject>, Schedulable {
    public void execute(SchedulableContext sc){
        QAdamReminderBatch batch = new QAdamReminderBatch();
        Database.executeBatch(batch);
    }

    global List<Database.UpsertResult> dmlResults;

    global Database.QueryLocator start(Database.BatchableContext bc) {

        Id patientRtId = SchemaHelper.GetRecordTypeIdByDeveloperName('Account', 'PersonAccount');
        String query = SchemaHelper.getObjectQuery('Account', '');
        String whereStr = ' WHERE RecordTypeId = \''+patientRtId+'\' AND Next_QAdam_Survey__c = TODAY AND Personemail != NULL';
        query += whereStr;
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {

        List<qADAM_Questionnaire__c> qAdamList = new List<qADAM_Questionnaire__c>();
        Set<String> patientEmailSet = new Set<String>();
        Map<Id, Account> patientMap = new Map<Id, Account>(scope);

        for(Account acc : scope) {

            String typeStr = '';

            if(acc.Treatment_Start_Date__c != null) {
                typeStr = 'Post-Treatment';
            }
            else {
                typeStr = 'Pre-Treatment';
            }
            

            qADAM_Questionnaire__c qAdam = new qADAM_Questionnaire__c(
                Patient__c = acc.Id,
                Stage__c = 'New',
                Type__c = typeStr,
                Months_Since_Treatment_Start__c = acc.Treatment_Start_Date__c != null?acc.Treatment_Start_Date__c.monthsBetween(Date.Today()):null,
                //Months_Since_Treatment_Start__c = acc.Treatment_Start_Date__c != null?Date.Today().monthsBetween(acc?.Treatment_Start_Date__c):null,
                Typeform_URL__c = 'https://optimale.typeform.com/to/QxLiSAtw#qadamid='
            );
            qAdamList.add(qAdam);
        }

        dmlResults = new List<Database.UpsertResult>();
        dmlResults = Database.Upsert(qAdamList, false);
        
        Map<Id, qADAM_Questionnaire__c> qAdamMap = adamQuestionnaireMap(dmlResults);
        
        if(qAdamMap.values().size() > 0){
            List<qADAM_Questionnaire__c> qAdamListToReUpdate = new List<qADAM_Questionnaire__c>();
            for(qADAM_Questionnaire__c qa : qAdamMap.values()){
                qADAM_Questionnaire__c q = new qADAM_Questionnaire__c();
                q.Id = qa.Id;
                q.Typeform_URL__c = qa.Typeform_URL__c + qa.Id;
                qAdamListToReUpdate.add(q);
            }
            update qAdamListToReUpdate;
        }
        
        if(!qAdamMap.isEmpty()) {

            String senderEmailId = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'patients@optimale.co.uk' LIMIT 1].Id;
            List<Messaging.SingleEmailMessage> emailMsgList = new List<Messaging.SingleEmailMessage>();

            EmailTemplate reminderEmail = [SELECT Id,
                                                    Subject,
                                                    Body,
                                                    HtmlValue FROM EmailTemplate 
                                                    WHERE DeveloperName = 'QAdam_Reminder_Email_Template_1711719891348' LIMIT 1];
            
            for(qADAM_Questionnaire__c qAdam : qAdamMap.values()) {

                String recipientEmail = String.isNotBlank(qAdam.Patient__r.PersonEmail)?qAdam.Patient__r.PersonEmail:qAdam.Patient__r.X2nd_Email__pc;
                //patientEmailSet.add(emailToAdd);

                qAdamMap.get(qAdam.Id).Stage__c = 'Sent';
                qAdamMap.get(qAdam.Id).Typeform_URL__c += qAdam.Id+'&email='+qAdam.Patient__r.PersonEmail+'&name='+qAdam.Patient_First_Name__c+'&patient_id='+qAdam.Patient__r.Patient_ID__pc;
                patientMap.get(qAdam.Patient__c).Next_QAdam_Survey__c = Date.Today().addMonths(3);

                EmailParams param = new EmailParams();
                //param.accId = qAdam.Patient__c;
                param.accId = qAdam.Id;
                param.emailId = reminderEmail.Id;
                param.orgWideId = senderEmailId;
                param.patientId = qAdam.Patient__r.PersonContactId;
                param.recipientEmail = recipientEmail;

                emailMsgList.add(sendEmail(param));
            }

            Messaging.sendEmail(emailMsgList);
            //sendEmail(patientEmailSet, reminderEmail, senderEmailId);
            

            Database.Upsert(qAdamMap.values(), false);
            Database.Upsert(patientMap.values(), false);
        }
    }    

    global void finish(Database.BatchableContext bc) {

    }    

    public Map<Id, qADAM_Questionnaire__c> adamQuestionnaireMap(List<Database.UpsertResult> dmlResults) {
        
        Set<Id> qAdamIdSet = new Set<Id>();
    
        for(Database.UpsertResult ur : dmlResults) {
            if(ur.isSuccess()) {
                qAdamIdSet.add(ur.getId());
            }
        }

        String query = SchemaHelper.getObjectQuery('qADAM_Questionnaire__c', 'Patient__r.PersonEmail,Patient__r.X2nd_Email__pc,Patient__r.PersonContactId,Patient__r.Patient_ID__pc');
        String whereStr = ' WHERE Id IN : qAdamIdSet';
        query += whereStr;

        List<qADAM_Questionnaire__c> qAdamList = Database.query(query);

        return new Map<Id, qADAM_Questionnaire__c>(qAdamList);
    }

    public Messaging.SingleEmailMessage sendEmail(EmailParams params) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(params.emailId);
        mail.setToAddresses(new List<String> {params.recipientEmail});
        mail.setOrgWideEmailAddressId(params.orgWideId);
        //mail.setWhatId(params.accId);
        //mail.setTargetObjectId(params.patientId);
        mail.setWhatId(params.accId);
        mail.setTargetObjectId(params.patientId);
        return mail;
    }

    public class EmailParams {
        public String accId;
        public String patientId;
        public String emailId;
        public String recipientEmail;
        public String orgWideId;
    }

    /*public void sendEmail(Set<String> emailAddrSet, EmailTemplate emailTemp, String orgWideId) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>(emailAddrSet);
        mail.setToAddresses(toAddresses);
        mail.setSubject(emailTemp.Subject);
        mail.setPlainTextBody(emailTemp.Body);
        mail.setHtmlBody(emailTemp.HtmlValue);
        mail.setOrgWideEmailAddressId(orgWideId);
        //mail.setWhatId(param0);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }*/
}