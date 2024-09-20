trigger AttachmentMoveToFile on Attachment (After insert) {

    for(Attachment attach : Trigger.new) {
        
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; 
        cVersion.PathOnClient = attach.Name;
        cVersion.Origin = 'H';
        cVersion.OwnerId = attach.OwnerId;
        cVersion.Title = attach.Name;
        cVersion.VersionData = attach.Body;
        Insert cVersion;
    
        //After saved the Content Verison, get the ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
 
        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;
        cDocLink.LinkedEntityId = attach.ParentId;
        cDocLink.ShareType = 'V';
        cDocLink.Visibility = 'AllUsers';
        Insert cDocLink;
     
            
         }
}