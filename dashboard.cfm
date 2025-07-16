<cfif NOT structKeyExists(session, "loggedIn") OR NOT session.loggedIn>
    <cfset location("login.cfm", true)>
</cfif>

<cfinclude template="includes/header.cfm">

<h3 class="mb-3">All Registered Users</h3>

<table id="usersTable" class="table table-striped table-bordered">
    <thead>
        <tr>
            <th>Image</th>
            <th>Name</th>
            <th>Email</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <cfquery name="allUsers" datasource="#application.datasource#">
            SELECT id, name, email, profile_image FROM persons ORDER BY id DESC
        </cfquery>

        <cfoutput query="allUsers">
            <tr id="userRow_#id#">
                <td><img src="uploads/#profile_image#" width="50" height="50" class="rounded-circle"></td>
                <td>
                    #name#
                    <cfif id EQ session.userID>
                        <a href="profile.cfm" class="badge bg-primary text-white text-decoration-none ms-2">Own</a>
                    </cfif>
                </td>
                <td>#email#</td>
                <td>
                    <cfif id EQ session.userID>
                        <button class="btn btn-sm btn-secondary" disabled>Delete</button>
                    <cfelse>
                        <button class="btn btn-sm btn-danger" onclick="deleteUser(#id#)">Delete</button>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
    </tbody>
</table>

<div id="deleteMsg"></div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        new DataTable("#usersTable");
    });

    function deleteUser(userId) {
        if (!confirm("Are you sure you want to delete this user?")) return;

        fetch("ajax/deleteUser.cfm", {
            method: "POST",
            body: new URLSearchParams({ id: userId })
        })
        .then(res => res.text())
        .then(data => {
            document.getElementById("deleteMsg").innerHTML = data;
            if (data.includes("deleted")) {
                document.getElementById("userRow_" + userId).remove();
            }
        });
    }
</script>

<cfinclude template="includes/footer.cfm">
