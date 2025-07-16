<cfscript>
    // Destroy session
    sessionInvalidate();

    // Optional: clear client/session vars just in case
    structClear(session);

    // Redirect to login
    location("login.cfm", true);
</cfscript>
