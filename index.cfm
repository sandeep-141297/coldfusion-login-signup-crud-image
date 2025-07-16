<cfif structKeyExists(session, "loggedIn") AND session.loggedIn>
    <cfset location("dashboard.cfm", true)>
<cfelse>
    <cfset location("login.cfm", true)>
</cfif>