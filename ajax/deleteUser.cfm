<cfsetting showdebugoutput="false">
<cfcontent type="text/html">

<cfif NOT structKeyExists(session, "loggedIn") OR NOT session.loggedIn>
    <cfoutput><div class="alert alert-danger">Unauthorized access.</div></cfoutput>
    <cfabort>
</cfif>

<cfscript>
    id = val(form.id ?: 0);

    if (id > 0) {
        // Get image name first to delete file
        result = queryExecute("
            SELECT profile_image FROM persons WHERE id = :id
        ", { id: { value: id, cfsqltype: "cf_sql_integer" } }, 
        { datasource = application.datasource });

        if (result.recordCount) {
            imageFile = expandPath("../uploads/" & result.profile_image);
            if (fileExists(imageFile)) fileDelete(imageFile);
        }

        // Delete from DB
        queryExecute("DELETE FROM persons WHERE id = :id", {
            id: { value: id, cfsqltype: "cf_sql_integer" }
        }, { datasource = application.datasource });

        writeOutput('<div class="alert alert-success">User deleted.</div>');
    } else {
        writeOutput('<div class="alert alert-warning">Invalid user ID.</div>');
    }
</cfscript>
