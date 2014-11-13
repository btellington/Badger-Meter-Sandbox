<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Acknowledgement_Email</fullName>
        <description>Acknowledgement Email</description>
        <protected>false</protected>
        <recipients>
            <field>Iinitiator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_for_the_Rep_Contract_Expiration_Date_New</template>
    </alerts>
    <alerts>
        <fullName>Rejection_of_Contract_Expiration_Date</fullName>
        <description>Rejection of Contract Expiration Date</description>
        <protected>false</protected>
        <recipients>
            <field>Iinitiator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Rejection_of_Contract_Expiration_Date_New</template>
    </alerts>
</Workflow>
