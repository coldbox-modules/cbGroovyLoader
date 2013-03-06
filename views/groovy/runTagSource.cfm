<cfoutput>
#getPlugin("messagebox").renderit()#
<a href="#event.buildLink('groovy')#">Back Home</a>
<br /><br />
<hr />
List of object properties;
<cfdump var="#rc#" label="RC">
<cfdump var="#prc#" label="PRC">
</cfoutput>

