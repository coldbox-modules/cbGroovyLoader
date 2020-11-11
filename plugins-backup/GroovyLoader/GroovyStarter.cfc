<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author      :	Luis Majano
Date        :	04/05/2009
License		: 	Apache 2 License
Description :
This interceptor will take care of initializing the groovy plugin
as an interceptor and make life easy
----------------------------------------------------------------------->
<cfcomponent name="GroovyStarter" extends="coldbox.system.Interceptor" output="false">
	<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<!--- configure --->
	<cffunction
		name      ="configure"
		output    ="false"
		access    ="public"
		returntype="void"
		hint      ="Configure this interceptor"
	>
		<cfscript>
		/* Check if user placed libpaths */
		if ( propertyExists( "javalibPaths" ) ) {
			/* Then add it as a setting, so plugin picks it up */
			setSetting( "groovyloader_libpaths", getProperty( "javalibPaths" ) );
		}
		/* Check for Groovy Class Paths, else set to empty */
		if ( NOT propertyExists( "groovyLibPaths" ) ) {
			setProperty( "groovyLibPaths", "" );
		}
		/* Default GroovyPlugin Location */
		if ( NOT propertyExists( "pluginClassPath" ) ) {
			setProperty( "pluginClassPath", "GroovyLoader.GroovyLoader" );
		}
		</cfscript>
	</cffunction>

	<!--- afterAspectsLoad --->
	<cffunction
		name      ="afterAspectsLoad"
		output    ="false"
		access    ="public"
		returntype="void"
		hint      ="Load the Groovy Loader Runtime"
	>
		<cfscript>
		getMyPlugin( getProperty( "pluginClassPath" ) ).configureClassPath(
			getProperty( "groovyLibPaths" )
		);
		</cfscript>
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->
</cfcomponent>
