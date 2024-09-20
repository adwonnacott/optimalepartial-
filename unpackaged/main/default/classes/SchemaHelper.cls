/**
 * @description Class to retrieve various Schema properties
 * @date Mar-29-2024
 */
public class SchemaHelper {

    public static Id GetRecordTypeIdByDeveloperName(String objectAPIName, String recordType)
    {
        return Schema.getGlobalDescribe().get(objectAPIName)?.getDescribe().getRecordTypeInfosByDeveloperName().get(recordType)?.getRecordTypeId();
    }
    
    public static Map<String, String> getPicklistValues(String objApiName, String fieldName) 
    {
        Map<String, String>  mapOfPickVals = new Map<String, String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objApiName);
        Sobject objectName = targetType.newSObject();
        Schema.sObjectType objectType = objectName.getSObjectType(); 
        Schema.DescribeSObjectResult sObjectDescribe = objectType.getDescribe(); 
        Map<String, Schema.SObjectField> fieldMap = sObjectDescribe.fields.getMap(); 
        List<Schema.PicklistEntry> pickVal = fieldMap.get(fieldName).getDescribe().getPickListValues(); 
        
        for (Schema.PicklistEntry pv : pickVal) 
        {
            mapOfPickVals.put(pv.getValue(), pv.getLabel());
        }
        return mapOfPickVals;
    }

	public static String getObjectQuery(String strObj, String relFields) 
    {
		Map<String, Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
		Schema.SObjectType objType = globalDescription.get(strObj);
		Schema.DescribeSObjectResult result = objType.getDescribe();
		Map<String, Schema.SObjectField> fieldMap = result.fields.getMap();

		String strQry = 'SELECT ';

		for(Schema.SObjectField f : fieldMap.values()) 
        {
			String strFieldName = f.getDescribe().getName();
			Schema.DescribeFieldResult fr = f.getDescribe();
			strQry += strFieldName + ',';
		}
		strQry = String.isBlank(relFields)?strQry.subString(0, strQry.length() - 1):strQry+relFields;
		strQry += ' FROM ' + strObj;
		return strQry;
	}
}