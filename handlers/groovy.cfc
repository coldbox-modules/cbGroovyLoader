<cfcomponent name="groovy" extends="coldbox.system.eventhandler" output="false" autowire="true">		<!--- Dependencies --->	<cfproperty name="GroovyLoader" type="coldbox:myplugin:GroovyLoader.GroovyLoader" scope="instance">	<!--- Import GScript --->	<cfimport prefix="groovy" taglib="../plugins/GroovyLoader/tags" />	<cffunction name="index" access="public" returntype="void" output="false">		<cfargument name="Event" type="any">		<cfscript>			var rc = event.getCollection();			rc.oHello = instance.GroovyLoader.create("Hello");						event.setView("home");		</cfscript>	</cffunction>		<cffunction name="clearcache" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="any" required="yes">
		<cfscript>	
			var rc = event.getCollection();									instance.GroovyLoader.clearClazzCache();						setNextEvent('groovy');
		</cfscript>
	</cffunction>	<!--- runscript --->
	<cffunction name="runscript" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>				rc.varCollection = {createdAt=now()};
			instance.GroovyLoader.runScript('Test',rc.varCollection);						event.setView("runscript");
		</cfscript>
	</cffunction>		<!--- runscript --->	<cffunction name="runsource" access="public" returntype="void" output="false" hint="">		<cfargument name="Event" type="any" required="yes">		<cfscript>				var rc = event.getCollection(); 			/* Source */			var source = "varCollection.GroovyArray = [1,2,3,4]";						rc.varCollection = {createdAt=now()};						instance.GroovyLoader.runSource(source,rc.varCollection);						event.setView("runSource");		</cfscript>	</cffunction>		<!--- runTagSource --->
	<cffunction name="runTagSource" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
				<!--- Place Date --->		<cfset rc.today = now()>				<!--- Groovy Script --->		<groovy:script>		<cfoutput>			def today = coldbox_rc["today"]			def SubjectLine = ["Hello","my","name","is","Luis Majano.","Expressed at",today]			//Place in ColdBox event context			coldbox_rc["SubjectLine"] = SubjectLine.join("_")		</cfoutput>		</groovy:script>				<cfset event.setView("runTagSource")>
	</cffunction>	</cfcomponent>