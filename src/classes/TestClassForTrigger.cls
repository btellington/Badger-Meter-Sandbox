@isTest
private class TestClassForTrigger {

    static testMethod void myUnitTest() {
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Account';
        insert objAcc;
        
        Opportunity objOppty = new Opportunity();
        objOppty.AccountId = objAcc.id;
        objOppty.CloseDate = date.today();
        objOppty.Amount = 1200;
        objOppty.StageName = '1-Top Account';
        objOppty.Name = 'Test oppty';
        insert objOppty;
    }
}