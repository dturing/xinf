/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.traits.StringTrait;

class Style extends ElementImpl {

	static var TRAITS = {
		type:new StringTrait(),
		text:new StringTrait(),
	}

    public var type(get_type,set_type):String;
    function get_type() :String { return getTrait("type",String); }
    function set_type( v:String ) :String { return setTrait("type",v); }

    public var text(get_text,set_text):String;
    function get_text() :String { return getTrait("text",String); }
    function set_text( v:String ) :String { return setTrait("text",v); }

	override public function fromXml( xml:Xml ) :Void {
		super.fromXml(xml);
		
		if( type=="text/css" ) {
			var t = "";
			for( node in xml ) {
				if( node.nodeType == Xml.PCData 
				 || node.nodeType == Xml.CData ) {
				 t += node.nodeValue;
				}
			}
			
			if( t.length>0 ) {
				ownerDocument.styleSheet.parseCSS( t );
				text = t;
			}
		}
	}
}
