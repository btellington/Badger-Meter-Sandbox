public with sharing class RepSearchController {

  // the soql without the order and limit
  private String soql {get;set;}
  
  public String strCountry{get;set;}
  public String StrZip{get;set;}
  public String strBrand{get;set;}
  public List<String> lstIndustry{get;set;}
  public boolean blnRent{get;set;}
  //List binded to the page
  public List<Rep__c> lstPageRep {get;set;}
  ///** Following List of Lists takes care of storing the Pages of specified page size **/
  public List<List<Rep__c>> lstOflstOfAllRep;
  /** Counter used for displaying the records on load & also for previous/next pages **/
  public Integer counterLst = 0;
  public Integer pageSize = 100;
  
  public boolean showTable{get;set;}
  // the collection of contacts to display
  public List<Rep__c> lstRep {get;set;}

  // init the controller and display some sample data when the page loads
  public RepSearchController(ApexPages.StandardController ctlr) {
    
    strCountry = '';
    StrZip = '';
    strBrand = '';
    lstIndustry = new List<String>();
    showTable = false;
    lstPageRep = new List<Rep__c>();
    lstOflstOfAllRep = new List<List<Rep__c>>();
    lstRep = new List<Rep__c>();
  }
 
 
  // runs the actual query
  public void runQuery() {
 
    try {
        pageNumber = 1;
        lstPageRep = new List<Rep__c>();
        lstRep = new List<Rep__c>();
        List<string> ListOfValues1 = new List<string>();
        Set<String> setOfValues = new Set<String>();
        List<Rep__c> lstRecordsPerPage = new List<Rep__c>();
        lstOflstOfAllRep = new List<List<Rep__c>>();
        Integer trackCount = 0;
        lstRep = Database.query(soql);
        List<Rep__c>lstRepFinal = new List<Rep__c>();
        
        if(!strZip.equals(''))
        {
	        for(Rep__c objRep : lstRep)
	        {
	        	if(objRep.Territory_Coverage__c!=null)
	        	{
	        		String str;
	        		system.debug('======objRep.Territory_Coverage__c========'+objRep.Territory_Coverage__c);
	        		if(objRep.Territory_Coverage__c.contains(',') || objRep.Territory_Coverage__c.contains('\''))
	        		{
	        		     str = objRep.Territory_Coverage__c.replaceAll('[,\\s]', ',');
	        		     ListOfValues1 = str.split(',');
	        		}
	        		else
	        		{
	        			ListOfValues1.add(objRep.Territory_Coverage__c);
	        		}
	        		
	        		for(integer j=0;j<ListOfValues1.size();j++)
	        		{
	        			if(ListOfValues1[j]!=null && ListOfValues1[j].startsWith(strZip))
	        			    lstRepFinal.add(objRep);   
	        			    break;
	        		}
	        	}
	        	
	        }
	        
        }
        else
        {
        	lstRepFinal.addAll(lstRep);
        }
        if(!lstRepFinal.isEmpty())
        {
	        for(Rep__c objRep : lstRepFinal)
			{
				if(trackCount<pageSize)
				{
				    lstRecordsPerPage.add(objRep);
				    trackCount++;
				}
				else
				{
					/** Adding the records in form of pages of size 100 **/
					lstOflstOfAllRep.add(lstRecordsPerPage);
					/** Resetting the vars **/
					trackCount = 0;
					lstRecordsPerPage = new List<Rep__c>();
					/** Adding the object in current iteration **/
					lstRecordsPerPage.add(objRep);
					trackCount++;
				}
			}
	      if(!lstRecordsPerPage.isEmpty())
	        lstOflstOfAllRep.add(lstRecordsPerPage);
	        lstPageRep.addAll(lstOflstOfAllRep[counterLst]);
	        TotpageSize = lstPageRep.size();
	        showTable = true;
        }
    } 
      catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please refine your search criteria!'));
    }
 
  }
 
  public Integer pageNumber{get;set;}
  public Integer TotpageSize{get;set;}
  // runs the search 
  public PageReference runSearch() {
 
    String industry = '';
    String strZipFinal = '';
    String sw = '';
    
    List<string> lstOfValues = new List<string>();
    try {
    	
    	if(!strZip.equals(''))
    	{
    		sw = strZip.replaceAll('[,\\s]', ','); // replacing all spaces or commas in the string with only comma
    		
    		lstOfValues = sw.split(',');
    	}

	    if(!lstIndustry.isEmpty())
	    {
		     for(String s: lstIndustry)
		     {  
			        industry += '\'' +s + '\',';
		     }
		     industry = industry.substring (0,industry.length() -1);
	    }

	    soql = 'Select Sales_Channel_Partner__r.Name,Key_Contact__c, Territory_Coverage__c, Sales_Channel_Partner__c, Sales_Channel_Partner__r.Industry__c, WWW__c, Phone__c, Notes__c, Name, Authorized_Products__c, Industry__c, Fax__c, Email__c, Division__c, Company_Name__c, Address_line_1__c, Address_line_2__c From Rep__c r WHERE Key_Contact__c = TRUE ';
	    
	    if (strCountry!=null)
	      soql += ' and Mailing_Country__c = \''+String.escapeSingleQuotes(strCountry)+'\'';
	    
	   /* if (!lstOfValues.isEmpty())
	    {
	      
		      soql += ' and (';
		      
		      for(integer i = 0;i<lstOfValues.size();i++)
		      {
			      	if(lstOfValues[i]!='')
			      	{
		               soql += ' Territory_Coverage__c in \''+lstOfValues[i]+'%\'';
		            
			            if(i<lstOfValues.size() - 1)
			            {
			            	soql += ' or ';
			            }
			      	}	
		      }
		      soql += ' )';
	    }*/
	    
	    if (strBrand!=null)
	      soql += ' and Brand__c = \''+String.escapeSingleQuotes(strBrand)+'\'';  
	    
	    if (!lstIndustry.isEmpty())
	      soql += ' and Sales_Channel_Partner__r.Industry__c includes ('+industry+')';
	      
	      soql += ' and Rental_House_Only__c = '+blnRent;
	    system.debug('====soql=========='+soql);
	    // run the query again
	    runQuery();
    }
    catch(Exception e)
    {
    	
    }
   
    return null;
  }
  
  // use apex describe to build the picklist values
  public List<SelectOption> Industries {
    get {
      if (Industries == null) {
 
        Industries = new List<SelectOption>();
        Schema.DescribeFieldResult field = Sales_Channel_Partner__c.Industry__c.getDescribe();  
        for (Schema.PicklistEntry f : field.getPicklistValues())
          Industries.add(new SelectOption(f.getLabel(),f.getValue()));
 
      }
      return Industries;          
    }
    set;
  }
  
  public List<SelectOption> Country {
    get {
      if (Country == null) {
 
        Country = new List<SelectOption>();
        Country.add(new SelectOption('','-None-'));
        Schema.DescribeFieldResult field = Rep__c.Mailing_Country__c.getDescribe();  
        for (Schema.PicklistEntry f : field.getPicklistValues())
          Country.add(new SelectOption(f.getLabel(),f.getValue()));
 
      }
      return Country;          
    }
    set;
  }
  
  public List<SelectOption> Brand {
    get {
      if (Brand == null) {
 
        Brand = new List<SelectOption>();
        Brand.add(new SelectOption('','-None-'));
        Schema.DescribeFieldResult field = Rep__c.Brand__c.getDescribe();  
        for (Schema.PicklistEntry f : field.getPicklistValues())
          Brand.add(new SelectOption(f.getLabel(),f.getValue()));
      }
      return Brand;          
    }
    set;
  }
  
  
  public void prevActn()
  {
	if(counterLst > 0)
	{
	   counterLst--;
	   pageNumber--;
	   lstPageRep = new List<Rep__c>();
	   lstPageRep.addAll(lstOflstOfAllRep[counterLst]);
	}
  }

 public void nextActn()
 {
	  if(counterLst < lstOflstOfAllRep.size()-1)
	  {
	  	pageNumber++;
	  	counterLst++;
	    lstPageRep = new List<Rep__c>();
        lstPageRep.addAll(lstOflstOfAllRep[counterLst]);
	  }
 }

  
  //Test Class
  static testMethod void myUnitTestForRepSearchController()
  {
       	   
  	  Sales_Channel_Partner__c objSalesChPartner = new Sales_Channel_Partner__c();
  	  objSalesChPartner.Name  = 'Test Partner';
  	  objSalesChPartner.Industry__c = 'General Industrial';
  	  objSalesChPartner.Sales_Credit_Number__c = '123';
  	  insert objSalesChPartner;
  	  
  	  Rep__c objrep = new Rep__c();
      objrep.Name = 'Test Rep';
      objrep.Sales_Channel_Partner__c = objSalesChPartner.id;
      insert objrep;      
	  
	  //System.currentPageReference().getParameters().put('id', objrep.Id);
      ApexPages.StandardController std = new ApexPages.StandardController(objRep);
      RepSearchController objserchrep = new RepSearchController(std);
      
      test.startTest();
      objserchrep.Brand.add(new SelectOption('Blancett','Blancett'));
      objserchrep.Country.add(new SelectOption('USA','USA'));
      objserchrep.Industries.add(new SelectOption('General Industrial','General Industrial'));
      
      objserchrep.runSearch();
      
      system.assertEquals(objserchrep.lstRep.size(),0);
      
      objrep.Mailing_Country__c = 'USA';
      objRep.Territory_Coverage__c = '02213,02214';
      objrep.Brand__c = 'Blancett';
      objrep.Rental_House_Only__c = false;
      objrep.Key_Contact__c = TRUE; 
      update objrep;
      
      Rep__c objrep1 = new Rep__c();
      objrep1.Name = 'Test Rep1';
      objrep1.Sales_Channel_Partner__c = objSalesChPartner.id;
      objrep1.Mailing_Country__c = 'USA';
      objRep1.Territory_Coverage__c = '02213';
      objrep1.Brand__c = 'Blancett';
      objrep1.Key_Contact__c = TRUE; 
      objrep1.Rental_House_Only__c = false;
      insert objrep1;  
      
      objserchrep.strCountry = 'USA';
      objserchrep.StrZip = '022';
      objserchrep.strBrand = 'Blancett';
      objserchrep.lstIndustry.add('General Industrial');
      objserchrep.blnRent = false;
 
      objserchrep.pageSize = 1;
      objserchrep.runSearch();
      system.assertEquals(objserchrep.lstPageRep.size(),1);
      objserchrep.nextActn();
      objserchrep.prevActn();
      test.stopTest();
   	  
  }
}