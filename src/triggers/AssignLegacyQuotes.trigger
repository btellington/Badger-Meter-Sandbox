trigger AssignLegacyQuotes on BigMachines__Quote__c (before insert) {
	List<Id> opptyIds = new List<Id>();
    List<Opportunity> parentOpptys = new List<Opportunity>();
    for(BigMachines__Quote__c q : Trigger.new)
    {
        opptyIds.add(q.BigMachines__Opportunity__c);    
    }
    
    parentOpptys = [Select Id, OwnerId from Opportunity where Id in :opptyIds];
    Map<Id,Opportunity> opptyMap = new Map<Id,Opportunity>();
    
    for(Opportunity o : parentOpptys)
    {
        opptyMap.put(o.Id,o);
    }
    
    for(BigMachines__Quote__c q : Trigger.new)
    {
        Opportunity parentOppty = opptyMap.get(q.BigMachines__Opportunity__c);
        if(parentOppty != null)
        {
            q.OwnerId = parentOppty.OwnerId;
        }
    }
}