public without sharing class GeneratePDFInvocable {
    @InvocableMethod(label='Generate PDF Using VFPage' description='Returns the list of account names corresponding to the specified account IDs.')
    public static void execute(List<Requests> requestList) {
        
        if( requestList.size() > 0 ){ 
            System.debug('@@@@ ');
            String recordId = requestList[0].recId;
            insertContentVersion(recordId);
            
            /*Blood_Test__c bTestRec = [Select Id,Name,Results_Status__c  ,Contact__c,Testosterone__c ,Free_Testosterone__c , Sample_Date__c   from Blood_Test__c Where Id =: recordId LIMIT 1];
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
            emailMessages.add(mail);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMessages, false);
			*/
        }
        
    }
    
    @AuraEnabled
    public static void generatePDF(String recordId){
        insertBloodTestPDFNonFuture(recordId);
    }
    
    @future(callout = true)
    public static void insertBloodTestPDF( String recordId ) {
        try {
            
            if( !String.isBlank(recordId) ){
                
                Blood_Test__c bTestRec = [Select Id,Name,Results_Status__c  ,Contact__c,Testosterone__c ,Free_Testosterone__c , Sample_Date__c   from Blood_Test__c Where Id =: recordId LIMIT 1];
                Contact patientRec = [SELECT Date_of_Birth__c,LastName,email,FirstName,Name,Patient_ID__c, Gender__c FROM Contact WHERE Id = :bTestRec.Contact__c LIMIT 1 ];
                
                List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink where 
                                                     LinkedEntityId =: bTestRec.Id AND ContentDocument.title LIKE '%OM Blood Test Report%'];
                
                String sampleDate = '' ;
                if(bTestRec.Sample_Date__c != NULL){
                    sampleDate = bTestRec.Sample_Date__c.day() + '/' + bTestRec.Sample_Date__c.month() + '/' +  bTestRec.Sample_Date__c.year();
                }
				
                String fileName = patientRec.Patient_ID__c+' - '+patientRec.Name+' - OM Blood Test Report - '+ sampleDate +' - '+bTestRec.Name+' v'+ (cdlList.size() > 0 ? String.valueOf(cdlList.size()+1) : '1')+'.pdf';
                
                PageReference PDf =  Page.ASETPathologyReport;
                PDf.getParameters().put('id', recordId);
                PDf.setRedirect(true);
                
                Blob pdfPageBlob    = (Test.isRunningTest()) ? Blob.valueOf(String.valueOf('Blood')) : PDf.getContentAsPDF();
                //Blob pdfPageBlob    = PDf.getContentAsPDF();  
                
                ContentVersion file         = new ContentVersion();
                //file.Title                  = 'Blood_Test_Result.pdf';
                //file.PathOnClient           = 'Blood_Test_Result.pdf';
                file.Title                  = fileName;
                file.PathOnClient           = fileName;
                file.VersionData            = pdfPageBlob;
                file.FirstPublishLocationId = recordId;
                
                insert file;
                
                System.debug( 'ContentVersion ' + file.Id );
                
                ContentDistribution cd = new ContentDistribution();
                //cd.name                             = 'Blood_Test_Result.pdf';
                cd.name                             = fileName;
                cd.ContentVersionId                 = file.Id;
                cd.PreferencesAllowOriginalDownload = true;
                cd.PreferencesAllowPDFDownload      = true;
                cd.PreferencesAllowViewInBrowser    = true;
                cd.PreferencesNotifyOnVisit         = false;
                cd.PreferencesPasswordRequired      = true;
                insert cd;
                
                System.debug( 'ContentDistribution ' + cd.Id );
                
                List<ContentDistribution> cdRecords = [ SELECT Id, Name, ContentVersionId, DistributionPublicUrl, ContentDocumentId, ContentDownloadUrl, Password FROM ContentDistribution WHERE Id = :cd.Id ];
                
                System.debug( 'ContentDistribution ' + cdRecords);
                
                if(cdRecords.size() > 0){
                    Blood_Test__c toUpdate = new Blood_Test__c(
                        Id                  = recordId,
                        PDF_Password__c     = cdRecords[0].Password,
                        PDF_URL__c          = cdRecords[0].DistributionPublicUrl,
                        Is_Trigger_PDF__c   = true,
                        PDF_Results_Upload_Date_Time__c = System.Now()
                    );
                    
                    update toUpdate;
                }
                
                
            }
            
        } catch (Exception e) {
            System.debug('The following exception has occurred:'  + e.getMessage());
        } 
        
    }  

    public static void insertBloodTestPDFNonFuture( String recordId ) {
        try {
            
            if( !String.isBlank(recordId) ){
                
                Blood_Test__c bTestRec = [Select Id,Name,Results_Status__c  ,Contact__c,Testosterone__c ,Free_Testosterone__c , Sample_Date__c   from Blood_Test__c Where Id =: recordId LIMIT 1];
                Contact patientRec = [SELECT Date_of_Birth__c,LastName,email,FirstName,Name,Patient_ID__c, Gender__c FROM Contact WHERE Id = :bTestRec.Contact__c LIMIT 1 ];
                
                List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink where 
                                                     LinkedEntityId =: bTestRec.Id AND ContentDocument.title LIKE '%OM Blood Test Report%'];
                
                String sampleDate = '' ;
                if(bTestRec.Sample_Date__c != NULL){
                    sampleDate = bTestRec.Sample_Date__c.day() + '/' + bTestRec.Sample_Date__c.month() + '/' +  bTestRec.Sample_Date__c.year();
                }
				
                String fileName = patientRec.Patient_ID__c+' - '+patientRec.Name+' - OM Blood Test Report - '+ sampleDate +' - '+bTestRec.Name+' v'+ (cdlList.size() > 0 ? String.valueOf(cdlList.size()+1) : '1')+'.pdf';
                
                PageReference PDf =  Page.ASETPathologyReport;
                PDf.getParameters().put('id', recordId);
                PDf.setRedirect(true);
                
                Blob pdfPageBlob    = (Test.isRunningTest()) ? Blob.valueOf(String.valueOf('Blood')) : PDf.getContentAsPDF();
                //Blob pdfPageBlob    = PDf.getContentAsPDF();  
                
                ContentVersion file         = new ContentVersion();
                //file.Title                  = 'Blood_Test_Result.pdf';
                //file.PathOnClient           = 'Blood_Test_Result.pdf';
                file.Title                  = fileName;
                file.PathOnClient           = fileName;
                file.VersionData            = pdfPageBlob;
                file.FirstPublishLocationId = recordId;
                
                insert file;
                
                System.debug( 'ContentVersion ' + file.Id );
                
                ContentDistribution cd = new ContentDistribution();
                //cd.name                             = 'Blood_Test_Result.pdf';
                cd.name                             = fileName;
                cd.ContentVersionId                 = file.Id;
                cd.PreferencesAllowOriginalDownload = true;
                cd.PreferencesAllowPDFDownload      = true;
                cd.PreferencesAllowViewInBrowser    = true;
                cd.PreferencesNotifyOnVisit         = false;
                cd.PreferencesPasswordRequired      = true;
                insert cd;
                
                System.debug( 'ContentDistribution ' + cd.Id );
                
                List<ContentDistribution> cdRecords = [ SELECT Id, Name, ContentVersionId, DistributionPublicUrl, ContentDocumentId, ContentDownloadUrl, Password FROM ContentDistribution WHERE Id = :cd.Id ];
                
                System.debug( 'ContentDistribution ' + cdRecords);
                
                if(cdRecords.size() > 0){
                    Blood_Test__c toUpdate = new Blood_Test__c(
                        Id                  = recordId,
                        PDF_Password__c     = cdRecords[0].Password,
                        PDF_URL__c          = cdRecords[0].DistributionPublicUrl,
                        Is_Trigger_PDF__c   = true,
                        PDF_Results_Upload_Date_Time__c = System.Now()
                    );
                    
                    update toUpdate;
                }
                
                
            }
            
        } catch (Exception e) {
            System.debug('The following exception has occurred:'  + e.getMessage());
        } 
        
    }
    
    //With Send email
    @future(callout=true)
    public static void insertContentVersion( String recordId ) {
        try {
            
            if( !String.isBlank(recordId) ){
                
                Blood_Test__c bTestRec = [Select Id,Name,Results_Status__c  ,Contact__c,Testosterone__c ,Free_Testosterone__c , Sample_Date__c   from Blood_Test__c Where Id =: recordId LIMIT 1];
                Contact patientRec = [SELECT Date_of_Birth__c,LastName,Email,FirstName,Name,Patient_ID__c, Gender__c FROM Contact WHERE Id = :bTestRec.Contact__c LIMIT 1 ];
                
                List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink where 
                                                     LinkedEntityId =: bTestRec.Id AND ContentDocument.title LIKE '%OM Blood Test Report%'];
                
                String sampleDate = bTestRec.Sample_Date__c.day() + '/' + bTestRec.Sample_Date__c.month() + '/' +  bTestRec.Sample_Date__c.year() ;
                String fileName = patientRec.Patient_ID__c+' - '+patientRec.Name+' - OM Blood Test Report - '+ sampleDate +' - '+bTestRec.Name+' v'+ (cdlList.size() > 0 ? String.valueOf(cdlList.size()+1) : '1')+'.pdf';
                
                PageReference PDf =  Page.ASETPathologyReport;
                PDf.getParameters().put('id', recordId);
                PDf.setRedirect(true);
                
                Blob pdfPageBlob    = (Test.isRunningTest()) ? Blob.valueOf(String.valueOf('Blood')) : PDf.getContentAsPDF(); 
                
                ContentVersion file         = new ContentVersion();
                //file.Title                  = 'Blood_Test_Result.pdf';
                //file.PathOnClient           = 'Blood_Test_Result.pdf';
                file.Title                  = fileName;
                file.PathOnClient           = fileName;
                file.VersionData            = pdfPageBlob;
                file.FirstPublishLocationId = recordId;
                
                insert file;
                
                System.debug( 'ContentVersion ' + file.Id );
                
                ContentDistribution cd = new ContentDistribution();
                //cd.name                             = 'Blood_Test_Result.pdf';
                cd.name                             = fileName;
                cd.ContentVersionId                 = file.Id;
                cd.PreferencesAllowOriginalDownload = true;
                cd.PreferencesAllowPDFDownload      = true;
                cd.PreferencesAllowViewInBrowser    = true;
                cd.PreferencesNotifyOnVisit         = false;
                cd.PreferencesPasswordRequired      = true;
                insert cd;
                
                System.debug( 'ContentDistribution ' + cd.Id );
                
                List<ContentDistribution> cdRecords = [ SELECT Id, Name, ContentVersionId, DistributionPublicUrl, ContentDocumentId, ContentDownloadUrl, Password FROM ContentDistribution WHERE Id = :cd.Id ];
                
                System.debug( 'ContentDistribution ' + cdRecords);
                
                if(cdRecords.size() > 0){
                    Blood_Test__c toUpdate = new Blood_Test__c(
                        Id                  = recordId,
                        PDF_Password__c     = cdRecords[0].Password,
                        PDF_URL__c          = cdRecords[0].DistributionPublicUrl,
                        Is_Trigger_PDF__c   = true
                    );
                    
                    update toUpdate;
                    System.debug('BT Update @@@@ '+ toUpdate);
                }
                
                //Send Email
                System.debug('About to send email @@@@ ');
                //if(bTestRec.Testosterone__c > 15 && bTestRec.Free_Testosterone__c >0.225){
                    Id emailtemp = [SELECT Id FROM EmailTemplate WHERE Name = 'Your Optimale Blood Test Result' LIMIT 1].Id;
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
                    //Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMessages, false);
                                    
                    bTestRec.Results_Status__c = 'Sent to Patient (Automated)';
                    update bTestRec;
                //}
                
            }
            
        } catch (Exception e) {
            System.debug('The following exception has occurred:'  + e.getMessage());
        } 
        
    }   
    
    public class Requests {
        @InvocableVariable(label='Record Id' description='Record Id' required=true)
        public String recId;
        
        
    }
    
    public class Response {
        @InvocableVariable
        public ContentVersion ContentVersion;
    }
}