package xinf.xml;

class Binding<T> {
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
    public function instantiate( xml:Xml ) :T {
        var m:Class<T>;
        for( i in instantiators ) {
            if( m==null && i.fits(xml) ) m=i.getClass(xml);
        }
        if( m==null ) m = marshallers.get( xml.nodeName );
		if( m==null ) return null;
		var ret:T = Type.createInstance( m, [ null ] );
        return ret;
    }
}

