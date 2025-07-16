<cfscript>
    try {
        salt =UtilsrateSecretKey("AES");
        hash = generatePBKDF2Hash("hello123", salt, 10000, 64, "SHA-512");
        writeOutput("✅ Success: " & hash);
    } catch (any e) {
        writeDump(e);
    }
</cfscript>
