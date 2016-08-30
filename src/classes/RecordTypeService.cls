global class RecordTypeService {
	private static Map<String, Map<String, Map<String, Id>>> mainMap;

	global static Id getRecordTypeIdByDeveloperName(String sObjectType, String recordTypeDeveloperName){
		return getRecordTypeId(sObjectType, 'DeveloperName', recordTypeDeveloperName);
	}

	global static Id getRecordTypeIdByName(String sObjectType, String recordTypeName){
		return getRecordTypeId(sObjectType, 'Name', recordTypeName);
	}

	private static Id getRecordTypeId(String sObjectType, String fieldName, String fieldValue) {
		if(String.isBlank(sObjectType) || String.isBlank(fieldValue)){
			throw new RecordTypeServiceException('sObjectType and recordType' + fieldName + ' parameters cannot be blank');
		}
		If(!getMainMap().containsKey(sObjectType.toLowerCase())){
			throw new RecordTypeServiceException('There is no sObject with Name \'' + sObjectType + '\'');
		}
		Id returnValue = getMainMap().get(sObjectType.toLowerCase()).get(fieldName.toLowerCase()).get(fieldValue.toLowerCase());
		if(String.isBlank(returnValue)){
			throw new RecordTypeServiceException('sObject ' + sObjectType + ' doesn\'t have a record type with ' + fieldName + ' \''+ fieldValue+'\'');
		}
		return returnValue;
	}

	private static Map<String, Map<String, Map<String, Id>>> getMainMap() {
		if(!isMainMapInitialized()){
			initialiseMainMap();
		}
		return mainMap;
	}

	private static boolean isMainMapInitialized(){
		return mainMap != null;
	}

	private static void initialiseMainMap(){
		mainMap = new Map<String, Map<String, Map<String, Id>>>();
		for(RecordType current : getRecordTypes()){
			processRecordType(current);
		}
	}

	private static List<RecordType> getRecordTypes(){
		if(!(Limits.getQueries() < Limits.getLimitQueries())){
			throw new RecordTypeServiceException('Calling this service would cause \'Too many SOQL queries\' exception. Service unavailable');
		}
		return [SELECT Id, Name, DeveloperName, sObjectType FROM RecordType];
	}

	private static void processRecordType(RecordType rtObject) {
		if(!mainMap.containsKey(rtObject.sObjectType.toLowerCase())) {
			mainMap.put(rtObject.sObjectType.toLowerCase(), new Map<String, Map<String, Id>>());
		}
		fillMapForSObjectType(rtObject, mainMap.get(rtObject.sObjectType.toLowerCase()));
	}

	private static void fillMapForSObjectType(RecordType rtObject, Map<String,Map<String, Id>> rtObjectSpecificMap) {
		if(!rtObjectSpecificMap.containsKey('developername')){
			rtObjectSpecificMap.put('developername', new Map<String, Id>());
		}
		if(!rtObjectSpecificMap.containsKey('name')){
			rtObjectSpecificMap.put('name', new Map<String, Id>());
		}
		rtObjectSpecificMap.get('developername').put(rtObject.DeveloperName.toLowerCase(), rtObject.Id);
		rtObjectSpecificMap.get('name').put(rtObject.Name.toLowerCase(), rtObject.Id);
	}

	public class RecordTypeServiceException extends Exception{ }
}