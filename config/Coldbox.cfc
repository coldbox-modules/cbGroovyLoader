<cfcomponent output="false" hint="My App Configuration">
	<cfscript>
	// Configure ColdBox Application
	function configure(){
		// coldbox directives
		coldbox = {
			// Application Setup
			appName                   : "Development Shell",
			// Development Settings
			reinitPassword            : "",
			handlersIndexAutoReload   : true,
			// Implicit Events
			defaultEvent              : "General.index",
			requestStartHandler       : "",
			requestEndHandler         : "",
			applicationStartHandler   : "main.onAppInit",
			applicationEndHandler     : "",
			sessionStartHandler       : "",
			sessionEndHandler         : "",
			missingTemplateHandler    : "",
			// Extension Points
			ApplicationHelper         : "",
			coldboxExtensionsLocation : "",
			modulesExternalLocation   : [],
			pluginsExternalLocation   : "",
			viewsExternalLocation     : "",
			layoutsExternalLocation   : "",
			handlersExternalLocation  : "",
			requestContextDecorator   : "",
			// Error/Exception Handling
			exceptionHandler          : "",
			onInvalidEvent            : "",
			customErrorTemplate       : "/coldbox/system/includes/BugReport.cfm",
			// Application Aspects
			handlerCaching            : false,
			eventCaching              : false,
			proxyReturnCollection     : false
		};

		// custom settings
		settings = {};

		// goovy files paths
		groovy = { libPath : "models/groovy,models/anotherPath" };

		// Activate WireBox
		wirebox = { enabled : true, singletonReload : false };

		// Module Directives
		modules = {
			// Turn to false in production, on for dev
			autoReload : false
		};

		// LogBox DSL
		logBox = {
			// Define Appenders
			appenders : {
				files : {
					class      : "coldbox.system.logging.appenders.RollingFileAppender",
					properties : {
						filename : "groovyloader",
						filePath : "/#appMapping#/logs"
					}
				}
			},
			// Root Logger
			root : { levelmax : "DEBUG", appenders : "*" },
			// Implicit Level Categories
			info : [ "coldbox.system" ]
		};

		// Layout Settings
		layoutSettings = { defaultLayout : "Main.cfm" };

		// Register interceptors as an array, we need order
		interceptors = [];
	}
	</cfscript>
</cfcomponent>
