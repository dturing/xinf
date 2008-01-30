/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.xml.XMLElement;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;

class TimedAttributeSetter extends TimedElement {
	
	static var TRAITS = {
		href:new StringTrait(),
		attributeName:new StringTrait(),
/*		attributeType:new StringTrait(), - no difference in xinf! DOCME */
	}

    public var href(get_href,set_href):String;
    function get_href() :String { return getTrait("href",String); }
    function set_href( v:String ) :String { setTrait("href",v); reschedule(); return v; }

    public var attributeName(get_attribute_name,set_attribute_name):String;
    function get_attribute_name() :String { return getTrait("attributeName",String); }
    function set_attribute_name( v:String ) :String { setTrait("attributeName",v); reschedule(); return v; }

	var peer:XMLElement;

	override function reschedule() {
		super.reschedule();
		
		if( href!=null ) peer = ownerDocument.getElementById(href);
		else peer = parentElement;
	}

	function getFromTarget( ?presentation:Bool ) :Dynamic {
		if( peer==null || attributeName==null ) return null;
		return peer.getStyleTrait( attributeName, Dynamic, presentation );
	}

	function resetOnTarget() {
		if( peer==null || attributeName==null ) return;
		peer.setPresentationTrait( attributeName,
				peer.getStyleTrait( attributeName, Dynamic, false, false ));
	}

	function setOnTarget( value:Dynamic ) {
		if( peer==null || attributeName==null ) return;
		
		var tmp:Dynamic = Reflect.empty();
		peer.setTraitFromDynamic( attributeName, value, tmp );
		peer.setPresentationTrait( attributeName, 
				Reflect.field(tmp,attributeName) );
		untyped {
			if( peer.styleChanged!=null ) peer.styleChanged();
			if( peer.redraw!=null ) peer.redraw();
		}
	}

}
