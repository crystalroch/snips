/*

Test class for trigger framework

Class:              Test_TriggerFramework
Date:               04/10/2014
Version:            1
Last Updated:       04/10/2014
    * 	Completed

////////////////////////////////////////////////////////////////////////////////
*/

@isTest
private class Test_TriggerFramework
{	
	// -------- Variables --------
	// None
	
	// -------- Shared Methods --------
	// None
	
	// -------- Test Methods --------
	// Create handlers and populate dispatcher map, than run every type of
	// event through and confirm handler finding
	private static testMethod void dispatcherFramework()
	{
		Type classType = Type.forName('TriggerHandlerBase');
		ITriggerHandler biTriggerHandler = 
			(ITriggerHandler)classType.newInstance();
		ITriggerHandler buTriggerHandler  = 
			(ITriggerHandler)classType.newInstance();
		ITriggerHandler bdTriggerHandler = 
			(ITriggerHandler)classType.newInstance();
		ITriggerHandler aiTriggerHandler = 
			(ITriggerHandler)classType.newInstance();
		ITriggerHandler auTriggerHandler = 
			(ITriggerHandler)classType.newInstance();
		ITriggerHandler adTriggerHandler = 
			(ITriggerHandler)classType.newInstance();
		ITriggerHandler audTriggerHandler = 
			(ITriggerHandler)classType.newInstance();
		
		TriggerDispatcher.handlers.put('AccountBeforeInsertHandler', 
			biTriggerHandler);
		TriggerDispatcher.handlers.put('AccountBeforeUpdateHandler', 
			buTriggerHandler);
		TriggerDispatcher.handlers.put('AccountBeforeDeleteHandler', 
			bdTriggerHandler);
		TriggerDispatcher.handlers.put('AccountAfterInsertHandler', 
			aiTriggerHandler);
		TriggerDispatcher.handlers.put('AccountAfterUpdateHandler', 
			auTriggerHandler);
		TriggerDispatcher.handlers.put('AccountAfterDeleteHandler', 
			adTriggerHandler);
		TriggerDispatcher.handlers.put('AccountAfterUnDeleteHandler', 
			audTriggerHandler);
		
		ApexTrigger triggerFile = new ApexTrigger();
    	triggerFile.Name = 'Account';
    	triggerFile.TableEnumOrId = 'Account';
    	triggerFile.UsageBeforeInsert = true;
    	triggerFile.UsageBeforeUpdate = false;
    	triggerFile.UsageBeforeDelete = false;
    	triggerFile.UsageAfterInsert = false;
    	triggerFile.UsageAfterUpdate = false;
    	triggerFile.UsageAfterDelete = false;
    	triggerFile.UsageAfterUndelete = false;
		TriggerDispatcher.setFrameworkTestParameters(triggerFile, true);
		TriggerDispatcher.execute(Account.sObjectType, null, null, null, null);
		
		triggerFile.UsageBeforeInsert = false;
    	triggerFile.UsageBeforeUpdate = true;
    	triggerFile.UsageBeforeDelete = false;
    	triggerFile.UsageAfterInsert = false;
    	triggerFile.UsageAfterUpdate = false;
    	triggerFile.UsageAfterDelete = false;
    	triggerFile.UsageAfterUndelete = false;
		TriggerDispatcher.setFrameworkTestParameters(triggerFile, true);
		TriggerDispatcher.execute(Account.sObjectType, null, null, null, null);
		
		triggerFile.UsageBeforeInsert = false;
    	triggerFile.UsageBeforeUpdate = false;
    	triggerFile.UsageBeforeDelete = true;
    	triggerFile.UsageAfterInsert = false;
    	triggerFile.UsageAfterUpdate = false;
    	triggerFile.UsageAfterDelete = false;
    	triggerFile.UsageAfterUndelete = false;
		TriggerDispatcher.setFrameworkTestParameters(triggerFile, true);
		TriggerDispatcher.execute(Account.sObjectType, null, null, null, null);
		
		triggerFile.UsageBeforeInsert = false;
    	triggerFile.UsageBeforeUpdate = false;
    	triggerFile.UsageBeforeDelete = false;
    	triggerFile.UsageAfterInsert = true;
    	triggerFile.UsageAfterUpdate = false;
    	triggerFile.UsageAfterDelete = false;
    	triggerFile.UsageAfterUndelete = false;
		TriggerDispatcher.setFrameworkTestParameters(triggerFile, true);
		TriggerDispatcher.execute(Account.sObjectType, null, null, null, null);
		
		triggerFile.UsageBeforeInsert = false;
    	triggerFile.UsageBeforeUpdate = false;
    	triggerFile.UsageBeforeDelete = false;
    	triggerFile.UsageAfterInsert = false;
    	triggerFile.UsageAfterUpdate = true;
    	triggerFile.UsageAfterDelete = false;
    	triggerFile.UsageAfterUndelete = false;
		TriggerDispatcher.setFrameworkTestParameters(triggerFile, true);
		TriggerDispatcher.execute(Account.sObjectType, null, null, null, null);
		
		triggerFile.UsageBeforeInsert = false;
    	triggerFile.UsageBeforeUpdate = false;
    	triggerFile.UsageBeforeDelete = false;
    	triggerFile.UsageAfterInsert = false;
    	triggerFile.UsageAfterUpdate = false;
    	triggerFile.UsageAfterDelete = true;
    	triggerFile.UsageAfterUndelete = false;
		TriggerDispatcher.setFrameworkTestParameters(triggerFile, true);
		TriggerDispatcher.execute(Account.sObjectType, null, null, null, null);
		
		triggerFile.UsageBeforeInsert = false;
    	triggerFile.UsageBeforeUpdate = false;
    	triggerFile.UsageBeforeDelete = false;
    	triggerFile.UsageAfterInsert = false;
    	triggerFile.UsageAfterUpdate = false;
    	triggerFile.UsageAfterDelete = false;
    	triggerFile.UsageAfterUndelete = true;
		TriggerDispatcher.setFrameworkTestParameters(triggerFile, true);
		TriggerDispatcher.execute(Account.sObjectType, null, null, null, null);
		
		Boolean runningResult = 
			TriggerDispatcher.isHandlerRunning('AccountBeforeInsertHandler');
		System.assertEquals(runningResult, false);
		
		Boolean resetResult = 
			TriggerDispatcher.resetHandler('AccountBeforeInsertHandler');
		System.assertEquals(resetResult, true);
		
		try
		{
			triggerFile = new ApexTrigger();
	    	triggerFile.Name = 'Case';
	    	triggerFile.TableEnumOrId = 'Case';
	    	triggerFile.UsageBeforeInsert = true;
	    	TriggerDispatcher.setFrameworkTestParameters(triggerFile, true);
			TriggerDispatcher.execute(Case.sObjectType, null, null, null, null);
		}
		catch (Exception ignore)
		{
			
		}
	}
	
	// Create a trigger handler base and call its public, non override methods
	private static testMethod void handlerBase()
	{
		Type classType = Type.forName('TriggerHandlerBase');
		TriggerHandlerBase testHandlerBase = 
			(TriggerHandlerBase)classType.newInstance();
		
		System.assertEquals(testHandlerBase.isRunning(), false);
		
		testHandlerBase.startRunning();
		System.assertEquals(testHandlerBase.isRunning(), true);
		
		testHandlerBase.stopRunning();
		System.assertEquals(testHandlerBase.isRunning(), false);
		
		testHandlerBase.qualifyReEntryRecords(null, null, null, null);
		testHandlerBase.reEntry();
		testHandlerBase.finish(true);
	}
}