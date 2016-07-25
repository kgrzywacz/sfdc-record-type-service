# SFDC record type service
A simple way to limit database calls for obtaining record type Ids in your code.

# Overview
Information about record type ids are required in almost every transation. This means either using built-in Schema class, which allows to get record type info either by Id or by Name(read label). Labels change, Ids change too, and usually we need something more reliable.

This service provides possibility to get Id of any record type in the the system either by `Name` or `DeveloperName` fields using only one SOQL call per each transaction. One SOQL transactoin is used to obtain information about all record types in the system, and build a map of them, after that each call to this service will return data stored in the map.

# Usage
RecordTypeService provides two public methods:
```Apex
RecordTypeService.getRecordTypeIdByName(String sObjectApiName, String recordTypeName)
```
and
```Apex
RecordTypeService.getRecordTypeIdByDeveloperName(String sObjectApiName, String recordTypeDeveloperName)
```

Each of above method will throw an exception if:
* There is no sObject with provided Api name in the system.
* There is no record type with given Name/DeveloperName for sObject in the your organisation.
* Calling this method would cause Too many SOQL queries exception (This may happen if you after you've done 100 SOQLs in synchronous transaction (200 in asynchronous).

# TODO
* Proper exceptions
* Test class
