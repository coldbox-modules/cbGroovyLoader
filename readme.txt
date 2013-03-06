********************************************************************************
Copyright 2005-2008 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************
HONOR GOES TO GOD ABOVE ALL
********************************************************************************
Because of His grace, this project exits. If you don't like this, then don't read it, its not for you.

"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

********************************************************************************
WELCOME TO COLDBOX GROOVY LOADER PROJECT
********************************************************************************
The following guide can be read in full splendor here: 
http://wiki.coldbox.org/wiki/Projects:GroovyLoader.cfm

********************************************************************************
INTRODUCTION
********************************************************************************

This project is thanks to Barney Boisevert for his cfgroovy inspiration.

This project dynamically loads a ColdBox application with the Groovy runtime and
other java libraries you so desire.  You can configure a classpath within your application 
that will act as the root of what you want to execute or you can dynamically use the groovy scripting tags.

The groovy loader plugin also leverages the ColdBox cache in order to store the java
class files the Groovy Loader creates from script.  Internally, the groovy class loader
also caches the parsed classes so they are not re-parsed at runtime.  The plugin includes
two methods to interact with these caches:

 * '''clearClazzCache()''' : Cleans the ColdBox cache of loaded groovy scripts
 * '''clearClassLoaderCache()''' :  Cleans the actual classloader's cache, use sparingly

Why would I want to clear the class loader cache?  You want to do this, whenever
you make changes to the groovy files on disk.  However, be warned that classloading
is a very tempestous beast and it can lead to memory leaks or JVM permGen errors
as class definitions do not get garbage collected or disposed of.  However, this
side effect is only visualized on development.

********************************************************************************
RELEASE NOTES
********************************************************************************

=== Version 3.0 ===
* Updated to ColdBox 3.6 standards
* Updated to pass in the private request collection to groovy bindings
* Updated to pass in the request scope to groovy bindings
* Updated all examples and cleanup
* Better cache utilizations and retrievals

=== VERSION 2.0 ===
* Added ability to load more than 1 location for groovy scripts
* Added ability to load more than 1 location for java libraries alongside groovy language
* Added the !GroovyStarter interceptor for easy loading of the runtime, fully configurable

=== VERSION 1.0 ===
* Initial groovy integration