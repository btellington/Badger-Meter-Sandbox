trigger OpportunityTrigger on Opportunity (before insert, before update) {

   for (Opportunity o : Trigger.new) {
 
        // Has Owner chagned?
        if (o.Owner__c != o.OwnerId) {
            o.Owner__c = o.OwnerId;
        }
    } 
}