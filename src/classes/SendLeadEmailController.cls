public class SendLeadEmailController {     
    public boolean displayPopup {get; set;}     
    public String Leadid{get;set;}
    public Apexpages.StandardController controller; 
    private PageReference page; 
    public Lead objLead;
    public String strSender{get;set;}
    public String strEmail{get;set;}
    public boolean addEmailPopup{get;set;}
    //ADDED VARIABLES NOV 13 2013
    public String searchString{get;set;}
    public List<conWrapper> conList{get;set;}
    public List<conWrapper> conListSelected{get;set;}
    public boolean isMessage{get;set;}
    public String ErrorMsg{get;set;}
    public boolean tblRender{get;set;}
    public boolean mEmailRender{get;set;}
    public Set<Id> conIds{get;set;}
    public boolean manualPopup{get;set;}
    public List<String> strEmailsplitted{get;set;}
    public boolean strEmailTable{get;set;}
    public String campName{get;set;}
    public Id curLeadId;
    
    public SendLeadEmailController(ApexPages.StandardController controller)
    {
        strEmail = '';
        this.controller = controller;
        displayPopup = true;
        this.objLead = (Lead)controller.getrecord();    
        this.page = ApexPages.currentPage();
        strSender = UserInfo.getName();
        this.Leadid = page.getParameters().get('id');  
        conListSelected = new List<conWrapper>();
        strEmailsplitted = new List<String>();
        conIds = new Set<Id>();
        mEmailRender = false;
        strEmailTable = false;
        curLeadId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));
        getCampaignName(curLeadId);
    }
    
    public String getCampaignName(Id leadRecId){
        List<CampaignMember> campMemberList = new List<CampaignMember>();
        for(CampaignMember cm:[Select Id,CampaignId FROM CampaignMember WHERE LeadId =:leadRecId ORDER BY CreatedDate DESC LIMIT 1]){
            campMemberList.add(cm);
        }
        if(!campMemberList.isEmpty()){
            Campaign camp = [Select Id,Name from Campaign WHERE Id=:campMemberList[0].CampaignId];
            campName = camp.Name;
        }
        return campName;
    }
    
    public void searchBtn(){    
        conList = new List<conWrapper>();
        String finalSearchValue = '%'+searchString+'%';
        
            for(Contact c:[Select Id,Name,Email from Contact WHERE Name Like:finalSearchValue AND Id NOT IN:conIds LIMIT 200]){
                conWrapper cWrap = new conWrapper();
                cWrap.con = c;
                cWrap.isChecked = false;
                conList.add(cWrap);
            }
            if(conList.size()<1){
                tblRender = false;
                isMessage = true;
                ErrorMsg = 'Search Returned 0 results';
            }else{
                tblRender = true;
                isMessage = false;
                ErrorMsg = '';
            }
    }
    
    public void removeFromList(){
        List<conWrapper> tempList = new List<conWrapper>();
        for(conWrapper cw:conListSelected){
            if(cw.isChecked==false){
                tempList.add(cw);
            }
            if(cw.isChecked==true){
                conIds.remove(cw.con.Id);
            }
        }
        conListSelected.clear();
        conListSelected.addAll(tempList);
        if(conListSelected.isEmpty()){
            mEmailRender = false;   
        }
    }
    
    public void addManualAddress(){
        if(strEmail.trim()!=''){
            strEmailsplitted = strEmail.split(';');
        }else{
            strEmailsplitted.clear();
        }
        manualPopup = false;
        if(strEmailsplitted==null){
            strEmailTable = false;
        }else{
            strEmailTable = true;
        }
        
    }
    
    public void saveConList(){
        for(conWrapper cWrp:conList){
            if(cWrp.isChecked==true){
                    conWrapper conW = new conWrapper();
                    conW.con = cWrp.con;
                    conIds.add(cWrp.con.Id);
                    conW.isChecked = false;
                    conListSelected.add(conW);
            }
        }
        addEmailPopup = false;
        tblRender = false;
        if(conListSelected!=null){
            mEmailRender = true;
        }else{
            mEmailRender = false;
        }
    }
    
    public void showEmailPopup(){
        conList = new List<conWrapper>();    
        addEmailPopup = true;
        
    }
    public void closeEmailPopup(){        
        addEmailPopup = false;
    }
    
    public void showManualPopup(){
        manualPopup = true;
    }
    
     public void hideManualPopup(){
        manualPopup = false;
    }
         
    public PageReference sendMassEmail(){
        String productLine = this.objLead.Product__c;
        String appOfInterest = this.objLead.Applications_Of__c;
        List<String> prodLineList = new List<String>();
        List<String> appOfInterestList = new List<String>();
        //Process Product Line to show Product with html line breaks instead of only one line(example:product1;product2) 
        if(this.objLead.Product__c!=null){
            prodLineList = productLine.split(';');
            productLine = '';
            for(String pL:prodLineList){
                //add html line break tag to the string
                productLine += pL + '<br>';
            }
        }
        if(this.objLead.Applications_Of__c!=null){
            appOfInterestList = appOfInterest.split(';');
            appOfInterest = '';
            for(String aOI:appOfInterestList){
                //add html line break tag to the string
                appOfInterest += aOI + '<br>';
            }
        }
        if(!strEmailsplitted.isEmpty()||!conListSelected.isEmpty()){
            try{
                if(!strEmailsplitted.isEmpty()){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                                                         
                        mail.setToAddresses(strEmailsplitted);
                        mail.setReplyTo('noreply@salesforce.com');
                        mail.setSenderDisplayName(strSender);
                        mail.setSubject('Lead Information for :'+this.objLead.Name);
                        mail.setHtmlBody('Hello,<br><br> I wanted to provide you with details on a new lead I have received, that I think you would be interested in. The details are:<br><br><table border="0" bordercolor="" style="background-color:" width="100%" cellpadding="3" cellspacing="1"><tr><td width="15%">Name:</td><td width="85%">'+(this.objLead.Name!=null?this.objLead.Name:'')+'</td></tr><tr><td>Company:</td><td>'+(this.objLead.Company!=null?this.objLead.Company:'')+'</td></tr><tr><td>Title:</td><td>'+(this.objLead.Title!=null?this.objLead.Title:'')+'</td></tr><tr><td>Address:</td><td>'+(this.objLead.Street!=null?this.objLead.Street:'')+', '+(this.objLead.City!=null?this.objLead.City:'')+' '+(this.objLead.State!=null?this.objLead.State:'')+' '+(this.objLead.PostalCode!=null?this.objLead.PostalCode:'')+' '+(this.objLead.Country!=null?this.objLead.Country:'')+'</td></tr><tr><td>Phone:</td><td>'+(this.objLead.Phone!=null?this.objLead.Phone:'')+'</td></tr><tr><td>Email:</td><td>'+(this.objLead.Email!=null?this.objLead.Email:'')+'</td></tr><tr><td>Website:</td><td>'+(this.objLead.Website!=null?this.objLead.Website:'')+'</td></tr><tr><td>Campaign:</td><td>'+ (campName!=null?campName:'') +'</td></tr><tr><td>Source:</td><td>'+(this.objLead.LeadSource!=null?this.objLead.LeadSource:'')+'</td></tr><tr><td>Industry:</td><td>'+(this.objLead.Industry!=null?this.objLead.Industry:'')+'</td></tr><tr><td valign="top">Product Lines of Interest:</td><td>'+(productLine!=null?productLine:'')+'</td></tr><tr valign="top"><td>Applications of Interest:</td><td>'+(appOfInterest!=null?appOfInterest:'')+'</td></tr><tr><td>Purchase Timeframe:</td><td>'+(this.objLead.Purchase_Timeframe__c!=null?this.objLead.Purchase_Timeframe__c:'')+'</td></tr><tr><td>Description/Notes</td><td>'+(this.objLead.Description!=null?this.objLead.Description:'')+'</td></tr></table><br><br>Regards<br>'+strSender);
                        System.debug('\n\nMAIL BTNSEND : ' + mail + '\n\n');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        
                }
                if(!conListSelected.isEmpty()){
                    for(conWrapper c:conListSelected){
                            Messaging.Singleemailmessage sEmail = new Messaging.Singleemailmessage();
                            sEmail.setReplyTo('noreply@salesforce.com');
                            sEmail.setSenderDisplayName(strSender);
                            sEmail.setSubject('Lead Information for :'+this.objLead.Name);
                            sEmail.setHtmlBody('Hello,<br><br> I wanted to provide you with details on a new lead I have received, that I think you would be interested in. The details are:<br><br><table border="0" bordercolor="" style="background-color:" width="100%" cellpadding="3" cellspacing="1"><tr><td width="15%">Name:</td><td width="85%">'+(this.objLead.Name!=null?this.objLead.Name:'')+'</td></tr><tr><td>Company:</td><td>'+(this.objLead.Company!=null?this.objLead.Company:'')+'</td></tr><tr><td>Title:</td><td>'+(this.objLead.Title!=null?this.objLead.Title:'')+'</td></tr><tr><td>Address:</td><td>'+(this.objLead.Street!=null?this.objLead.Street:'')+', '+(this.objLead.City!=null?this.objLead.City:'')+' '+(this.objLead.State!=null?this.objLead.State:'')+' '+(this.objLead.PostalCode!=null?this.objLead.PostalCode:'')+' '+(this.objLead.Country!=null?this.objLead.Country:'')+'</td></tr><tr><td>Phone:</td><td>'+(this.objLead.Phone!=null?this.objLead.Phone:'')+'</td></tr><tr><td>Email:</td><td>'+(this.objLead.Email!=null?this.objLead.Email:'')+'</td></tr><tr><td>Website:</td><td>'+(this.objLead.Website!=null?this.objLead.Website:'')+'</td></tr><tr><td>Campaign:</td><td>'+ (campName!=null?campName:'') +'</td></tr><tr><td>Source:</td><td>'+(this.objLead.LeadSource!=null?this.objLead.LeadSource:'')+'</td></tr><tr><td>Industry:</td><td>'+(this.objLead.Industry!=null?this.objLead.Industry:'')+'</td></tr><tr><td valign="top">Product Lines of Interest:</td><td>'+(productLine!=null?productLine:'')+'</td></tr><tr valign="top"><td>Applications of Interest:</td><td>'+(appOfInterest!=null?appOfInterest:'')+'</td></tr><tr><td>Purchase Timeframe:</td><td>'+(this.objLead.Purchase_Timeframe__c!=null?this.objLead.Purchase_Timeframe__c:'')+'</td></tr><tr><td>Description/Notes</td><td>'+(this.objLead.Description!=null?this.objLead.Description:'')+'</td></tr></table><br><br>Regards<br>'+strSender);
                            sEmail.setTargetObjectId(c.con.Id);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sEmail });
                    }
                    conListSelected.clear();    
                }
                return new Pagereference('/'+LeadId);
            }catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'One or more Email Addresses are invalid, please correct before continuing');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Please add a Contact or an Email Address');
            ApexPages.addMessage(myMsg);
            return null;
        }
            
    }
    //Contact LIST Wrapper for Checkboxes
    public class conWrapper{
        public Contact con{get;set;}
        public Boolean isChecked{get;set;}
    
    }

    
  }