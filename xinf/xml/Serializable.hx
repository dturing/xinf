/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

/**
	An interface for objects that are (de-)serializable
	from/to XML.
	
	In reality, serialization is not currently supported.
	This interface will be extended with a toXml() function
	then.
*/
interface Serializable {
	/**
		De-serialize the object from the given Xml.
		
		You'll usually not call this. Instead, use
		$xinf.xml.Document$.instantiate or .load.
	*/
    function fromXml( xml:Xml ) :Void;
}
