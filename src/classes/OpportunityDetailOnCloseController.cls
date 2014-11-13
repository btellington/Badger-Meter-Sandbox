public with sharing class OpportunityDetailOnCloseController {

    public String strStage{get;set;}
    public Opportunity oppty;
    private Apexpages.StandardController controller; 
    private PageReference page; 
    private string id;
    private String strRecordTypeId; 
    public OpportunityDetailOnCloseController(ApexPages.StandardController controller)
    {
        this.controller = controller;
        this.oppty = (Opportunity)controller.getrecord();
        this.page = ApexPages.currentPage();
        this.id = page.getParameters().get('id');
        strStage = '';
        
        try{
           strRecordTypeId = [select id from RecordType where SobjectType = 'Opportunity' and Name='Closed Opportunity'].id;
        }  catch(Exception e)
        {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An unexpected error has occurred.Please contact your system administrator');
             ApexPages.addMessage(myMsg);
        }
        
    }
    
    public pagereference Save()
    {
        this.oppty.RecordTypeId = strRecordTypeId;
        update this.oppty;
        List<Task>lstTask = new List<Task>();
        SystemIds__c objsysid = SystemIds__c.getOrgDefaults();
        string strdomain = objsysid.Domain__c;
        if(this.oppty.StageName == 'Closed Won')
        {
            if(this.oppty.Schedule_1_yr_anniversary_reminder_follo__c)
            {
                Task objTask = new Task();
                objTask.OwnerId = Userinfo.getUserId();
                objTask.ActivityDate = date.today().addYears(1);
                objTask.Subject = '1 yr anniversary reminder for won opportunity -'+this.oppty.Name;
                objTask.Description = 'Related to this opportunity: '+strdomain+ApexPages.currentPage().getParameters().get('id');
                objTask.IsReminderSet = true;
                objTask.ReminderDateTime = datetime.now().addYears(1); // Satarupa Roy - 1 year reminder from now as told by Dave on 21st March 2013 as part of post- go live support. 
                objTask.whatId = this.oppty.AccountId;
                lstTask.add(objTask);
            }
            if(this.oppty.Send_thank_you_note__c)
            {
                Task objTask = new Task();
                objTask.OwnerId = Userinfo.getUserId();
                objTask.ActivityDate = date.today().addDays(7);
                objTask.Subject = 'Send thank you note for won opportunity - '+this.oppty.Name;
                objTask.Description = 'Related to this opportunity: '+strdomain+ApexPages.currentPage().getParameters().get('id');
                objTask.IsReminderSet = true;
                objTask.ReminderDateTime = datetime.now().addYears(1);// Satarupa Roy - 1 year reminder from now as told by Dave on 21st March 2013 as part of post- go live support. 
                objTask.whatId = this.oppty.AccountId;
                lstTask.add(objTask);
            }
        }
        
        if(!lstTask.isEmpty())
           insert lstTask;
        return new Pagereference('/'+ApexPages.currentPage().getParameters().get('id'));
    }

    static testMethod void myUnitTestForOpportunityDetailOnCloseController()
    {
         Account objAccount = new Account();
         objAccount.Name = 'Test Account';
         insert objAccount;
         
         Opportunity objOppty = new Opportunity();
         objOppty.CloseDate = date.today();
         objOppty.Name = 'Test Opportunity';
         objOppty.StageName='Closed Won';
         objOppty.AccountId = objAccount.id;
         insert objOppty;
         
         System.currentPageReference().getParameters().put('Id', objOppty.Id);
         ApexPages.StandardController std = new ApexPages.StandardController(objOppty);
         OpportunityDetailOnCloseController objOpptyOnClose = new OpportunityDetailOnCloseController(std);
         
         objOppty.Win_Loss_Notes__c = 'Test Notes';
         objOppty.Win_Loss_Reason__c = 'Pricing';
         objOppty.Schedule_1_yr_anniversary_reminder_follo__c = true;
         objOppty.Send_thank_you_note__c = true;
         
         test.startTest();
         objOpptyOnClose.Save();
         test.stopTest();
    }
    
}