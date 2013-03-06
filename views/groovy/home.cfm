<cfoutput>
<a href="#event.buildLink('groovy.clearcache')#">Clear Clazz Cache</a> | 
<a href="#event.buildLink('groovy.runScript')#">Run Script</a> | 
<a href="#event.buildLink('groovy.runSource')#">Run Source</a> | 
<a href="#event.buildLink('groovy.runTagSource')#">Run Tag Source</a> |
<a href="#event.buildLink('groovy.runDynamic')#">Run Dynamic Source</a>

#getPlugin("MessageBox").renderit()#

<br /><br />
<div class="well">
	<p>Groovy Says: #rc.oHello.sayHello( 'ColdBox' )#</p>
</div>
</cfoutput>

