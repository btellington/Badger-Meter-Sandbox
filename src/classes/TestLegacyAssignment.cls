@isTest
public class TestLegacyAssignment {
	static testMethod void testLegacyAssignments() {
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User someUser = new User(Email='test1@test.com', 
							   	 LastName='Test Owner',
							     Username='testing@badgermeter.com',
							     Alias='test1',
							     CommunityNickname='test1',
							     TimeZoneSidKey='America/Los_Angeles',
							     LocaleSidKey='en_US',
							     EmailEncodingKey='UTF-8',
							     ProfileId = p.Id,
							     LanguageLocaleKey='en_US'
							     );
							     
		insert someUser;
		
		User someUser2 = new User(Email='test2@test.com', 
							   	 LastName='Test Owner 2',
							     Username='testing2@badgermeter.com',
							     Alias='test2',
							     CommunityNickname='test2',
							     TimeZoneSidKey='America/Los_Angeles',
							     LocaleSidKey='en_US',
							     EmailEncodingKey='UTF-8',
							     ProfileId = p.Id,
							     LanguageLocaleKey='en_US'
							     );
							     
		insert someUser2;
		
		Account someAcct = new Account(Name = 'Test Acct', OwnerId = someUser.Id);
		
		insert someAcct;
		
		System.assert(someAcct.OwnerId == someUser.Id);
		
		Opportunity someOppty = new Opportunity(Name = 'Test Oppty',
											    StageName = 'X - Salesforce Go-Live',
											    CloseDate = Date.parse('2/14/2014'),
											    AccountId = someAcct.Id);
											    
		insert someOppty;
		
		System.assert(someOppty.AccountId == someAcct.Id);
		
		Opportunity o = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :someOppty.Id];
		
		System.assert(o.OwnerId == someUser.Id);
		
		BigMachines__Quote__c someQuote = new BigMachines__Quote__c(BigMachines__Opportunity__c = someOppty.Id);
		
		insert someQuote;
		
		BigMachines__Quote__c q = [SELECT Id, OwnerId FROM BigMachines__Quote__c WHERE Id = :someQuote.Id];
		
		System.assert(q.OwnerId == someUser.Id);
	}
}