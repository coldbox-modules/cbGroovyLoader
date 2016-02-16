<cfoutput>
#getInstance("MessageBox@cbmessagebox").renderit()#
<a href="#event.buildLink('groovy')#">Back Home</a>
<br /><br />
<hr />
<h1>Expando as Dynamic Bean</h1>
Expando Dump:

<cfdump var="#rc.E#" label="Groovy Object">

<cfdump var="#{ object = rc.E.toString() }#" label="Groovy string object">

<cfdump var="#rc.E.getProperty('lastName')#" label="Groovy object dynamic method">

<cfset rc.E.setProperty('location','London')>


<cfdump var="#rc.E.getProperty('location')#" label="runtime we can key-value to object">

<br />
</cfoutput>

