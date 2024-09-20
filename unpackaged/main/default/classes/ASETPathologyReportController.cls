/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
 public with sharing class ASETPathologyReportController {
    public Blood_Test__c btRecord { get; set; }
    public Contact contact { get; set; }
    public String high { get; set; }
    public String low { get; set; }
    public String sampleDateStr { get; set; } //Added Apr-19-2024

    public ASETPathologyReportController(ApexPages.StandardController controller) {
        try {

            Id recordId = ApexPages.currentPage().getParameters().get('id');

            List<Blood_Test__c> btData = [ SELECT Account_Owner__c,Additions__c,Albumin_Max__c,Albumin_Min__c,Albumin_Units__c,Albumin__c,ALP__c,ALT__c,
                                          Analysis_Lab__c,Basophils_Max__c,Basophils_Min__c,Basophils_percentage__c,Basophils_Units__c,Basophils__c,
                                          Bespoke_Meddx_Kit_Type__c,Bespoke_Test_Type__c,Cholesterol__c,Collection_Method__c,Contact__c,
                                          CreatedById,CreatedDate,Creatine_Kinase__c,Creatinine_Max__c,Creatinine_Min__c,Creatinine_Units__c,Creatinine__c,
                                          CRP_High_Sensitivity__c,DHEA_S__c,Dihydrotestosterone__c,Dispatch_Date_Time__c,eGFR_Max__c,eGFR_MDRD__c,eGFR_Min__c,
                                          eGFR_Units__c,Eosinophils_Max__c,Eosinophils_Min__c,Eosinophils_percentage__c,Eosinophils_Units__c,Eosinophils__c,
                                          Failed_Values__c,Ferritin__c,Film_Report__c,Free_Androgen_Index__c,Free_T4__c,Free_Testosterone__c,Free_Test__c,
                                          FSH__c,GGT__c,Globulin_Max__c,Globulin_Min__c,Globulin_Units__c,Globulin__c,Glucose__c,Haematocrit_Max__c,Haematocrit_Min__c,
                                          Haematocrit_Units__c,Haematocrit__c,Haemoglobin_Max__c,Haemoglobin_Min__c,Haemoglobin_Units__c,Haemoglobin__c,HbA1c_Max__c,
                                          HbA1c_Min__c,HbA1c_Units__c,HbA1c__c,HDL_Cholesterol_ratio__c,HDL__c,Id,IGF_1__c,Internal_Dispatch_Order__c,Iron__c,IsDeleted,
                                          Labs_Test_ID__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,LDL__c,LH__c,
                                          Low_Testosterone_Flag__c,Lymphocytes_Max__c,Lymphocytes_Min__c,Lymphocytes_percentage__c,Lymphocytes_Units__c,Lymphocytes__c,
                                          Magnesium__c,Manual_New_Order__c,MCHC_Max__c,MCHC_Min__c,MCHC_Units__c,MCHC__c,Mean_Cell_Haemoglobin_Max__c,
                                          Mean_Cell_Haemoglobin_Min__c,Mean_Cell_Haemoglobin_Units__c,Mean_Cell_Haemoglobin__c,Mean_Cell_Volume_Max__c,
                                          Mean_Cell_Volume_Min__c,Mean_Cell_Volume_Units__c,Mean_Cell_Volume__c,Meddx_Kit_Type__c,Monocytes_Max__c,
                                          Monocytes_Min__c,Monocytes_percentage__c,Monocytes_Units__c,Monocytes__c,MPV_Max__c,MPV_Min__c,MPV_Units__c,MPV__c,Name,
                                          Neutrophils_Max__c,Neutrophils_Min__c,Neutrophils_percentage__c,Neutrophils_Units__c,Neutrophils__c,Non_HDL_Cholesterol__c,
                                          Oestradiol__c,Order_Date__c,Patient_Status__c,Patient_Submitted_Results__c,PDF_Results_Upload_Date_Time__c,Platelets_Max__c,
                                          Platelets_Min__c,Platelets_Units__c,Platelets__c,Prolactin__c,PSA_Prostate__c,QR_Code_Form__c,QR_Code_Mini__c,
                                          Reason_for_failed_values__c,Red_Blood_Cells_Max__c,Red_Blood_Cells_Min__c,Red_Blood_Cells_Units__c,Red_Blood_Cells__c,
                                          Red_Cell_Distribution_Max__c,Red_Cell_Distribution_Min__c,Red_Cell_Distribution_Units__c,Red_Cell_Distribution__c,
                                          Replacement_Kit__c,Replacement_Reason__c,Results_Status__c,Sample_Date_Time__c,Serum_Folate__c,SHBG__c,Sodium_Max__c,Sodium_Min__c,
                                          Sodium_Units__c,Sodium__c,Status__c,SystemModstamp,Testing_Laboratory__c,Testosterone__c,Test_Result_Data__c,Test_Type__c,
                                          TIBC__c,Total_Bilirubin__c,Total_Protein_Max__c,Total_Protein_Min__c,Total_Protein_Units__c,Total_Protein__c,
                                          Transferrin_Saturation__c,Triglycerides__c,TSH__c,UIBC__c,Urea_Max__c,Urea_Min__c,Urea_Units__c,Urea__c,Vitamin_B12__c,
                                          Vitamin_D__c,Website_Order_ID__c,Website_Order__c,White_Blood_Cells_Max__c,White_Blood_Cells_Min__c,White_Blood_Cells_Units__c,
                                          White_Blood_Cells__c, ALT_Min__c ,ALT_Max__c,ALT_Units__c, GGT_Max__c ,GGT_Min__c ,GGT_Units__c,Ferritin_Min__c,Ferritin_Max__c,Ferritin_Units__c,
                                           Total_Bilirubin_Max__c,Total_Bilirubin_Min__c,Total_Bilirubin_Units__c,ALP_Max__c,ALP_Min__c,ALP_Units__c,
                                          Cholesterol_Max__c,Cholesterol_Min__c	,Cholesterol_Units__c, HDL_Max__c,HDL_Min__c,HDL_Units__c, Triglycerides_Max__c ,Triglycerides_Min__c,
                                          Triglycerides_Units__c,LDL_Max__c	,LDL_Min__c,LDL_Units__c,HDL_Cholesterol_ratio_Max__c,HDL_Cholesterol_ratio_Min__c,HDL_Cholesterol_ratio_Units__c,
                                          Non_HDL_Cholesterol_Max__c,Non_HDL_Cholesterol_Min__c,Non_HDL_Cholesterol_Units__c, FSH_Max__c,FSH_Min__c,FSH_Units__c, LH_Max__c,
                                           LH_Min__c,LH_Units__c,Free_Testosterone_Max__c,Free_Testosterone_Min__c,Free_Testosterone_Units__c, Oestradiol_Max__c,Oestradiol_Min__c,Oestradiol_Units__c,
                                           SHBG_Max__c,SHBG_Min__c,SHBG_Units__c , Prolactin_Max__c ,Prolactin_Min__c ,Prolactin_Units__c, Testosterone_Max__c,Testosterone_Min__c,Testosterone_Units__c,
                                          TSH_Max__c,TSH_Min__c,TSH_Units__c, Free_T4_Max__c ,Free_T4_Min__c,Free_T4_Units__c, PSA_Prostate_Max__c,PSA_Prostate_Min__c,PSA_Prostate_Units__c, Magnesium_Max__c, Magnesium_Min__c, Magnesium_Units__c, Cortisol__c, Cortisol_Max__c, Cortisol_Min__c, Cortisol_Units__c,
                                          HDL_of_Total__c, HDL_of_Total_Min__c, HDL_of_Total_Field_Max__c, HDL_Unit__c, Haematocrit_Adj__c, Haematocrit_Min_Adj__c, Haematocrit_Max_Adj__c, Haematocrit_Units_Adj__c FROM Blood_Test__c WHERE Id = :recordId LIMIT 1];

            this.btRecord   = btData[0];
 
            if( btData.size() > 0 ){
                this.contact    = [SELECT accountId,account.Age__pc,Date_of_Birth__c,LastName,FirstName,Name,Patient_ID__c, Gender__c FROM Contact WHERE Id = :btData[0].Contact__c LIMIT 1 ];
                //Added Apr-19-2024
                //START
                Organization org = [SELECT TimeZoneSidKey FROM Organization LIMIT 1];
                sampleDateStr = this.btRecord.Sample_Date_Time__c?.format('dd/MM/yyyy HH:mm:ss', org.TimeZoneSidKey);
                //END
            } else {
                this.contact    = new Contact();
            } 

            this.high       = 'H';
            this.low        = 'L';

        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }

    }
}