public class GeneratePDFInvocableV2 {
    
    @InvocableMethod(label='Generate PDF Using VFPage without Email' description='Returns the list of account names corresponding to the specified account IDs.')
    public static void execute(List<Requests> requestList) {
        
        if( requestList.size() > 0 ){ 
            String recordId = requestList[0].recId;
            GeneratePDFInvocable.insertBloodTestPDF(recordId);
        }
        
    }
    
    public class Requests {
        @InvocableVariable(label='Record Id' description='Record Id' required=true)
        public String recId;
    }
    

}