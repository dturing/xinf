/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

/**
	Like the name suggests, an Instantiator is used
	to instantiate an object of a certain class.
	
	It is used by $xinf.xml.Binding$ to allow for 
	more complex binding of classes to XML content
	than simple nodeName to class relationships.
	
	For prominent example subclasses, see
	$xinf.xml.ByAttributeValue$ and $xinf.xml.HasAttribute$.
*/
class Instantiator<T> {
    var myClass : Class<T>;
	
	/** Create a new Instantiator for class [cl].
	*/
    public function new( cl:Class<T> ) {
        myClass = cl;
    }
    
	/** Return [true] if the Instantiator fits the
		given [xml]. The default implementation always
		returns false.
	*/
    public function fits( xml:Xml ) :Bool {
        return false;
    }
    
	/** Return the class this Instantiator represents.
	*/
    public function getClass( xml:Xml ) :Class<T> {
        return myClass;
    }
}

/**
	ByAttributeValue is an Instantiator that matches
	XML Elements that have a certain attribute with
	a certain value.
*/
class ByAttributeValue<T> extends Instantiator<T> {
    var attributeName:String;
    var attributeValue:String;
    
	/**
		Create a new ByAttributeValue Instantiator
		that matches XML elements that have an
		attribute with name [attributeName] and value
		[attributeValue], bound to class [cl].
		
		For example,<br/>
			[   var i = new ByAttributeValue("name","foo");]<br/>
		matches <br/>
			[   <anyNode name="foo"/>]
	*/
    public function new( attributeName:String, attributeValue:String, cl:Class<T> ) {
        super(cl);
        this.attributeName = attributeName;
        this.attributeValue = attributeValue;
    }
    
    override public function fits( xml:Xml ) :Bool {
        return( xml.get(attributeName) == attributeValue );
    }
}

/**
	HasAttribute is an Instantiator that matches
	XML Elements that have a certain attribute.
	
	In contrast to $xinf.xml.ByAttributeValue$,
	the attribute's value is not regarded.
*/
class HasAttribute<T> extends Instantiator<T> {
    var attributeName:String;
    
	/**
		Create a new HasAttribute Instantiator
		that matches xml elements that have an
		attribute with name [attributeName],
		bound to class [cl].
		
		For example, <br/>
			[  var i = new HasAttribute("name");] <br/>
		matches <br/>
			[  <anyNode name="anyValue"/>]
	*/    
	public function new( attributeName:String, cl:Class<T> ) {
        super(cl);
        this.attributeName = attributeName;
    }
    
    override public function fits( xml:Xml ) :Bool {
        return( xml.get(attributeName) != null );
    }
}