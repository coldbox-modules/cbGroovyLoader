/**
Module Directives as public properties
this.title 				= "Title of the module";
this.author 			= "Author of the module";
this.webURL 			= "Web URL for docs purposes";
this.description 		= "Module description";
this.version 			= "Module Version";
this.viewParentLookup   = (true) [boolean] (Optional) // If true, checks for views in the parent first, then it the module.If false, then modules first, then parent.
this.layoutParentLookup = (true) [boolean] (Optional) // If true, checks for layouts in the parent first, then it the module.If false, then modules first, then parent.
this.entryPoint  		= "" (Optional) // If set, this is the default event (ex:forgebox:manager.index) or default route (/forgebox) the framework
									       will use to create an entry link to the module. Similar to a default event.
this.cfmapping			= "The CF mapping to create";
this.modelNamespace		= "The namespace to use for registered models, if blank it uses the name of the module."
this.dependencies 		= "The array of dependencies for this module"

structures to create for configuration
- parentSettings : struct (will append and override parent)
- settings : struct
- datasources : struct (will append and override parent)
- interceptorSettings : struct of the following keys ATM
	- customInterceptionPoints : string list of custom interception points
- interceptors : array
- layoutSettings : struct (will allow to define a defaultLayout for the module)
- routes : array Allowed keys are same as the addRoute() method of the SES interceptor.
- wirebox : The wirebox DSL to load and use

Available objects in variable scope
- controller
- appMapping (application mapping)
- moduleMapping (include,cf path)
- modulePath (absolute path)
- log (A pre-configured logBox logger object for this object)
- binder (The wirebox configuration binder)
- wirebox (The wirebox injector)

Required Methods
- configure() : The method ColdBox calls to configure the module.

Optional Methods
- onLoad() 		: If found, it is fired once the module is fully loaded
- onUnload() 	: If found, it is fired once the module is unloaded

*/
component {

	// Module Properties
	this.title 				= "cbgroovy";
	this.author 			= "Sana Ullah, Luis Majano";
	this.webURL 			= "";
	this.description 		= "";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbgroovy";
	// Model Namespace
	this.modelNamespace		= "cbgroovy";
	// CF Mapping
	this.cfmapping			= "cbgroovy";
	// Auto-map models
	this.autoMapModels		= false;
	// Module Dependencies
	this.dependencies 		= ['cbjavaloader'];

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {

		};

		// Layout Settings
		layoutSettings = {
			defaultLayout = ""
		};

		// datasources
		datasources = {

		};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="home",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};

		// Custom Declared Interceptors
		interceptors = [
		];

		// Binder Mappings
		// binder.map("Alias").to("#moduleMapping#.model.MyService");

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// parse parent settings
		parseParentSettings();

		// config settings
		var configStruct 	= controller.getConfigSettings();
		
		//controller.getWireBox().getInstance( "loader@cbjavaloader" ).appendPaths( settings.groovy.libPath );
		binder.map("GroovyLoader@cbgroovy")
			.to("#moduleMapping#.models.GroovyLoader")
			.threadSafe()
			.asSingleton();

		controller.getWireBox().getInstance( "GroovyLoader@cbgroovy" ).configureClassPath(configStruct.groovy.libPath);	
		//controller.getWireBox().getInstance( "GroovyLoader@cbgroovy" ).test();
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var groovyDSL 		= oConfig.getPropertyMixin( "groovy", "variables", structnew() );

		// Setup Default Settings
		configStruct.groovy = {
			// The library path
			groovyLibPath = "/cbgroovy/models/lib",
			// other java, groovy files path
			libPath = ""
		};

		// if( !structKeyExists( configStruct, "groovy" ) ){ configStruct.groovy = {}; }
		// structAppend( configStruct.groovy, defaults );

		// incorporate custom settings
		structAppend( configStruct.groovy, groovyDSL, true );

	}

}