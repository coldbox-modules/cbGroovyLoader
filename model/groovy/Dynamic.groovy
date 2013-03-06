/**
 * Created with IntelliJ IDEA.
 * User: Sana Ullah
 * Date: 02/03/13
 * Time: 00:34
 * To change this template use File | Settings | File Templates.
 */
 
	def e = new Expando()
	
	//incoming hashMap to generate properties
	def pList = varCollection
	
	pList.each{k,v->
		e.setProperty(k,v)
	}

	coldbox_rc['e'] = e
	