trigger AccountTrigger on Account (before insert, before update) {

    for (Account a : Trigger.new) {
 
        // Has Owner chagned?
        if (a.Owner__c != a.OwnerId) {
            a.Owner__c = a.OwnerId;
        }
    }

}