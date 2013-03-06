<cfoutput>
#getPlugin("messagebox").renderit()#
<a href="#event.buildLink('groovy')#">Back Home</a>
<br /><br />
<hr />
Original:
<cfdump var="#rc.original#" label="Original Struct">

Groovy Modified Collection:
<cfdump var="#rc.varCollection#" label="Groovy affected">
<br />
</cfoutput>

