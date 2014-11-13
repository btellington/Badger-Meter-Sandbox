public class CallApprovalProcess {

    private Apexpages.StandardController controller; 
    private PageReference page; 
    public Rep__c objRep;
    private string id;
    public datetime mydate;
    public boolean showBlock{get;set;}
    public CallApprovalProcess(ApexPages.StandardController controller)
    {
    	this.controller = controller;
        this.objRep = (Rep__c)controller.getrecord();       
        this.page = ApexPages.currentPage();
        this.id = page.getParameters().get('id');   
        showBlock = true;
        mydate = [select Contract_Expiration_Date__c from Rep__c where id =:ApexPages.currentPage().getParameters().get('id')].Contract_Expiration_Date__c;
       
        if(mydate == null)
        {
	       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The Rep does not have a contract expiration date');
	       ApexPages.addMessage(myMsg);
	       showBlock = false;
        }
       
    }
    public pagereference btnSubmitApproval()
    {
        String strId = UserInfo.getUserId(); 
        
        if(mydate!=null)  
        {   
        	date condate ;
        	condate = date.newinstance(this.mydate.year(), this.mydate.month(), this.mydate.day());
        	Integer days = (date.today()).daysBetween(condate);
        	if(days >0 && days<=60)
        	{
	        	this.objRep.Iinitiator__c = strId; 
	            update this.objRep;
	            
	            Approval.ProcessResult result;
	            string mesaage;
	              
	            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest(); 
	            req.setObjectId(ApexPages.currentPage().getParameters().get('id'));
	            // submit the approval request for processing
	            result = Approval.process(req);     
	            return new Pagereference('/'+ApexPages.currentPage().getParameters().get('id'));               
        	}
        	else
        	{
        		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Your contract expiration date is not withing 60 days');
	            ApexPages.addMessage(myMsg);
	            return null;
        	}
        	return new Pagereference('/'+ApexPages.currentPage().getParameters().get('id'));	
        }
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Your contract expiration date has expired');
            ApexPages.addMessage(myMsg);
            return null;
        }                                                                      
	        
    }
    
    static testMethod void myUnitTestForCallApprovalProcess()
    {
    	Sales_Channel_Partner__c objSalesChPartner = new Sales_Channel_Partner__c();
        objSalesChPartner.Name  = 'Test Partner';
        objSalesChPartner.Sales_Credit_Number__c = '123'; 
        insert objSalesChPartner;
    	
    	Rep__c objRep = new Rep__c();
    	objRep.Name = 'Test Rep';
    	objRep.Sales_Channel_Partner__c = objSalesChPartner.id;
    	objRep.Contract_Expiration_Date__c = datetime.now().addDays(30);
    	insert objRep;
    	
    	System.currentPageReference().getParameters().put('id', objRep.Id);
        ApexPages.StandardController std = new ApexPages.StandardController(objRep);
        CallApprovalProcess objCallApprov = new CallApprovalProcess(std);
        
        test.startTest();
        objCallApprov.btnSubmitApproval();
        
        objRep.Contract_Expiration_Date__c = datetime.now().addDays(120);
        update objRep;
        
        objCallApprov.mydate = objRep.Contract_Expiration_Date__c;
        objCallApprov.btnSubmitApproval();
        
        objCallApprov.mydate = null;
        objCallApprov.btnSubmitApproval();
        
        Rep__c objRep1 = new Rep__c();
        objRep1.Name = 'Test Rep';
        objRep1.Sales_Channel_Partner__c = objSalesChPartner.id;
        insert objRep1;
        
        System.currentPageReference().getParameters().put('id', objRep1.Id);
        ApexPages.StandardController std1 = new ApexPages.StandardController(objRep1);
        CallApprovalProcess objCallApprov1 = new CallApprovalProcess(std1);
        
        test.stopTest();
        
        
    }
}