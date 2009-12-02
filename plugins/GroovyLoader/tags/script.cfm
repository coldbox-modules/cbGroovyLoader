<!--- 
This tag must be called from within a ColdBox LifeCycle:
- Handler
- Plugins
- Layouts
- Views
- Interceptors
 --->
<!--- Throw Facade --->
<cffunction name="throw" access="private" hint="Facade for cfthrow" output="false">
	<!--- ************************************************************* --->
	<cfargument name="message" 	type="string" 	required="yes">
	<cfargument name="detail" 	type="string" 	required="no" default="">
	<cfargument name="type"  	type="string" 	required="no" default="Framework">
	<!--- ************************************************************* --->
	<cfthrow type="#arguments.type#" message="#arguments.message#"  detail="#arguments.detail#">
</cffunction>
<cfscript>
if( thisTag.executionMode eq "start" ){
	/* Check if end tag is set */
	if( not thisTag.hasEndTag ){
		throw(message="The gscript tag needs and end tag to work",type="GroovyLoader.gscript.IllegalUsageException");
	}
	/* Get Groovy Loader */
	groovyLoader = caller.controller.getPlugin(plugin="GroovyLoader.GroovyLoader",customPlugin=true);	
	/* Get Var Collection */		
	if( not structKeyExists(attributes,"varCollection") ){
		attributes.varCollection = structnew();
	}
}
else if( thisTag.executionMode eq "end"){
	/* Run the Source */
	groovyLoader.runSource(scriptSource=trim(thisTag.generatedContent),varCollection=attributes.varCollection);
}
</cfscript>