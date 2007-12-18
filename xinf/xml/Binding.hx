/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

class Binding<T:Node> implements IBinding {
    var marshallers:Hash<Class<T>>;
    var instantiators:Array<Instantiator<T>>;
    
    public function new() :Void {
        marshallers = new Hash<Class<T>>();
        instantiators = new Array<Instantiator<T>>();
    }
    public function add( nodeName:String, m:Class<T> ) :Void {
        marshallers.set( nodeName, m );
    }
    public function addInstantiator( i:Instantiator<T> ) :Void {
        instantiators.push( i );
    }
    public function instantiate( xml:Xml ) :Node {
        var m:Class<T>;
        for( i in instantiators ) {
            if( m==null && i.fits(xml) ) m=i.getClass(xml);
        }
        if( m==null ) m = marshallers.get( xml.nodeName );
		if( m==null ) return null;
		
		var ret:T;
		try {
			ret = Type.createInstance( m, [ null ] );
		} catch( e:Dynamic ) {
			throw("Could not create instance of "+Type.getClassName(m)+": "+e );
		}
        return ret;
    }
}

