@isTest
public class LeadTriggerManagerTest {

    static Lead l1;
    
    public static void leadTestData (Id recordTypeId, String postalCode) {
        // create at least 5 data
        l1 = new Lead();
        l1.RecordTypeId = recordTypeId;
        l1.FirstName = 'John';
        l1.LastName = 'Doe';
        l1.Company = 'Acme';
        l1.Organization_Type__c = 'Instrumentation Customer (IC)';
        l1.Status = 'Qualified';
        l1.Rating = 'Hot';
        l1.Product__c = 'Concrete Fluid Products';
        l1.Country = '';
        l1.State = '';
        l1.PostalCode = postalCode;
        
    }
    
    public static void geoDataMapTestData (){
        // Flow Record Type
        Geo_Data_Map__c g1 = new Geo_Data_Map__c();
        g1.Zip_Code__c = '56744';
        g1.City__c = 'Oslo';
        g1.County__c = 'Marshall';
        g1.State__c = 'Minnesota';
        g1.ST__c = 'MN';
        g1.Zip3__c = '567';
        g1.Flow_Territory__c = 'Midwest';
        g1.Flow_Regional_Sales_Manager__c = 'Tim Wissing';
        g1.Uterritory_2__c = 'MN1';
        g1.UAccount_Manager__c = 'Mike McNabb';
        g1.Uterritory_Name__c = 'Central';
        insert g1;
        
        Geo_Data_Map__c g2 = new Geo_Data_Map__c();
        g2.Zip_Code__c = '50001';
        g2.City__c = 'Ackworth';
        g2.County__c = 'Warren';
        g2.State__c = 'Iowa';
        g2.ST__c = 'IA';
        g2.Zip3__c = '500';
        g2.Flow_Territory__c = 'Central';
        g2.Flow_Regional_Sales_Manager__c = 'TBD';
        g2.Uterritory_2__c = 'IA1';
        g2.UAccount_Manager__c = 'Mike McNabb';
        g2.Uterritory_Name__c = 'Central';
        insert g2;
        
        Geo_Data_Map__c g3 = new Geo_Data_Map__c();
        g3.Zip_Code__c = '01002';
        g3.City__c = 'Amherst';
        g3.County__c = 'Hampshire';
        g3.State__c = 'Massachusetts';
        g3.ST__c = 'MA';
        g3.Zip3__c = '010';
        g3.Flow_Territory__c = 'Northeast';
        g3.Flow_Regional_Sales_Manager__c = 'Kevin Mahaffey';
        g3.Uterritory_2__c = 'MA1';
        g3.UAccount_Manager__c = 'Dan Johnson';
        g3.Uterritory_Name__c = 'East';
        insert g3;
        
        Geo_Data_Map__c g4 = new Geo_Data_Map__c();
        g4.Zip_Code__c = '27406';
        g4.City__c = 'Greensboro';
        g4.County__c = 'Guilford';
        g4.State__c = 'North Carolina';
        g4.ST__c = 'NC';
        g4.Zip3__c = '274';
        g4.Flow_Territory__c = 'Southeast';
        g4.Flow_Regional_Sales_Manager__c = 'Hixson Eldridge';
        g4.Uterritory_2__c = 'NC1';
        g4.UAccount_Manager__c = 'Craig Cardella';
        g4.Uterritory_Name__c = 'East';
        insert g4;
        
        // Utility Record Type
        Geo_Data_Map__c g5 = new Geo_Data_Map__c();
        g5.Zip_Code__c = '50430';
        g5.City__c = 'Corwith';
        g5.County__c = 'Hancock';
        g5.State__c = 'Iowa';
        g5.ST__c = 'IA';
        g5.Zip3__c = '504';
        g5.Flow_Territory__c = 'Central';
        g5.Flow_Regional_Sales_Manager__c = 'TBD';
        g5.Uterritory_2__c = 'IA1';
        g5.UAccount_Manager__c = 'Mike McNabb';
        g5.Uterritory_Name__c = 'Central';
        insert g5;
        
    }
    
    // add testmethod for before update too?
     public static testmethod void testTerritoryNameUpdateFlowRecord(){
         // add data to GDM Data Map
         geoDataMapTestData();
         
         Test.startTest();
         List<RecordType> recordTypes = [Select Name, Id from RecordType where SObjectType = 'Lead' AND Name like 'Flow%'];
         System.assertEquals(1, recordTypes.size());
         leadTestData(recordTypes.get(0).Id, '56744');
         
         Database.SaveResult resultL1 = Database.insert(l1);
         Test.stopTest();
         
         // asserts here
         System.assert(resultL1.isSuccess());
         
         List<Lead> leadList = [Select id, Territory_Name_2__c from Lead where id=:resultL1.getId()];
         System.assertEquals('Midwest', leadList.get(0).Territory_Name_2__c);
     }
     
    /*
     public static testmethod void testTerritoryNameUpdateUtilityRecord(){
         // testdata here
         leadTestData('Utility', '');
     }
	*/
     
}