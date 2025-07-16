<cfif session.loggedIn>
    <cfset location("dashboard.cfm", true)>
</cfif>

<cfinclude template="includes/header.cfm">

    <h3>User Registration</h3>
    <form id="regForm" enctype="multipart/form-data">
        <div class="mb-3">
            <label>Name</label>
            <input type="text" name="name" class="form-control" required />
        </div>
        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" id="email" class="form-control" required />
            <span id="emailCheck" class="form-text"></span>
        </div>
        <div class="mb-3">
            <label>Password</label>
            <input type="password" name="password" class="form-control" required />
        </div>
        <div class="mb-3">
            <label>Profile Image</label>
            <input type="file" name="profileImage" class="form-control" accept="image/*" required />
        </div>
        <button type="submit" class="btn btn-primary" id="submitBtn" disabled>Register</button>
    </form>

    <div id="result" class="mt-3"></div>

    <script>
        const regForm = document.querySelector("#regForm");
        const emailInput = document.querySelector("#email");
        const nameInput = document.querySelector("input[name='name']");
        const passInput = document.querySelector("input[name='password']");
        const imageInput = document.querySelector("input[name='profileImage']");
        const resultSpan = document.getElementById("emailCheck");
        const submitBtn = document.querySelector("#submitBtn");
        let emailValid = false;

        function validateForm() {
            const name = nameInput.value.trim();
            const email = emailInput.value.trim();
            const password = passInput.value.trim();
            const image = imageInput.files.length > 0;

            const allFilled = name && email && password && image;

            // Enable only if all filled and email is valid
            submitBtn.disabled = !(allFilled && emailValid);
        }

        emailInput.addEventListener("blur", function () {
            const email = this.value.trim();

            if (email.length > 5) {
                fetch("ajax/checkEmail.cfm", {
                    method: "POST",
                    body: new URLSearchParams({ email })
                })
                .then(res => res.text())
                .then(data => {
                    data = data.trim(); // 🔥 This fixes it
                    console.log("Email check response:", data);

                    if (data === "taken") {
                        resultSpan.innerText = "Email already registered";
                        resultSpan.style.color = "red";
                        emailValid = false;
                    } else if (data === "available") {
                        resultSpan.innerText = "Email available";
                        resultSpan.style.color = "green";
                        emailValid = true;
                    } else {
                        resultSpan.innerText = "Invalid email";
                        resultSpan.style.color = "orange";
                        emailValid = false;
                    }
                    validateForm(); // re-validate after check
                });
            } else {
                resultSpan.innerText = "";
                emailValid = false;
                validateForm();
            }
        });

        // Listen to input on all fields to update button state
        [nameInput, passInput, emailInput].forEach(input => {
            input.addEventListener("input", validateForm);
        });
        imageInput.addEventListener("change", validateForm);

        regForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const formData = new FormData(this);

            fetch("ajax/registerCheck.cfm", {
                method: "POST",
                body: formData
            })
            .then(res => res.text())
            .then(data => {
                document.getElementById("result").innerHTML = data;
                regForm.reset();
                resultSpan.innerText = "";
                emailValid = false;
                submitBtn.disabled = true; // disable again after submit
                if (data.includes("registered")) {
                    setTimeout(() => window.location.href = "dashboard.cfm", 1000);
                }
            })
            .catch(err => {
                document.getElementById("result").innerHTML = "Error: " + err;
            });
        });
    </script>


<cfinclude template="includes/footer.cfm">
