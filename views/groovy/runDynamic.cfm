<cfoutput>
#getInstance("MessageBox@cbmessagebox").renderit()#
<a href="#event.buildLink('groovy')#">Back Home</a>
<br /><br />
<hr />
Expando Dump:

<cfdump var="#rc.E#" label="Groovy Object">

<cfdump var="#{ object = rc.E.toString() }#" label="Groovy string object">
<br />
</cfoutput>

