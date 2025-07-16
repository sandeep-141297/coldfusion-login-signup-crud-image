component output="false" {

    this.name = "coldfusion-login-signup-crud-image";
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0,1,0,0);
    //this.datasource = "localDB"; 

    this.mappings["/cfc"] = expandPath("./cfc");

    function onApplicationStart() {
        application.appName = "ColdFusion AJAX User App";
        application.datasource = "localDB"; // Set your datasource name here
        return true;
    }

    function onSessionStart() {
        session.loggedIn = false;
    }

    function onRequestStart(targetPage) {
        //include "includes/functions.cfm";
        onApplicationStart();
    }

    function onError(exception, eventName) {
        writeDump(exception);
        abort;
    }

}
