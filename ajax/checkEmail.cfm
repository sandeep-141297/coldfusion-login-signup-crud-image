<cfsetting showdebugoutput="false">
<cfcontent type="text/plain">
<cfscript>
    email = trim(form.email ?: "");

    if (len(email)) {
        result = queryExecute("
            SELECT COUNT(*) AS total FROM persons WHERE email = :email
        ", {
            email: { value: email, cfsqltype: "cf_sql_varchar" }
        }, { datasource = application.datasource });

        if (result.total > 0) {
            writeOutput("taken");
        } else {
            writeOutput("available");
        }
    } else {
        writeOutput("invalid");
    }
</cfscript>
