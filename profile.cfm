<cfif NOT structKeyExists(session, "loggedIn") OR NOT session.loggedIn>
    <cfset location("login.cfm", true)>
</cfif>

<cfinclude template="includes/header.cfm">

<h3>My Profile</h3>

<cfquery name="userInfo" datasource="#application.datasource#">
    SELECT id, name, email, profile_image
    FROM persons
    WHERE id = <cfqueryparam value="#session.userID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput query="userInfo">
    <form id="profileForm" enctype="multipart/form-data">
        <input type="hidden" name="id" value="#id#">

        <div class="mb-2">
            <label>Name</label>
            <input type="text" name="name" class="form-control" value="#name#" disabled required>
        </div>
        <div class="mb-2">
            <label>Email</label>
            <input type="email" name="email" class="form-control" id="email" value="#email#" disabled required>
            <span id="emailCheck" class="form-text"></span>
        </div>
        <div class="mb-2">
            <label>Profile Image</label><br>
            <img id="profilePreview" src="uploads/#profile_image#" width="100" class="rounded mb-2">
            <input type="file" name="profileImage" class="form-control" accept="image/*" disabled>
        </div>

        <div class="d-flex gap-2">
            <button type="button" id="editBtn" class="btn btn-primary">Edit</button>
            <button type="submit" id="updateBtn" class="btn btn-success" disabled>Update</button>
        </div>
    </form>

    <div id="updateResult" class="mt-3"></div>
</cfoutput>

<script>
    const form = document.getElementById("profileForm");
    const inputs = form.querySelectorAll("input");
    const editBtn = document.getElementById("editBtn");
    const updateBtn = document.getElementById("updateBtn");
    const emailInput = document.querySelector("#email");

    const emailCheck = document.getElementById("emailCheck");
    let emailValid = true; // start true assuming same email

    emailInput.addEventListener("blur", function () {
        const email = this.value.trim();

        if (email.length > 5) {
            fetch("ajax/checkEmail.cfm", {
                method: "POST",
                body: new URLSearchParams({ email, currentID: form.id.value }) // pass current user ID
            })
            .then(res => res.text())
            .then(data => {
                data = data.trim();
                if (data === "taken") {
                    emailCheck.innerText = "Email already in use";
                    emailCheck.style.color = "red";
                    emailValid = false;
                } else if (data === "available") {
                    emailCheck.innerText = "Email available";
                    emailCheck.style.color = "green";
                    emailValid = true;
                } else {
                    emailCheck.innerText = "Invalid email";
                    emailCheck.style.color = "orange";
                    emailValid = false;
                }
            });
        } else {
            emailCheck.innerText = "";
            emailValid = false;
        }
    });


    editBtn.addEventListener("click", () => {
        inputs.forEach(input => input.disabled = false);
        updateBtn.disabled = false;
        editBtn.disabled = true;
    });

    form.addEventListener("submit", function(e){
        e.preventDefault();

        if (!emailValid) {
            emailCheck.innerText = "Please use a valid, available email";
            return;
        }

        const formData = new FormData(this);

        fetch("ajax/updateProfile.cfm", {
            method: "POST",
            body: formData
        })
        .then(res => res.json()) // parse JSON
        .then(data => {
            console.log(data);
            document.getElementById("updateResult").innerHTML = `<div class="alert alert-${data.STATUS == 'success' ? 'success' : 'danger'}">${data.MESSAGE}</div>`;

            if (data.NEWIMAGE) {
                const profileImg = document.querySelector("#profilePreview");
                profileImg.setAttribute("src", `uploads/${data.NEWIMAGE}?t=${new Date().getTime()}`);
            }

            updateBtn.disabled = true;
            editBtn.disabled = false;
            inputs.forEach(input => input.disabled = true);
        });
    });
</script>

<cfinclude template="includes/footer.cfm">
