<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author      :	Luis Majano
Date        :	04/05/2009
License		: 	Apache 2 License
Description :
This plugin takes care of javaloading the groovy scripting language.
It also adds convenience methods for creating and maintaining groovy
classes.

This plugin exists thanks to CFGroovy and Barney Boisevert for inspiration.
www.barneyb.com
----------------------------------------------------------------------->
<cfcomponent name="GroovyLoader" extends="coldbox.system.Plugin" output="false" singleton>
	<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" access="public" returntype="GroovyLoader">
		<cfargument name="controller" type="any" required="true">
		<cfscript>
		/* Plugin Setup */
		super.init( arguments.controller );
		setPluginName( "Groovy Loader" );
		setPluginVersion( "3.0" );
		setPluginDescription( " Plugin for interacting with the Groovy Language" );
		setPluginAuthor( "Ortus Solutions" );
		setPluginAuthorURL( "http://www.ortussolutions.com" );

		/* Core Java Lib Path where groovy lang is located */
		instance.javaLibPaths = getDirectoryFromPath( getMetadata( this ).path ) & "lib";
		/* Groovy Class Path */
		instance.groovyClassPath = "";
		/* Java Loader */
		instance.javaLoader = getPlugin( "JavaLoader" );
		/* Check for User paths in settings, it can be a list. */
		if ( settingExists( "groovyloader_libpaths" ) ) {
			instance.javaLibPaths = listAppend(
				instance.javaLibPaths,
				getSetting( "groovyloader_libpaths" )
			);
		}
		/* JavaLoad Groovy Lib & Extras */
		instance.javaLoader.setup( pathToArray( instance.javaLibPaths ) );
		/* Create Groovy Class Loader */
		instance.groovyClassLoader = instance.javaLoader
			.create( "groovy.lang.GroovyClassLoader" )
			.init( instance.javaLoader.getURLClassLoader() );

		/* Return groovy loader */
		return this;
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->

	<!--- getGroovy --->
	<cffunction
		name      ="create"
		output    ="false"
		access    ="public"
		returntype="any"
		hint      ="Create a groovy class and returns it to you"
	>
		<cfargument
			name    ="clazz"
			type    ="string"
			required="true"
			hint    ="The groovy class path, without using the base path already set. Ex: Hello, com.coldbox.Person Do not append .groovy"
		/>
		<cfscript>
		var classLoader    = getGroovyClassLoader();
		var targetObject   = 0;
		var targetFilePath = getTargetFilePath( arguments.clazz );
		var cacheKey       = "groovy-" & targetFilePath;
		var oCache         = getColdboxOCM();

		// Try to get class
		targetObject = oCache.get( cacheKey );
		if ( isNull( targetObject ) ) {
			// Parse the target File and create a new instance
			targetObject = classLoader.parseClass( getTargetFileObject( targetFilePath ) );
			// Cache it
			oCache.set( cacheKey, targetObject );
		}

		/* Return built groovy class */
		return targetObject.newInstance();
		</cfscript>
	</cffunction>

	<!--- runScript --->
	<cffunction
		name      ="runScript"
		output    ="false"
		access    ="public"
		returntype="void"
		hint      ="Executes a groovy script by name and binded with Coldbox Vars and your own Vars. Binded Variables [coldbox_event,coldbox_controller,varCollection,cf_pageContext]"
	>
		<cfargument
			name    ="scriptname"
			type    ="string"
			required="true"
			hint    ="The script name to execute, do not add .groovy"
		/>
		<cfargument
			name    ="varCollection"
			type    ="struct"
			required="false"
			default ="#structNew()#"
			hint    ="A variable collection to bind the script with"
		/>
		<cfscript>
		var script = 0;
		/* Create Script Clazz */
		script = create( arguments.scriptname );
		/* Bind Our Variables */
		script.setBinding( getBinding( arguments.varCollection ) );
		/* Execute it */
		script.run();
		</cfscript>
	</cffunction>

	<!--- runSource --->
	<cffunction
		name      ="runSource"
		output    ="false"
		access    ="public"
		returntype="void"
		hint      ="Executes a groovy script by source and binded with Coldbox Vars and your own Vars. Binded Variables [coldbox_event,coldbox_controller,varCollection,cf_pageContext]"
	>
		<cfargument
			name    ="scriptSource"
			type    ="string"
			required="true"
			hint    ="The script source to execute"
		/>
		<cfargument
			name    ="varCollection"
			type    ="struct"
			required="false"
			default ="#structNew()#"
			hint    ="A variable collection to bind the script with"
		/>
		<cfscript>
		var classLoader  = getGroovyClassLoader();
		var script       = 0;
		var cacheKey     = "groovy-" & hash( arguments.scriptSource );
		var targetObject = 0;
		var oCache       = getColdboxOCM();

		/* Check if source is not empty */
		if ( len( trim( arguments.scriptSource ) ) eq 0 ) {
			throw(
				message = "source content cannot be empty",
				type    = "GroovyLoader.gscript.IllegalUsageException"
			);
		}

		/* Check if scriptsource already in cache */
		targetObject = oCache.get( cacheKey );
		if ( isNull( targetObject ) ) {
			/* Parse the target source and create a new instance */
			targetObject = classLoader.parseClass( arguments.scriptSource );
			/* Cache it */
			oCache.set( cacheKey, targetObject );
		}

		/* Create Script From Source */
		script = targetObject.newInstance();
		/* Bind this puppy */
		script.setBinding( getBinding( arguments.varCollection ) );
		/* Execute it */
		script.run();
		</cfscript>
	</cffunction>

	<!--- configure --->
	<cffunction
		name      ="configureClassPath"
		output    ="false"
		access    ="public"
		returntype="void"
		hint      ="Configure the base path where your groovy files are located. THis can be a list of locations and order is important"
	>
		<cfargument
			name    ="dirpaths"
			type    ="string"
			required="true"
			hint    ="The absolute/relative base paths where your groovy files are located, it can be a comma delimmitted list."
		/>
		<cfscript>
		var x        = 1;
		var thisPath = "";
		var jio      = "";

		for ( x = 1; x lte listLen( arguments.dirpaths ); x++ ) {
			thisPath = listGetAt( arguments.dirpaths, x );
			/* Load it Up */
			thisPath = replace( thisPath, "\", "/", "all" );
			if ( not right( thisPath, 1 ) eq "/" ) {
				thisPath = thisPath & "/";
			}
			/* Absolute Check */
			jio = createObject( "java", "java.io.File" ).init( thisPath );
			if ( NOT jio.isAbsolute() ) {
				thisPath = expandPath( thisPath );
			}
			/* Check Again. */
			if ( directoryExists( thisPath ) ) {
				/* Append to the internal groovy class path */
				instance.groovyClassPath = listAppend( getGroovyClassPath(), thisPath );
				/* Configure ClassLoader With This Path */
				getGroovyClassLoader().addClassPath( thisPath );
			} else {
				throw(
					message = "Error Configuring Class Paths",
					detail  = "Directory path #thisPath# does not exist. Please check your configuration.",
					type    = "GroovyLoader.DirectoryNotFoundException"
				);
			}
		}
		</cfscript>
	</cffunction>

	<!--- Get the Groovy CLassLoader --->
	<cffunction
		name      ="getGroovyClassLoader"
		access    ="public"
		returntype="any"
		output    ="false"
		hint      ="Return the groovy class loader object"
	>
		<cfreturn instance.GroovyClassLoader>
	</cffunction>

	<!--- Get the class path --->
	<cffunction
		name      ="getGroovyClassPath"
		access    ="public"
		returntype="string"
		output    ="false"
		hint      ="Return the paths this groovy loader was configured with, for locating groovy scripts/classes"
	>
		<cfreturn instance.groovyClassPath>
	</cffunction>

	<cffunction
		name      ="getJavaLibPaths"
		access    ="public"
		returntype="string"
		output    ="false"
		hint      ="Return the paths used by this plugin for core java libraries"
	>
		<cfreturn instance.javaLibPaths>
	</cffunction>

	<!--- clearCache --->
	<cffunction
		name      ="clearClazzCache"
		output    ="false"
		access    ="public"
		returntype="void"
		hint      ="Clear the clazz cache"
	>
		<cfscript>
		getColdboxOCM().clearByKeySnippet( keySnippet = "groovy-", async = false );
		</cfscript>
	</cffunction>

	<!--- clearClassLoaderCache --->
	<cffunction
		name      ="clearClassLoaderCache"
		output    ="false"
		access    ="public"
		returntype="void"
		hint      ="Clear the class loader parsed class cache"
	>
		<cfscript>
		getGroovyClassLoader().clearCache();
		</cfscript>
	</cffunction>

	<!------------------------------------------- PRIVATE ------------------------------------------->

	<!--- getTargetFilePath --->
	<cffunction
		name      ="getTargetFilePath"
		output    ="false"
		access    ="private"
		returntype="any"
		hint      ="Get the complete path to the file"
	>
		<cfargument
			name    ="scriptname"
			type    ="string"
			required="true"
			hint    ="The script name to add a target file to"
		/>
		<cfscript>
		var paths     = getGroovyClassPath();
		var thisPath  = "";
		var thisClass = "";
		var x         = 1;

		for ( x = 1; x lte listLen( paths ); x++ ) {
			thisPath  = listGetAt( paths, x );
			thisClass = thisPath & arguments.scriptname & ".groovy";
			if ( fileExists( thisClass ) ) {
				return thisClass;
			}
		}

		/* if we get here, no class matched */
		throw(
			message = "Groovy class:#arguments.scriptname# not found",
			detail  = "The class could not be located in any of the configured class paths: #paths#",
			type    = "GroovyLoader.ClassNotFoundException"
		);
		</cfscript>
	</cffunction>

	<!--- getTargetFile --->
	<cffunction
		name      ="getTargetFileObject"
		output    ="false"
		access    ="private"
		returntype="any"
		hint      ="Create a groovy target file"
	>
		<cfargument
			name    ="scriptname"
			type    ="string"
			required="true"
			hint    ="The script name to add a target file to"
		/>
		<cfscript>
		return createObject( "java", "java.io.File" ).init( arguments.scriptname );
		</cfscript>
	</cffunction>

	<!--- pathToArray --->
	<cffunction
		name      ="pathToArray"
		output    ="false"
		access    ="private"
		returntype="Array"
		hint      ="Convert a path into array format"
	>
		<cfargument name="dirpath" type="string" required="true" hint="The dirpath to convert"/>
		<cfargument
			name    ="filter"
			type    ="string"
			required="false"
			default ="*.jar"
			hint    ="The filters to use"
		/>
		<cfset var qFiles = 0>
		<cfset var fileArray = arrayNew( 1 )>
		<cfset var libName = 0>
		<cfset var thisPath = "">

		<!--- Loop Over Sent in Paths --->
		<cfloop list="#arguments.dirpath#" index="thisPath">
			<!--- Check if Path exists, else expand it --->
			<cfif NOT directoryExists( thisPath )>
				<cfset thisPath = expandPath( thisPath )>
			</cfif>
			<!--- Final Check, else log it --->
			<cfif directoryExists( thisPath )>
				<cfdirectory
					action   ="list"
					directory="#thisPath#"
					name     ="qFiles"
					recurse  ="true"
					filter   ="#arguments.filter#"
				>
				<cfloop query="qFiles">
					<cfset arrayAppend( fileArray, qFiles.directory & "/" & qFiles.name )>
					<cfset println( "GroovyLoading: #qFiles.name#..." )>
				</cfloop>
			<cfelse>
				<cfset getPlugin( "Logger" ).warn(
					"GroovyLoader cannot load the directory: #thisPath# as it does not exist."
				)>
			</cfif>
		</cfloop>

		<cfreturn fileArray>
	</cffunction>

	<!--- Get a Binding --->
	<cffunction
		name      ="getBinding"
		access    ="private"
		output    ="false"
		returntype="any"
		hint      ="Prepare groovy bindings"
	>
		<cfargument
			name    ="varCollection"
			type    ="struct"
			required="false"
			default ="#structNew()#"
			hint    ="A variable collection to bind the script with"
		/>
		<cfscript>
		var binding = instance.javaloader.create( "groovy.lang.Binding" ).init();
		var event   = getController().getRequestService().getContext();

		/* Bind Common ColdBox & CF Data */
		binding.setVariable( "varCollection", arguments.varCollection );
		binding.setVariable( "coldbox_rc", event.getCollection() );
		binding.setVariable( "coldbox_prc", event.getCollection( private = true ) );
		binding.setVariable( "cf_pageContext", getPageContext() );
		binding.setVariable( "cf_application", application );
		binding.setVariable( "cf_server", server );
		binding.setVariable( "cf_request", request );
		if ( isDefined( "session" ) ) {
			binding.setVariable( "cf_session", session );
		}
		return binding;
		</cfscript>
	</cffunction>

	<!--- Print Ln --->
	<cffunction name="println" access="private" returntype="void" output="false">
		<cfargument name="str" type="string" required="Yes">
		<cfscript>
		createObject( "Java", "java.lang.System" ).out.println( arguments.str );
		</cfscript>
	</cffunction>
</cfcomponent>
