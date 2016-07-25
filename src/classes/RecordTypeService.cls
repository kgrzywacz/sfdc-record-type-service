global class RecordTypeService {
	private static Map<String, Map<String, Map<String, Id>>> mainMap;

	global static Id getRecordTypeIdByDeveloperName(String sObjectType, String recordTypeDeveloperName){
		if(String.isBlank(sObjectType)){
			throw new RecordTypeServiceException('sObjectType parameter of the method cannot be blank');
		}
		return getMainMap().get(sObjectType.toLowerCase()).get('developerName').get(recordTypeDeveloperName.toLowerCase());
	}

	global static Id getRecordTypeIdByName(String sObjectType, String recordTypeName){
		return getMainMap().get(sObjectType.toLowerCase()).get('name').get(recordTypeName.toLowerCase());
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
		return [SELECT Id, Name, DeveloperName, sObjectType FROM RecordType];
	}

	private static void processRecordType(RecordType rtObject) {
		if(!mainMap.containsKey(rtObject.sObjectType.toLowerCase())) {
			mainMap.put(rtObject.sObjectType.toLowerCase(), new Map<String, Map<String, Id>>());
		}
		fillMapForSObjectType(rtObject, mainMap.get(rtObject.sObjectType.toLowerCase()));
	}

	private static void fillMapForSObjectType(RecordType rtObject, Map<String,Map<String, Id>> rtObjectSpecificMap) {
		if(!rtObjectSpecificMap.containsKey('developerName')){
			rtObjectSpecificMap.put('developerName', new Map<String, Id>());
		}
		if(!rtObjectSpecificMap.containsKey('name')){
			rtObjectSpecificMap.put('name', new Map<String, Id>());
		}
		rtObjectSpecificMap.get('developerName').put(rtObject.DeveloperName.toLowerCase(), rtObject.Id);
		rtObjectSpecificMap.get('name').put(rtObject.Name.toLowerCase(), rtObject.Id);
	}

	public class RecordTypeServiceException extends Exception{ }
}