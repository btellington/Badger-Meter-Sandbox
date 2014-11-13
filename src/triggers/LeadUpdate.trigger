trigger LeadUpdate on Lead (before update) {
    LeadTriggerManager.updateTerritoryName(trigger.new);
}