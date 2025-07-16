<cfoutput>
    <!DOCTYPE html>
    <html>
    <head>
        <title>User App</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.bootstrap5.min.css" />
    </head>
    <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.cfm">Coldfusion Login Signup CRUD App</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <cfif NOT structKeyExists(session, "loggedIn") OR NOT session.loggedIn>
                        <li class="nav-item"><a class="nav-link" href="register.cfm">Register</a></li>
                        <li class="nav-item"><a class="nav-link" href="login.cfm">Login</a></li>
                    <cfelse>
                        <li class="nav-item"><a class="nav-link" href="dashboard.cfm">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link text-warning" href="logout.cfm">Logout</a></li>
                    </cfif>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
</cfoutput>
