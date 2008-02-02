/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.xml.XMLElement;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;

//import xinf.ony.type.Paint; // FIXME this is a bad un-orthogonality!
//import xinf.ony.Element;
import xinf.traits.SpecialTraitValue;

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
		
		if( href!=null ) {
			// for now, we dont support external references
			var id = href.split("#")[1];
			peer = ownerDocument.getElementById( id );
		} else peer = parentElement;
	}

	function getFromTarget( ?presentation:Bool ) :Dynamic {
		if( peer==null || attributeName==null ) return null;
		return peer.getStyleTrait( attributeName, Dynamic, presentation );
	}

	function resetOnTarget() {
		if( peer==null || attributeName==null ) return;
		peer.setPresentationTrait( attributeName,
				peer.getStyleTrait( attributeName, Dynamic, false, false ));
//		updateTarget();
	}

	function setOnTarget( value:Dynamic ) {
		if( peer==null || attributeName==null ) return;
		
		var tmp:Dynamic = Reflect.empty();
		peer.setTraitFromDynamic( attributeName, value, tmp );
		peer.setPresentationTrait( attributeName, 
				Reflect.field(tmp,attributeName) );
//		updateTarget();
	}
	
	function resolve( name:String, value:Dynamic ) :Dynamic {
		if( Std.is( value, SpecialTraitValue ) ) {
			var v2:SpecialTraitValue = cast(value);
			var v = v2.get(name,Dynamic,peer);
	//		trace("RESOLVE "+value+" -> "+v );
			return v;
		}
		/*
	// FIXME: sth similar is needed for relative units!...
		if( peer==null || attributeName==null ) return value;
		if( Std.is( value, Paint ) 
			&& Std.is( peer, Element ) ) {
			var e:Element = cast(peer);
			var p:Paint = cast(value);
			var r = e.resolvePaint(p);
			trace("RESOLVE "+p+" -> "+r );
			return r;
		}
		*/
		return value;
	}
/*
	function updateTarget() {
		// FIXME: move these to TraitsDefinitions?
		untyped {
		//	if( peer.styleChanged!=null ) peer.styleChanged(attributeName);
		//	if( peer.redraw!=null ) peer.redraw();
		}
	}
	*/
}
