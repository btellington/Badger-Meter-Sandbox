/**
 	@author: Lennard Santos (CloudSherpas)
 	@description: Test Coverage for SendLeadEmailController
 	@Date Created: Nov 21 2013
 */
@isTest
private class SendLeadEmailController_Test {
	
	static Account createTestData_Account(){
        RecordType rt = [Select Id from RecordType WHERE sObjectType = 'Account' AND DeveloperName = :'End_User']; 
        Account testAccount = new Account(
        	Name = 'Test Account',
        	RecordTypeId = rt.Id
        );
        insert testAccount;
        return testAccount;
        
    }
	
	static Contact createTestData_Contact(Account acct,String email){
		Contact testContact = new Contact(
			LastName = 'Test Contact',
			AccountId = acct.Id,
			Email = email
		);
		insert testContact;
		return testContact;
	}
	
	static Lead createTestData_Lead(){
		Lead testLead = new Lead(
			LastName = 'TestLead',
			Title = 'CEO',
			Company = 'Green Systems',
			LeadSource = 'Distributor',
			Website = 'www.greensystem.com',
			Industry = 'Aerospace',
			Purchase_Timeframe__c = 'within 1 month',
			Phone = '12345678',
			Email = 'test@greensystem.com',
			Applications_Of__c = 'Calibration;Monitor',
			Product__c = 'Coriolis;Communications'
		);
		insert testLead;
		return testLead;
	}
	
	static Campaign createTestData_Campaign(){
		Campaign testCampaign = new Campaign(
			Name = 'ABC',
			IsActive = true
		);
		insert testCampaign;
		return testCampaign;
	}
	
	static CampaignMember createTestData_CampMember(Campaign camp,Lead leadRec){
		CampaignMember testCmpMember = new CampaignMember(
			CampaignId = camp.Id,
			LeadId = leadRec.Id,
			Status = 'Sent'
		);
		insert testCmpMember;
		return testCmpMember;
	}
	
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
        	Account testAccount = createTestData_Account();
        	Contact testContact = createTestData_Contact(testAccount,'mary@barnyard.com');
        	Lead testLead = createTestData_Lead();
        	Campaign testCamp = createTestData_Campaign();
        	CampaignMember testCampMember = createTestData_CampMember(testCamp,testLead);
        	PageReference pageRef = Page.SendEmailPopup;
        Test.setCurrentPageReference(pageRef);
        	System.currentPageReference().getParameters().put('id',testLead.Id);	
        	ApexPages.Standardcontroller s = new ApexPages.Standardcontroller(testLead);
        	SendLeadEmailController sendLeadCon = new SendLeadEmailController(s);	
        	System.assertEquals(sendLeadCon.campName, testCamp.Name);
        	sendLeadCon.showEmailPopup();
        	sendLeadCon.searchString = 'Lead';
        	sendLeadCon.searchBtn();
        	System.assert(sendLeadCon.conList.isEmpty());
        	sendLeadCon.searchString = 'Contact';
        	sendLeadCon.searchBtn();
        	System.assert(!sendLeadCon.conList.isEmpty());
        	sendLeadCon.saveConList();
        	sendLeadCon.conList[0].isChecked = true;
        	sendLeadCon.saveConList();
        	sendLeadCon.closeEmailPopup();
        	sendLeadCon.showManualPopup();
        	sendLeadCon.hideManualPopup();
        	sendLeadCon.strEmail = 'test@salesforce.com';
        	sendLeadCon.addManualAddress();
        	System.debug('\n\nCONLIST SELECTED : '+sendLeadCon.conListSelected + '\n\n');
        	sendLeadCon.conListSelected[0].isChecked = true;
        	sendLeadCon.removeFromList();
        Test.setCurrentPageReference(sendLeadCon.sendMassEmail());
        	System.debug('\n\n\n'+System.currentPageReference()+'\n\n\n');
        	
        Test.stopTest();
    }
    
    static testMethod void testOtherScenario(){
    	Test.startTest();
    	System.debug('\n\n\n*******************TEST OTHER SCENARIO*********************\n\n\n');
    		Account testAccount = createTestData_Account();
        	Contact testContact = createTestData_Contact(testAccount,'mary@barnyard.com');
        	Lead testLead = createTestData_Lead();
        	Campaign testCamp = createTestData_Campaign();
        	CampaignMember testCampMember = createTestData_CampMember(testCamp,testLead);
        	PageReference pageRef = Page.SendEmailPopup;
        	Test.setCurrentPageReference(pageRef);
        	System.currentPageReference().getParameters().put('id',testLead.Id);	
        	ApexPages.Standardcontroller s = new ApexPages.Standardcontroller(testLead);
        	SendLeadEmailController sendLeadCon = new SendLeadEmailController(s);
        	sendLeadCon.sendMassEmail();
        	System.debug('\n\nCONLIST SELECTED : ' + sendLeadCon.conListSelected);
        	System.debug('\n\nEMAIL STRING : ' + sendLeadCon.strEmailsplitted);
    		System.debug('\n\n\n'+System.currentPageReference()+'\n\n\n');
    	Test.stopTest();
    	
    }
    
    static testMethod void testContactwithNoEmail(){
    	Test.startTest();
    	System.debug('\n\n\n*******************TEST CONTACT WITH NO EMAIL*********************\n\n\n');
    		Account testAccount = createTestData_Account();
        	Contact testContact = createTestData_Contact(testAccount,'');
        	Lead testLead = createTestData_Lead();
        	Campaign testCamp = createTestData_Campaign();
        	CampaignMember testCampMember = createTestData_CampMember(testCamp,testLead);
        	PageReference pageRef = Page.SendEmailPopup;
        	Test.setCurrentPageReference(pageRef);
        	System.currentPageReference().getParameters().put('id',testLead.Id);	
        	ApexPages.Standardcontroller s = new ApexPages.Standardcontroller(testLead);
        	SendLeadEmailController sendLeadCon = new SendLeadEmailController(s);
        	sendLeadCon.searchString = 'Contact';
        	sendLeadCon.searchBtn();
        	System.debug('\n\n\nCONTACT SEARCH LIST :  '+sendLeadCon.conList + '\n\n\n');
        	sendLeadCon.conList[0].isChecked = true;
        	sendLeadCon.saveConList();
        	sendLeadCon.sendMassEmail();
        	System.debug('\n\nCONLIST SELECTED : ' + sendLeadCon.conListSelected);
        	System.debug('\n\nEMAIL STRING : ' + sendLeadCon.strEmailsplitted);
    		System.debug('\n\n\n'+System.currentPageReference()+'\n\n\n');
    	Test.stopTest();
    	
    }
}