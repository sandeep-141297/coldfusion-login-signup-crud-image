<cfscript>
    utils = new "coldfusion-login-signup-crud-image.cfc.Utils"();  

    name = trim(form.name ?: "");
    email = trim(form.email ?: "");
    password = trim(form.password ?: "");
    imageField = "profileImage";
    uploadPath = expandPath("../uploads/");

    if (len(email) && len(password) && structKeyExists(form, imageField)) {

        // Ensure upload folder exists
        if (!directoryExists(uploadPath)) {
            directoryCreate(uploadPath);
        }

        // Process Image Upload
        uploadedImage = fileUpload(
            destination = uploadPath,
            fileField = imageField,
            onConflict = "makeUnique",
            mimeType = "image/jpeg,image/png",
            strict = true
        );

        imageName = uploadedImage.serverFile; // get uploaded filename

        // Validate image size (max 2MB)
        if (uploadedImage.filesize > 2097152) {
            fileDelete(uploadPath & imageName);
            writeOutput('<div class="alert alert-danger">Image too large (max 2MB).</div>');
            abort;
        }

        hashedPass = utils.hashPassword(password);

        // Check if email already exists (SERVER-SIDE VALIDATION)
        checkEmail = queryExecute("
            SELECT COUNT(*) AS total FROM persons WHERE email = :email
        ", {
            email: { value: email, cfsqltype: "cf_sql_varchar" }
        }, { datasource = application.datasource });

        if (checkEmail.total > 0) {
            writeOutput('<div class="alert alert-danger">Email already exists. Try another one.</div>');
            abort;
        }

        try {
            queryExecute("
                INSERT INTO persons (name, email, password, profile_image)
                VALUES (:name, :email, :pass, :image)
            ", {
                name:   { value: name, cfsqltype: "cf_sql_varchar" },
                email:  { value: email, cfsqltype: "cf_sql_varchar" },
                pass:   { value: hashedPass, cfsqltype: "cf_sql_varchar" },
                image:  { value: imageName, cfsqltype: "cf_sql_varchar" }
            }, { datasource = application.datasource });

            writeOutput('<div class="alert alert-success">User registered with image!</div>');
        } catch (any e) {
            writeDump(e);
            abort;
            writeOutput('<div class="alert alert-danger">DB Error: #e.message#</div>');
        }

    } else {
        writeOutput('<div class="alert alert-danger">All fields including image are required!</div>');
    }
</cfscript>
