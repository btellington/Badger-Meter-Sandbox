trigger AssignLegacyOpptys on Opportunity (before insert) {
	List<Id> accountIds = new List<Id>();
    List<Account> parentAccounts = new List<Account>();
    for(Opportunity oppty : Trigger.new)
    {
        accountIds.add(oppty.AccountId);    
    }
    
    parentAccounts = [Select Id, OwnerId from Account where Id in :accountIds];
    Map<Id,Account> accountMap = new Map<Id,Account>();
    
    for(Account a : parentAccounts)
    {
        accountMap.put(a.Id,a);
    }
    
    for(Opportunity oppty : Trigger.new)
    {
        Account parentAccount = accountMap.get(oppty.AccountId);
        if(parentAccount != null && oppty.StageName == 'X - Salesforce Go-Live')
        {
            oppty.OwnerId = parentAccount.OwnerId;
        }
    }
}