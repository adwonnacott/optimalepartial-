/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class ASETPathologyReportControllerTest {
    @TestSetup static void setup(){

        Id recordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Original').getRecordTypeId();
        String orgId            = UserInfo.getOrganizationId(); 
        
        Account acc         = new Account(
            RecordTypeId        = recordTypeId,
            Name                = 'Test Account'
        );
        
        insert acc;

        Contact con = new Contact(
            LastName            = 'TestContact',
            Patient_Status__c   = 'Blood Test',
            AccountId           = acc.Id,
            Email               = 'contact@gmail.com'
        );

        insert con;

        Blood_Test__c bt = new Blood_Test__c(
            Order_Date__c           = System.Today(),
            Test_Type__c            = 'Patient Submitted Results',
            Haemoglobin__c          = 2.6,
            Haemoglobin_Max__c      = '4.50',
            Haemoglobin_Min__c      = '2.74',
            Haemoglobin_Units__c    = 'g/L',
            Contact__c              = con.Id,
            Analysis_Lab__c         = 'Randox',
            Status__c               = 'Successful Test'
        );

        insert bt;

    }

    @isTest static void execute(){
        List<Contact> cons = [SELECT Id FROM Contact WHERE LastName = 'TestContact' ];
        System.assertNotEquals(cons.size(), 0);

        List<Blood_Test__c> bts = [SELECT Id FROM Blood_Test__c WHERE Contact__c =: cons[0].Id ];
        System.assertNotEquals(bts.size(), 0);

        List<GeneratePDFInvocable.Requests> requestList = new List<GeneratePDFInvocable.Requests>();
        GeneratePDFInvocable.Requests req               = new GeneratePDFInvocable.Requests();
        req.recId   = bts[0].Id;
        
        requestList.add(req);

        Test.StartTest(); 
            PageReference page = Page.ASETPathologyReport; 
            Test.setCurrentPage(page);
            page.getParameters().put('Id', String.valueOf(bts[0].Id));
            
            ApexPages.StandardController sc     = new  ApexPages.StandardController(bts[0]);     
            ASETPathologyReportController ext   = new ASETPathologyReportController(sc);
            // GeneratePDFInvocable.execute(requestList);

        Test.StopTest();
    }

}