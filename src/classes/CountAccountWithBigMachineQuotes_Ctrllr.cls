public class CountAccountWithBigMachineQuotes_Ctrllr {
    //Account with Big Machines Quotes
    public Set<Id> accIdsWithBMQ {get;set;}
    public List<Account> accLists {get;set;}
    public Integer accWithBMQ {get;set;}
    
    //Account Parent of the Account with BMQ (only count Accounts not yet in Account with BMQ)
    public Set<Id> parentAccIds {get;set;}
    
    //Opportunity with Big Machines Quotes
    public Set<Id> oppIdsWithBMQ {get;set;}
    public List<Opportunity> oppLists {get;set;}
    public Integer oppWithBMQ {get;set;}
    
    //Opportunity wih Account(without Big Machine Quotes)
    public List<Opportunity> oppWithoutAcc {get;set;}
    
    //Contact related to the Account with Big Machine Quotes
    public List<Contact> conListWithBMQ {get;set;}
    
    //Contact related to Campaign Member but not included in Contact related to Account (Acc that has BMQ)
    public Set<Id> conRelatedToCampaignMember {get;set;}
    
    //Account related to Contact that is related to Campaign Member
    public Set<Id> accountRelToContact {get;set;}
    
    //AccountContactRole related to "Contact related to Campaign Member but not included in Contact related to Account (Acc that has BMQ)"
    //and "Account related to Contact that is related to Campaign Member"
    public Set<Id> accountContactRoles {get;set;}
    
    //Lead that has campaign
    public Set<Id> leadwithCampaignIds {get;set;}
    public Integer leadcounts {get;set;}
    
    //Account Contact Role related to the Account that have BMQ and Contact that is related to the Account that have BMQ
    public Set<Id> accConRole {get;set;}
    public Integer countsAccConRole {get;set;}
    
    //Events that are related to Account that has BMQ
    public Set<Id> eventIds {get;set;}
    public Integer countEvent {get;set;}
    
    //Campaign with Campaign
    public Set<Id> campaignWithCampaignParent {get;set;}
    public Integer countCampaignWithCampaignParent {get;set;}
    public Set<Id> campaignParentIds {get;set;}
    public Integer countCampaignParent {get;set;}
    
    
    
    public CountAccountWithBigMachineQuotes_Ctrllr() {
        //Account with Big Machines Quotes
        accIdsWithBMQ = new Set<Id>();
        for (BigMachines__Quote__c acct: [SELECT BigMachines__Account__c FROM BigMachines__Quote__c WHERE BigMachines__Account__c != null]){
            accIdsWithBMQ.add(acct.BigMachines__Account__c);
        }
        accLists = new List<Account>();
        accLists = getAccounts(accIdsWithBMQ);
        accWithBMQ = accIdsWithBMQ.size();
        
        //Account Parent of the Account with BMQ (only count Accounts not yet in Account with BMQ)
        parentAccIds = new Set<Id>();
        for (Account acc: [SELECT Id,ParentId FROM Account WHERE Id IN :accIdsWithBMQ AND ParentId != null]) {
            if (!accIdsWithBMQ.contains(acc.ParentId)) {
                parentAccIds.add(acc.ParentId);
            }
        }
        
        //Opportunity with Big Machines Quotes
        oppIdsWithBMQ = new Set<Id>();
        for (BigMachines__Quote__c acct: [SELECT BigMachines__Opportunity__c FROM BigMachines__Quote__c WHERE BigMachines__Opportunity__c != null]){
            oppIdsWithBMQ.add(acct.BigMachines__Opportunity__c);
        }
        oppLists = new List<Opportunity>();
        oppLists = getOpportunity(oppIdsWithBMQ);
        oppWithBMQ = oppIdsWithBMQ.size();
        
        //Opportunity with Account(without Big Machine Quotes)
        oppWithoutAcc = new List<Opportunity>();
        for (Opportunity opp: oppLists) {
            if (!accIdsWithBMQ.contains(opp.AccountId)) {
                oppWithoutAcc.add(opp);
            }
        }
        
        //Contact related to the Account that Big Machine Quotes
        conListWithBMQ = new List<Contact>();
        Set<Id> conIdsRelatedtoAccWithBMQ = new Set<Id>();
        for (Contact con: [SELECT Id FROM Contact WHERE AccountId IN :accIdsWithBMQ]) {
            conIdsRelatedtoAccWithBMQ.add(con.Id);
        }
        conListWithBMQ = getContacts(conIdsRelatedtoAccWithBMQ);
        
        //Get Contact related to Campaign Member but not included in Contact that is related to Account (Acc has BMQ)
        conRelatedToCampaignMember = new Set<Id>();
        conRelatedToCampaignMember = getContactRelatedToCampaignMember(conIdsRelatedtoAccWithBMQ);
        
        accountRelToContact = new Set<Id>();
        for (Contact con: [SELECT AccountId FROM Contact WHERE Id IN :conRelatedToCampaignMember]) {
            if (!accountRelToContact.contains(con.AccountId)) {
                accountRelToContact.add(con.AccountId);
            }
        }
        accountContactRoles = new Set<Id>();
        for (AccountContactRole acr: [SELECT Id FROM AccountContactRole WHERE AccountId IN :accountRelToContact AND ContactId IN :conRelatedToCampaignMember]) {
            if (!accountContactRoles.contains(acr.Id)) {
                accountContactRoles.add(acr.Id);
            }
        }
        
        leadwithCampaignIds = new Set<Id>();
        for (CampaignMember cm: [SELECT LeadId FROM CampaignMember WHERE CampaignId != null AND LeadId != null]) {
            if (!leadwithCampaignIds.contains(cm.LeadId)) {
                leadwithCampaignIds.add(cm.LeadId);
            }
        }
        leadcounts = leadwithCampaignIds.size();
        
        //Account Contact Role
        accConRole = new Set<Id>();
        for (AccountContactRole acr: [SELECT Id FROM AccountContactRole WHERE AccountId IN :accIdsWithBMQ AND ContactId IN :conIdsRelatedtoAccWithBMQ]) {
            if (!accConRole.contains(acr.Id)) {
                accConRole.add(acr.Id);
            }
        }
        countsAccConRole = accConRole.size();
        
        //Events that are related to Account that has BMQ
        eventIds = new Set<Id>();
        for (Event e: [SELECT Id FROM Event WHERE AccountId != null]) {
            if (!eventIds.contains(e.Id)) {
                eventIds.add(e.Id);
            }
        }
        countEvent = (eventIds.size()>0) ?eventIds.size() : 0;
        
        //Campaign that has campaign
        campaignWithCampaignParent = new Set<Id>();
        campaignParentIds = new Set<Id>();
        for (Campaign c: [SELECT Id, ParentId FROM Campaign WHERE ParentId != null]) {
            if (!campaignWithCampaignParent.contains(c.Id)) {
                campaignWithCampaignParent.add(c.Id);
            }
            if (!campaignParentIds.contains(c.ParentId)) {
                campaignParentIds.add(c.ParentId);
            }
        }
        countCampaignWithCampaignParent = (campaignWithCampaignParent.size()>0) ? campaignWithCampaignParent.size() : 0;
    }
    
    public List<Account> getAccounts(Set<Id> accIds) {
        List<Account> accountList = new List<Account>();
        for (Account acct: [SELECT Id, Name FROM Account WHERE Id IN :accIds]) {
            accountList.add(acct);
        }
        return accountList;
    }
    
    public List<Contact> getContacts(Set<Id> conIds) {
        List<Contact> contactList = new List<Contact>();
        for (Contact con: [SELECT Id, Name, AccountId FROM Contact WHERE Id IN :conIds]) {
            contactList.add(con);
        }
        return contactList;
    }
    
    public List<Opportunity> getOpportunity(Set<Id> oppIds) {
        List<Opportunity> oppList = new List<Opportunity>();
        for (Opportunity opp: [SELECT Id, Name, AccountId FROM Opportunity WHERE Id IN :oppIds]) {
            oppList.add(opp);
        }
        return oppList;
    }
    
    public Set<Id> getContactRelatedToCampaignMember(Set<Id> conIdsRelatedtoAccWithBMQ) {
        Set<Id> cmConIds = new Set<Id>();
        Set<Id> conIds = new Set<Id>();
        for (CampaignMember cm: [SELECT CampaignId,ContactId,Id,LeadId,Partner_Contact__c FROM CampaignMember WHERE CampaignId != null]) {
            conIds.add(cm.ContactId);
        }
        for (Contact con: [SELECT Id FROM Contact WHERE Id IN :conIds]) {
            if (!conIdsRelatedtoAccWithBMQ.contains(con.Id)) {
                cmConIds.add(con.Id);
            }
        }
        return cmConIds;
    }
}