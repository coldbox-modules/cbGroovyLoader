<?xml version="1.0" encoding="ISO-8859-1"?>
<Config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:noNamespaceSchemaLocation="http://www.coldboxframework.com/schema/config_2.6.0.xsd">
	<Settings>
		<!--The name of your application.-->
		<Setting name="AppName"						value="GroovyLoader"/>
		<!-- ColdBox set-up information for J2EE installation.
		     As context-root are actually virtual locations which does not correspond to physical location of files. for example 
		     /openbd   /var/www/html/tomcat/deploy/bluedragon

		     AppMapping setting will adjust physical location of Project/App files and coldbox will load handlers,plugis,config file etc
		     Create a cf mapping and enable this value. 
		     /MyApp /var/www/html/tomcat/deploy/bluedragon/MyAppFolder
		
		If you are using a coldbox app to power flex/remote apps, you NEED to set the AppMapping also. In Summary,
		the AppMapping is either a CF mapping or the path from the webroot to this application root. If this setting
		is not set, then coldbox will try to auto-calculate it for you. Please read the docs.
		
		<Setting name="AppMapping"					value="/MyApp"/>      
		
		-->
		<!--Default Debugmode boolean flag (Set to false in production environments)-->
		<Setting name="DebugMode" 					value="false" />
		<!--The Debug Password to use in order to activate/deactivate debugmode,activated by url actions -->
		<Setting name="DebugPassword" 				value=""/>
		<!--The fwreinit password to use in order to reinitialize the framework and application.Optional, else leave blank -->
		<Setting name="ReinitPassword" 				value=""/>
		<!--Default event name variable to use in URL/FORM etc. -->
		<Setting name="EventName"					value="event" />
		<!--This feature is enabled by default to permit the url dumpvar parameter-->
		<Setting name="EnableDumpVar"				value="false" />
		<!--Log Errors and entries on the coldfusion server logs, disabled by default if not used-->
		<Setting name="EnableColdfusionLogging" 	value="false" />
		<!--Log Errors and entries in ColdBox's own logging facilities. You choose the location, finally per application logging.-->
		<Setting name="EnableColdboxLogging"		value="false" />
		<!--The absolute or relative path to where you want to store your log files for this application-->
		<Setting name="ColdboxLogsLocation"			value="logs" />
		<!--Default Event to run if no event is set or passed. Usually the event to be fired first (NOTE: use event handler syntax)-->
		<Setting name="DefaultEvent" 				value="groovy.index"/>
		<!--Event Handler to run on the start of a request, leave blank if not used. Emulates the Application.cfc onRequestStart method	-->
		<Setting name="RequestStartHandler" 		value="main.onRequestStart"/>
		<!--Event Handler to run at end of all requests, leave blank if not used. Emulates the Application.cfc onRequestEnd method-->
		<Setting name="RequestEndHandler" 			value=""/>
		<!--Event Handler to run at the start of an application, leave blank if not used. Emulates the Application.cfc onApplicationStart method	-->
		<Setting name="ApplicationStartHandler" 	value="main.onAppInit"/>
		<!--Event Handler to run at the start of a session, leave blank if not used.-->
		<Setting name="SessionStartHandler" 		value=""/>
		<!--Event Handler to run at the end of a session, leave blank if not used.-->
		<Setting name="SessionEndHandler" 			value=""/>
		<!--The event handler to execute on all framework exceptions. Event Handler syntax required.-->
		<Setting name="ExceptionHandler"			value="" />
		<!--What event to fire when an invalid event is detected-->
		<Setting name="onInvalidEvent" 				value="" />
		<!--Full path from the application's root to your custom error page, else leave blank. -->
		<Setting name="CustomErrorTemplate"			value="" />
		<!--The Email address from which all outgoing framework emails will be sent. -->
		<Setting name="OwnerEmail" 					value="" />
		<!-- Enable Bug Reports to be emailed out, set to true by default if left blank
			A sample template has been provided to you in includes/generic_error.cfm
		 -->
		<Setting name="EnableBugReports" 			value="false"/>
		<!--UDF Library To Load on every request for your views and handlers -->
		<Setting name="UDFLibraryFile" 				value="" />
		<!--Flag to Auto reload the internal handlers directory listing. False for production. -->
		<Setting name="HandlersIndexAutoReload"   	value="true" />
		<!--Flag to auto reload the config.xml settings. False for production. -->
		<Setting name="ConfigAutoReload"          	value="false" />
		<!-- Declare the external views location. It can be relative to this app or external. This in turn is used to do cfincludes. -->
		<Setting name="ViewsExternalLocation" 		value=""/>
		<!-- Declare the external handlers base invocation path, if used. You have to use dot notation.Example: mymapping.myhandlers	-->
		<Setting name="HandlersExternalLocation"   	value="" />
		<!--Flag to cache handlers. Default if left blank is true. -->
		<Setting name="HandlerCaching" 				value="false"/>
		<!--Flag to cache events if metadata declared. Default is true -->
		<Setting name="EventCaching" 				value="false"/>
		<!--IOC Framework if Used, else leave blank-->
		<Setting name="IOCFramework"				value="" />
		<!--IOC Definition File Path, relative or absolute -->
		<Setting name="IOCDefinitionFile"			value="" />
		<!--IOC Object Caching, true/false. For ColdBox to cache your IoC beans-->
		<Setting name="IOCObjectCaching"			value="false" />
		<!--Request Context Decorator, leave blank if not using. Full instantiation path -->
		<Setting name="RequestContextDecorator" 	value=""/>
		<!--Flag if the proxy returns the entire request collection or what the event handlers return, default is false -->
		<Setting name="ProxyReturnCollection" 		value="false"/>
		<!-- What scope are flash persistance variables using. -->
		<Setting name="FlashURLPersistScope" 		value="session"/>
	</Settings>
	
	<DebuggerSettings>
		<InfoPanel expanded="false"/>
		<CachePanel expanded="true"/>
	</DebuggerSettings>

	<YourSettings>
		<!-- This Setting is a list of relative/absolute paths to also groovy load, done by the interceptor now
		<Setting name="groovyloader_libpaths" value="${AppMapping}/model/lib"/>
		
		-->
	</YourSettings>	
	
	<!--Declare Layouts for your application here-->
	<Layouts>
		<!--Declare the default layout, MANDATORY-->
		<DefaultLayout>Layout.Main.cfm</DefaultLayout>
	</Layouts>

	<Datasources />
	
	<Interceptors>
		<!-- USE AUTOWIRING -->
		<Interceptor class="coldbox.system.interceptors.Autowire" />
		<!-- USE SES -->
		<Interceptor class="coldbox.system.interceptors.SES">
			<Property name="configFile">config/routes.cfm</Property>
		</Interceptor>	
		
		<!-- Groovy Starter: Creates & configures the GroovyLoader -->
		<Interceptor class="${AppMapping}.plugins.GroovyLoader.GroovyStarter">
			<!-- Paths that hold groovy libs -->
			<Property name="groovyLibPaths">/${AppMapping}/model/groovy,/${AppMapping}/model/anotherPath</Property>
			<!-- Paths that hold jar's for us to load automagically -->
			<Property name="javalibPaths">/${AppMapping}/model/lib</Property>
		</Interceptor>
	</Interceptors>
	
</Config>
