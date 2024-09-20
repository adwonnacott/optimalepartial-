@isTest
public class QAdamReminderBatchTest {
   
    
    @isTest static void execute(){
        
        Id patientRtId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
   
        Account acc         = new Account(
            RecordTypeId        = patientRtId,
            FirstName                = 'Test',
            LastName                = 'Test',
            Next_QAdam_Survey__c = Date.Today(),
            Personemail = 'test@gmail.com'
        );
        
        insert acc;

        Test.StartTest(); 
        	SchemaHelper.getPicklistValues('Account', 'Type');
        	Database.executeBatch(new QAdamReminderBatch());
            

        Test.StopTest();
    }

}