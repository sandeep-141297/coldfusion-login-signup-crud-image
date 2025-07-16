component accessors="true" {

    /**
     * Hash password using SHA-256
     */
    public string function hashPassword(required string plainText) {
        return hash(plainText, "SHA-256");
    }

    /**
     * Check password match (optional for login)
     */
    public boolean function verifyPassword(required string plainText, required string hashed) {
        return hash(plainText, "SHA-256") == hashed;
    }

}
