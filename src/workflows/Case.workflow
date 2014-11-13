<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_date_field</fullName>
        <field>Date_Populated_when_stage_changes__c</field>
        <formula>NOW()</formula>
        <name>Populate date field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate date field when stage changes</fullName>
        <actions>
            <name>Populate_date_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Status )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
