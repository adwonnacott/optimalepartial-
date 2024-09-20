@isTest
public class GeneratePDFInvocableTest {
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
            Testosterone__c = 20,
            Free_Testosterone__c = 2,
            Sample_Date__c = Date.today()
        );

        insert bt;

    }
    
    @isTest static void execute(){


        List<Blood_Test__c> bts = [SELECT Id FROM Blood_Test__c ];

        Test.StartTest(); 
        List<GeneratePDFInvocable.Requests> requestList = new List<GeneratePDFInvocable.Requests>();
        GeneratePDFInvocable.Requests req  = new GeneratePDFInvocable.Requests();
        req.recId   = bts[0].Id;
        
        requestList.add(req);
        GeneratePDFInvocable.generatePDF(bts[0].Id);

        Test.StopTest();
    }
    
    @isTest static void execute2(){


        List<Blood_Test__c> bts = [SELECT Id FROM Blood_Test__c ];

        Test.StartTest(); 
        List<GeneratePDFInvocable.Requests> requestList = new List<GeneratePDFInvocable.Requests>();
        GeneratePDFInvocable.Requests req  = new GeneratePDFInvocable.Requests();
        req.recId   = bts[0].Id;
        
        requestList.add(req);
        GeneratePDFInvocable.execute(requestList);

        Test.StopTest();
    }
    
    @isTest static void execute3(){


        List<Blood_Test__c> bts = [SELECT Id FROM Blood_Test__c ];

        Test.StartTest(); 
        List<GeneratePDFInvocableV2.Requests> requestList = new List<GeneratePDFInvocableV2.Requests>();
        GeneratePDFInvocableV2.Requests req  = new GeneratePDFInvocableV2.Requests();
        req.recId   = bts[0].Id;
        
        requestList.add(req);
        GeneratePDFInvocableV2.execute(requestList);

        Test.StopTest();
    }
}