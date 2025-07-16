<cfsetting showdebugoutput="false">
<cfcontent type="text/html">
<cfscript>
    utils = new "coldfusion-login-signup-crud-image.cfc.Utils"();

    email = trim(form.email ?: "");
    password = trim(form.password ?: "");

    if (len(email) && len(password)) {
        user = queryExecute("
            SELECT TOP 1 id, name, email, password
            FROM persons
            WHERE email = :email
        ", {
            email: { value: email, cfsqltype: "cf_sql_varchar" }
        }, { datasource = application.datasource });

        if (user.recordCount == 1 && utils.verifyPassword(password, user.password)) {
            session.loggedIn = true;
            session.userID = user.id;
            session.userName = user.name;
            session.email = user.email;

            writeOutput('<div class="alert alert-success">Login success! Redirecting...</div>');
        } else {
            writeOutput('<div class="alert alert-danger">Invalid email or password</div>');
        }
    } else {
        writeOutput('<div class="alert alert-warning">Please fill in both fields.</div>');
    }
</cfscript>
