trigger LeadTrigger on Lead (before insert) {

   /* 
      This is a quick trigger written to support a demo.  
   
      When the Lead is inserted, the Zip Code will be retrieved.  This will be compared to the 
      Geo_Data_Map__c table, and the matching row retrieved.
      
      If the Lead Record Type is Flow, it will set the value of the Territory_Name_2__c field to the
      value of the Geo_Data_Map__c.Flow_Territory__c field.  Otherwise, the Lead.Uterritory2__c and 
      Lead.UTerritory_Name__c fields will be set to the Geo_Data_Map__c.Uterritory_2__c and 
      Geo_Data_Map__c.Uterritory_Name__c field values.
      
   */
   
   String FlowId = '';

   List<String> ZipCodes = new List<String>();
   List<RecordType> rt = [SELECT Name, Id FROM RecordType WHERE SObjectType = 'Lead' AND Name like 'Flow%'];
   If (rt.size() > 0) { FlowId = rt[0].Id; }
   
   for (Lead l : trigger.new) { ZipCodes.add(l.PostalCode); }
   
   map<string, Geo_Data_Map__c> GDM_Map = new map<string, Geo_Data_Map__c>();
   for (Geo_Data_Map__c g :[SELECT Id, Zip_Code__c, Flow_Territory__c, Uterritory_2__c, Uterritory_Name__c
                              FROM Geo_Data_Map__c
                             WHERE Zip_Code__c in :ZipCodes]) {
      GDM_Map.put(g.Zip_Code__c, g);
   }
   
   for (Lead ld : trigger.new) {
   	  if (ld.RecordTypeId == FlowId) {
   	     ld.Territory_Name_2__c = GDM_Map.get(ld.PostalCode).Flow_Territory__c;
   	  } else {
   	     ld.Uterritory2__c = GDM_Map.get(ld.PostalCode).Uterritory_2__c;
   	     ld.UTerritory_Name__c = GDM_Map.get(ld.PostalCode).Uterritory_Name__c;
   	  }
   }
   
}