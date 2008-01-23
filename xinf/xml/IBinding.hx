/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

/**
	Represents a Binding of XML content to instantiated $xinf.xml.Node$s.
	
	Usually, the one incarnation of this interface, $xinf.xml.Binding$,
	should be enough for most purposes.
*/
interface IBinding {

	/** Instantiate (unmarshals/deserializes) the given [xml],
		and returns the instantiated Node.
		
		The returned Node will yet be empty ([fromXml] is not
		yet called).
	*/
    function instantiate( xml:Xml ) :Node;
	
	/** Bind the given [nodeName] (or tag name) to the class [cl].
		
		The class must have a constructor with only one, dynamic
		argument, like $xinf.xml.Element$, or instantiation will fail.
	*/
    function add( nodeName:String, cl:Class<Node> ) :Void;

}
