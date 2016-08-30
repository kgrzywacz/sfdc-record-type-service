@isTest class RecordTypeServiceTest {

	@testSetup static void testSetup(){}

	@isTest static void mainFuncioanlity(){
		String metricCompletitionName, metricProgressName, metricCompletitionDName, metricProgressDname;
		Integer numberOfQueries = 0;
		Test.startTest();
		metricCompletitionName = RecordTypeService.getRecordTypeIdByName('Metric', 'Completion');
		metricProgressName  = RecordTypeService.getRecordTypeIdByName('Metric', 'Progress');
		metricCompletitionDName  = RecordTypeService.getRecordTypeIdByDeveloperName('Metric', 'Completion');
		metricProgressDname = RecordTypeService.getRecordTypeIdByDeveloperName('Metric', 'Progress');
		numberOfQueries = Limits.getQueries();
		Test.stopTest();
		System.assert(!String.isBlank(metricCompletitionName), 'This shoulnd\'t be empty');
		System.assert(!String.isBlank(metricProgressName), 'This shoulnd\'t be empty');
		System.assert(!String.isBlank(metricCompletitionDName), 'This shoulnd\'t be empty');
		System.assert(!String.isBlank(metricProgressDName), 'This shoulnd\'t be empty');
		System.assertEquals(1, numberOfQueries, 'Number of queries should always equal to 1.');
	}

	@isTest static void exceptionBlankSObject(){
		String excMsg1, excMsg2;
		Test.startTest();
		try{
			RecordTypeService.getRecordTypeIdByName('', 'A test record type');
		} catch (Exception e) {
			excMsg1 = e.getMessage();
		}
		try{
			RecordTypeService.getRecordTypeIdByDeveloperName(null, 'A_test_record_type');
		} catch (Exception e) {
			excMsg2 = e.getMessage();
		}
		Test.stopTest();
		System.assertEquals('sObjectType and recordTypeName parameters cannot be blank', excMsg1);
		System.assertEquals('sObjectType and recordTypeDeveloperName parameters cannot be blank', excMsg2);
	}

	@isTest static void exceptionNoSObject(){
		String excMsg1, excMsg2;
		Test.startTest();
		try{
			RecordTypeService.getRecordTypeIdByName('A test name', 'A test record type');
		} catch (Exception e) {
			excMsg1 = e.getMessage();
		}
		try{
			RecordTypeService.getRecordTypeIdByDeveloperName('A_test_name', 'A_test_record_type');
		} catch (Exception e) {
			excMsg2 = e.getMessage();
		}
		Test.stopTest();
		System.assertEquals('There is no sObject with Name \'A test name\'', excMsg1);
		System.assertEquals('There is no sObject with Name \'A_test_name\'', excMsg2);
	}

	@isTest static void exceptionBlankRecordType(){
		String excMsg1, excMsg2;
		Test.startTest();
		try{
			RecordTypeService.getRecordTypeIdByName('Opportunity', '');
		} catch (Exception e) {
			excMsg1 = e.getMessage();
		}
		try{
			RecordTypeService.getRecordTypeIdByDeveloperName('Opportunity', null);
		} catch (Exception e) {
			excMsg2 = e.getMessage();
		}
		Test.stopTest();
		System.assertEquals('sObjectType and recordTypeName parameters cannot be blank', excMsg1);
		System.assertEquals('sObjectType and recordTypeDeveloperName parameters cannot be blank', excMsg2);
	}

	@isTest static void exceptionNoRecordType(){
		String excMsg1, excMsg2;
		Test.startTest();
		try{
			RecordTypeService.getRecordTypeIdByName('Opportunity', 'A test record type');
		} catch (Exception e) {
			excMsg1 = e.getMessage();
		}
		try{
			RecordTypeService.getRecordTypeIdByDeveloperName('Opportunity', 'A_test_record_type');
		} catch (Exception e) {
			excMsg2 = e.getMessage();
		}
		Test.stopTest();
		System.assertEquals('sObject Opportunity doesn\'t have a record type with Name \'A test record type\'', excMsg1);
		System.assertEquals('sObject Opportunity doesn\'t have a record type with DeveloperName \'A_test_record_type\'', excMsg2);
	}

	@isTest static void exceptionTooManySoql(){
		String excMsg1, excMsg2;
		List<Account> temp;
		Test.startTest();
		System.assertEquals(0, Limits.getQueries(), '');
		for(Integer i = 0; i < 100; i++){
			temp = [SELECT Id FROM Account];
		}
		System.assertEquals(100, Limits.getQueries(), '');
		try{
			RecordTypeService.getRecordTypeIdByDeveloperName('Metric', 'Completion');
		} catch (Exception e) {
			excMsg1 = e.getMessage();
		}
		Test.stopTest();
		System.assertEquals('Calling this service would cause \'Too many SOQL queries\' exception. Service unavailable', excMsg1);
	}
	
	
}