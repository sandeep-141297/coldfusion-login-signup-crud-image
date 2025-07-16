<cfsetting showdebugoutput="false">
<cfcontent type="text/html">
<cfscript>

    response = {
        status: "success",
        message: "Profile updated successfully.",
        newImage: ""
    };

    if (!structKeyExists(session, "loggedIn") || !session.loggedIn) {
        response.status = "error";
        response.message = "Unauthorized";
        writeOutput(serializeJSON(response));
        abort;
    }

    id = session.userID;
    name = trim(form.name ?: "");
    email = trim(form.email ?: "");
    imageField = "profileImage";
    uploadPath = expandPath("../uploads/");
    imageChanged = false;

    if (structKeyExists(form, imageField) && len(form[imageField])) {
        imageChanged = true;
    }

    if (len(name) && len(email)) {

        if (imageChanged) {
            oldImageQuery = queryExecute("
                SELECT profile_image FROM persons WHERE id = :id
            ", { id: { value: id, cfsqltype: "cf_sql_integer" } },
            { datasource = application.datasource });

            oldImage = oldImageQuery.recordCount ? oldImageQuery.profile_image : "";

            if (!directoryExists(uploadPath)) {
                directoryCreate(uploadPath);
            }

            uploadedImage = fileUpload(
                destination = uploadPath,
                fileField = imageField,
                onConflict = "makeUnique",
                mimeType = "image/jpeg,image/png",
                strict = true
            );

            newImage = uploadedImage.serverFile;
            response.newImage = newImage;

            if (len(oldImage)) {
                oldImagePath = uploadPath & oldImage;
                if (fileExists(oldImagePath)) fileDelete(oldImagePath);
            }

            queryExecute("
                UPDATE persons
                SET name = :name, email = :email, profile_image = :img
                WHERE id = :id
            ", {
                name: { value: name, cfsqltype: "cf_sql_varchar" },
                email: { value: email, cfsqltype: "cf_sql_varchar" },
                img: { value: newImage, cfsqltype: "cf_sql_varchar" },
                id: { value: id, cfsqltype: "cf_sql_integer" }
            }, { datasource = application.datasource });

        } else {
            queryExecute("
                UPDATE persons
                SET name = :name, email = :email
                WHERE id = :id
            ", {
                name: { value: name, cfsqltype: "cf_sql_varchar" },
                email: { value: email, cfsqltype: "cf_sql_varchar" },
                id: { value: id, cfsqltype: "cf_sql_integer" }
            }, { datasource = application.datasource });
        }

        session.userName = name;
        session.email = email;

    } else {
        response.status = "error";
        response.message = "Missing required fields.";
    }

    writeOutput(serializeJSON(response));

</cfscript>
