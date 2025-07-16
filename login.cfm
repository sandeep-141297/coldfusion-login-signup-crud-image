<cfif session.loggedIn>
    <cfset location("dashboard.cfm", true)>
</cfif>

<cfinclude template="includes/header.cfm">

<h3>Login</h3>

<form id="loginForm">
    <div class="mb-3">
        <label>Email</label>
        <input type="email" name="email" class="form-control" required />
    </div>
    <div class="mb-3">
        <label>Password</label>
        <input type="password" name="password" class="form-control" required />
    </div>
    <button type="submit" class="btn btn-success">Login</button>
</form>

<div id="loginResult" class="mt-3"></div>

<script>
    document.querySelector("#loginForm").addEventListener("submit", function(e){
        e.preventDefault();

        const formData = new FormData(this);

        fetch("ajax/loginCheck.cfm", {
            method: "POST",
            body: formData
        })
        .then(res => res.text())
        .then(data => {
            document.getElementById("loginResult").innerHTML = data.trim();

            if (data.includes("success")) {
                setTimeout(() => window.location.href = "dashboard.cfm", 1000);
            }
        })
        .catch(err => {
            document.getElementById("loginResult").innerHTML = "Error: " + err;
        });
    });
</script>

<cfinclude template="includes/footer.cfm">
