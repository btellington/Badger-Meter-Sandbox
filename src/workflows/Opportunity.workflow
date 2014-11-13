<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_To_Badger_Meter_Sales</fullName>
        <description>Send Email To Badger Meter Sales</description>
        <protected>false</protected>
        <recipients>
            <field>Badger_Meter_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Create_Accounts</template>
    </alerts>
    <rules>
        <fullName>Send Email when stages is Closed Won</fullName>
        <actions>
            <name>Send_Email_To_Badger_Meter_Sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( 
OR( ISPICKVAL( Account.Owner__r.Region__c ,&apos;Scottsdale&apos;), ISPICKVAL(Owner__r.Region__c , &apos;Scottsdale&apos;) ), 
OR( (Account.Number_Of_Won_Opportunities__c ==0), ISNULL(Account.External_Id__c ) ), 
ISPICKVAL(StageName,&apos;Closed Won&apos;) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Send_Reminder</fullName>
        <assignedToType>creator</assignedToType>
        <description>To send 1 year anniversary reminder to calibrate product on the Opportunity being won.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.LastLoginDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Reminder</subject>
    </tasks>
    <tasks>
        <fullName>To_send_Thank_You</fullName>
        <assignedToType>creator</assignedToType>
        <description>To send thank you message as opportunity is won</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>To send Thank You</subject>
    </tasks>
</Workflow>
