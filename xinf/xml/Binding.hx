/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

/**
	Represents a Binding of XML content to instantiated $xinf.xml.Node$s.
	
	Node classes can be bound either by simple 
	TagName-to-Class association ([add()]) or more
	complex $xinf.xml.Instantiator$s ([addInstantiator()]).
	
	Used primarily (if not only) by the $xinf.xml.Document$ class.
*/
class Binding implements IBinding {
    var marshallers:Hash<Class<Node>>;
    var instantiators:Array<Instantiator<Node>>;
    
	/** Create a new, initially empty, Binding
	*/
    public function new() :Void {
        marshallers = new Hash<Class<Node>>();
        instantiators = new Array<Instantiator<Node>>();
    }
	
	/** Bind the given [nodeName] (or tag name) to the class [cl].
		
		The class must have a constructor with only one, dynamic
		argument, like $xinf.xml.Element$, or instantiation will fail.
	*/
    public function add( nodeName:String, cl:Class<Node> ) :Void {
        marshallers.set( nodeName, cl );
    }
	
	/** Add the given Instantiator [i] to this Binding.
	*/
    public function addInstantiator( i:Instantiator<Node> ) :Void {
        instantiators.push( i );
    }
	
	/** Instantiate (unmarshal/deserialize) the given [xml],
		and returns the instantiated Node.
	
		Looks through all added Instantiators first, then
		through the list of nodeNames, and tries to construct
		the Object. If nothing is bound to the given xml,
		[null] is returned. If instantiation fails (for example,
		because the bound class' constructor has less or more
		than one argument), an exception is thrown.
		
		The returned Node will yet be empty ([fromXml] is not
		yet called).
		
		You shouldn't use this function directly. Instead,
		use $xinf.xml.Document$.instantiate() or .load().
	*/
    public function instantiate( xml:Xml ) :Node {
        var m:Class<Node>;
        for( i in instantiators ) {
            if( m==null && i.fits(xml) ) m=i.getClass(xml);
        }
        if( m==null ) m = marshallers.get( xml.nodeName );
		if( m==null ) return null;
		
		var ret:Node;
		try {
			ret = Type.createInstance( m, [ null ] );
		} catch( e:Dynamic ) {
			throw("Could not create instance of "+Type.getClassName(m)+": "+e );
		}
        return ret;
    }
}

