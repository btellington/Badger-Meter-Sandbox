public class LeadTriggerManager {

    public static void updateTerritoryName (List<Lead> leadList) {
       
           String FlowId = '';

           List<String> ZipCodes = new List<String>();
           List<RecordType> rt = [SELECT Name, Id FROM RecordType WHERE SObjectType = 'Lead' AND Name like 'Flow%'];
           If (rt.size() > 0) { FlowId = rt[0].Id; }
           
            // add checker for correctness of zipcode
           for (Lead l : leadList) { //trigger.new
               if (l.PostalCode != null){ //l.State != null
                   ZipCodes.add(l.PostalCode); 
               } 
           }
           
           if (ZipCodes.size() > 0){
               Map<string, Geo_Data_Map__c> GDM_Map = new map<string, Geo_Data_Map__c>();
               for (Geo_Data_Map__c g :[SELECT Id, Zip_Code__c, Flow_Territory__c, Uterritory_2__c, Uterritory_Name__c
                                          FROM Geo_Data_Map__c
                                         WHERE Zip_Code__c in :ZipCodes]) {
                  GDM_Map.put(g.Zip_Code__c, g);
               }
               
               for (Lead ld : leadList) {
                   if(ld.PostalCode==null && ld.City != null && ld.State != null){
                       
                   } else if (ld.PostalCode != null && GDM_Map.containsKey(ld.PostalCode)){     // ld.State != ''
                      if (ld.RecordTypeId == FlowId) {
                          ld.Territory_Name_2__c = GDM_Map.get(ld.PostalCode).Flow_Territory__c;
                      } else {
                         ld.Uterritory2__c = GDM_Map.get(ld.PostalCode).Uterritory_2__c;
                         ld.UTerritory_Name__c = GDM_Map.get(ld.PostalCode).Uterritory_Name__c;
                      }
                   } else if (!GDM_Map.containsKey(ld.PostalCode)){ // if incorrect postalCode
                       ld.addError('Invalid Postal Code.');
                   } else {
                       // do nothing
                   }
               }
            } else { }
    }
    
}