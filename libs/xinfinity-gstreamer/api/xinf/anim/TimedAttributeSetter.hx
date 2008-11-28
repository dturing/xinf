/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.xml.XMLElement;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;

import xinf.traits.SpecialTraitValue;

class TimedAttributeSetter extends TimedElement {
	
	static var TRAITS = {
		href:new StringTrait(),
		attributeName:new StringTrait(),
/*		attributeType:new StringTrait(), FIXME.. maybe differ getTrait/getStyleTrait? */
	}

	public var href(get_href,set_href):String;
	function get_href() :String { return getTrait("href",String); }
	function set_href( v:String ) :String { setTrait("href",v); return v; }

	public var attributeName(get_attribute_name,set_attribute_name):String;
	function get_attribute_name() :String { return getTrait("attributeName",String); }
	function set_attribute_name( v:String ) :String { setTrait("attributeName",v); return v; }

	var peer:XMLElement;

	override function reschedule() {
		super.reschedule();
		
		if( href!=null ) {
			// for now, we dont support external references
			var id = href.split("#")[1];
			peer = ownerDocument.getElementById( id );
		} else peer = parentElement;
	}

	function getFromTarget( ?presentation:Bool ) :Dynamic {
		if( peer==null || attributeName==null ) return null;
		return peer.getStyleTrait( attributeName, Dynamic, false, presentation );
	}

	function resetOnTarget() {
		if( peer==null || attributeName==null ) return;
		peer.setPresentationTrait( attributeName,
				peer.getStyleTrait( attributeName, Dynamic, false, false ));
	}

	function setOnTarget( value:Dynamic ) {
		if( peer==null || attributeName==null ) return;
		trace("set "+attributeName+" "+value );
		var tmp:Dynamic = {};
		peer.setTraitFromDynamic( attributeName, value, tmp );
		peer.setPresentationTrait( attributeName, 
				Reflect.field(tmp,attributeName) );
	}
	
	function resolve( name:String, value:Dynamic ) :Dynamic {
		if( Std.is( value, SpecialTraitValue ) ) {
			var v2:SpecialTraitValue = cast(value);
			var v = v2.get(name,Dynamic,peer);
			return v;
		}
		return value;
	}
	
}
