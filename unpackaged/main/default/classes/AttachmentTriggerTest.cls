@isTest
public class AttachmentTriggerTest {
    
    @isTest
    public static void TestAttachmentInsert() {
        
        String bodystring = 'dGVzdA==';
        User accountowner = [SELECT Id FROM User WHERE Alias = 'Admin'];
        
        Account testaccount = new Account(
            LastName = 'Tester', 
            FirstName = 'Test', 
          OwnerID = accountowner.Id);
      
    insert testaccount;
        
        Account getAccount = [SELECT Id FROM Account WHERE LastName = 'Tester'];
            
        system.debug(getAccount.Id);
    
         Attachment testAttachment = new Attachment(
          ParentId = getAccount.Id,
          Body = Blob.valueOf(bodystring),
            Name = 'bank.txt',
      ContentType = 'text/plain',
      Description = 'bank.txt',
      OwnerID = accountowner.Id
           );
        
        Test.startTest();
        
        insert testAttachment;
        
        Test.stopTest();
        
        ContentDocumentLink checknew = [SELECT ShareType, Visibility, ContentDocumentID, LinkedEntityId  FROM ContentDocumentLink WHERE LinkedEntityId = :testaccount.Id ];
        
        System.assertEquals('V', checknew.ShareType);
        System.assertEquals('AllUsers', checknew.Visibility);
        
    }

}