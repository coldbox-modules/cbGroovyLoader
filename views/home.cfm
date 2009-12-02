<cfoutput>
#getPlugin("messagebox").renderit()#
<a href="#event.buildLink('groovy.clearcache')#">Clear Clazz Cache</a> | 
<a href="#event.buildLink('groovy.runScript')#">Run Script</a> | 
<a href="#event.buildLink('groovy.runSource')#">Run Source</a> | 
<a href="#event.buildLink('groovy.runTagSource')#">Run Tag Source</a>
<br /><br />
<hr />
Groovy Says: #rc.oHello.sayHello('Henrik')#<br />
</cfoutput>

