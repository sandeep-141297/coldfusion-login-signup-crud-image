<cfsetting showdebugoutput="false">
<cfcontent type="text/plain">
<cfscript>
    email = trim(form.email ?: "");
    currentID = trim(form.currentID ?: ""); // Optional ID passed during update

    if (len(email)) {
        sql = "
            SELECT COUNT(*) AS total
            FROM persons
            WHERE email = :email
        ";

        params = {
            email: { value: email, cfsqltype: "cf_sql_varchar" }
        };

        // If currentID provided, exclude that ID from the check
        if (len(currentID)) {
            sql &= " AND id != :id";
            params.id = { value: currentID, cfsqltype: "cf_sql_integer" };
        }

        result = queryExecute(sql, params, { datasource = application.datasource });

        if (result.total > 0) {
            writeOutput("taken");
        } else {
            writeOutput("available");
        }
    } else {
        writeOutput("invalid");
    }
</cfscript>
