<cfcomponent output="false">
	
	<!--- Inject Groovy Loader --->
	<cfproperty name="groovyLoader" inject="id:GroovyLoader@cbgroovy">
	
	<!--- Import GScript For Awesome Groovy Scripting --->
	<cfimport prefix="groovy" taglib="/modules/cbgroovy/models/tags" />

	<cffunction name="index" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfargument name="rc" type="any">
		<cfargument name="prc" type="any">
		<cfscript>
			// Create the Hello.groovy class
			rc.oHello = groovyLoader.create("Hello");
			
			event.setView("groovy/home");
		</cfscript>
	</cffunction>
	
	<cffunction name="clearcache" access="public" returntype="void" output="false" hint="">
		<cfargument name="event" type="any">
		<cfargument name="rc" type="any">
		<cfargument name="prc" type="any">
		<cfscript>	
			groovyLoader.clearClazzCache();
			getInstance("MessageBox@cbmessagebox").info("Groovy class cache purged");
			setNextEvent('groovy');
		</cfscript>
	</cffunction>

	<!--- runscript --->
	<cffunction name="runscript" access="public" returntype="void" output="false" hint="">
		<cfargument name="event" type="any">
		<cfargument name="rc" type="any">
		<cfargument name="prc" type="any">
		<cfscript>	
			rc.varCollection = { createdAt = now() };
			rc.original = duplicate( rc.varCollection );
			
			groovyLoader.runScript( 'Test', rc.varCollection );
			
			event.setView("groovy/runscript");
		</cfscript>
	</cffunction>
	
	<!--- runscript --->
	<cffunction name="runsource" access="public" returntype="void" output="false" hint="">
		<cfargument name="event" type="any">
		<cfargument name="rc" type="any">
		<cfargument name="prc" type="any">
		<cfscript>	
			/* Groovy Source Code */
			var source = "varCollection.GroovyArray = [1,2,3,4]";
			
			rc.varCollection = { createdAt = now() };
			rc.original = duplicate( rc.varCollection );
			
			groovyLoader.runSource( source, rc.varCollection );
			
			event.setView("groovy/runSource");
		</cfscript>
	</cffunction>
	
	<!--- runTagSource --->
	<cffunction name="runTagSource" access="public" returntype="void" output="false" hint="">
		<cfargument name="event" type="any">
		<cfargument name="rc" type="any">
		<cfargument name="prc" type="any">
		
		<!--- Place Date --->
		<cfset rc.today = now()>
		
		<!--- Groovy Script --->
		<groovy:script>
		<cfoutput>
			def today = coldbox_rc[ "today" ]
			def SubjectLine = [ "Hello", "my", "name", "is", "Luis Majano.", "Expressed at", today ]
			// Place in ColdBox request collection
			coldbox_rc[ "SubjectLine" ] = SubjectLine.join("_")
			coldbox_prc[ "GroovyPRC" ] = "Groovy just created this PRC variable"
		</cfoutput>
		</groovy:script>
		
		<cfset event.setView("groovy/runTagSource")>
	</cffunction>
	
	<!--- runTagSource --->
	<cffunction name="runDynamic" access="public" returntype="void" output="false" hint="">
		<cfargument name="event" type="any">
		<cfargument name="rc" type="any">
		<cfargument name="prc" type="any">
		<cfscript>
			rc.today = now();
			rc.varCollection = {firstName = "Sana", lastName = "Ullah"};
			rc.e = "";
			
			groovyLoader.runScript( 'Dynamic', rc.varCollection );
			
			event.setView("groovy/runDynamic");
		</cfscript>
	</cffunction>
	
</cfcomponent>