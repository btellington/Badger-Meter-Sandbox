<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Set_Owner_to_Director_of_Sales</fullName>
        <field>OwnerId</field>
        <lookupValue>kstoll@badgermeter.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account Set Owner to Director of Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Owner for Integrated Accounts</fullName>
        <actions>
            <name>Account_Set_Owner_to_Director_of_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>End User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Owner__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
