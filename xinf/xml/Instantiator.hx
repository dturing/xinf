/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

class Instantiator<T> {
    var myClass : Class<T>;
    public function new( m:Class<T> ) {
        myClass = m;
    }
    
    public function fits( xml:Xml ) :Bool {
        return false;
    }
    
    public function getClass( xml:Xml ) :Class<T> {
        return myClass;
    }
}

class ByPropertyValue<T> extends Instantiator<T> {
    var propName:String;
    var propValue:String;
    
    public function new( propName:String, propValue:String, m:Class<T> ) {
        super(m);
        this.propName = propName;
        this.propValue = propValue;
    }
    
    override public function fits( xml:Xml ) :Bool {
        return( xml.get(propName) == propValue );
    }
}

class HasProperty<T> extends Instantiator<T> {
    var propName:String;
    
    public function new( propName:String, m:Class<T> ) {
        super(m);
        this.propName = propName;
    }
    
    override public function fits( xml:Xml ) :Bool {
        return( xml.get(propName) != null );
    }
}