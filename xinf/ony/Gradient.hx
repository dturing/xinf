/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony;

import xinf.geom.Transform;
import xinf.geom.TransformParser;
import xinf.geom.Identity;
import xinf.ony.Implementation;
import xinf.ony.type.GradientUnits;
import xinf.ony.type.SpreadMethod;

import xinf.traits.EnumTrait;
import xinf.ony.traits.TransformTrait;

private typedef TGradientStop = {
	r :Float,
	g :Float,
	b :Float,
	a :Float,
	offset :Float
}

class Gradient extends ElementImpl {
	
	/* TODO: traitify stops */
	
	static var TRAITS = {
		gradientTransform:	new TransformTrait(),
		gradientUnits:		new EnumTrait<GradientUnits>( GradientUnits, null ),
		spreadMethod:		new EnumTrait<SpreadMethod>( SpreadMethod, "spread", null ),
	}
	
	public var href(default,set_href):String;
	public var peer(default,set_peer):Gradient;

	public var gradientTransform(get_gradientTransform,set_gradientTransform):Transform;
	function get_gradientTransform() :Transform { var r = getTrait("gradientTransform",Transform);
			if( r==null ) return( if( peer!=null ) peer.gradientTransform else new Identity() ); return r; }
	function set_gradientTransform( v:Transform ) :Transform { setTrait("gradientTransform",v); return v; }

	public var gradientUnits(get_gradientUnits,set_gradientUnits):GradientUnits;
	function get_gradientUnits() :GradientUnits { var r = getTrait("gradientUnits",GradientUnits,false);
			if( r==null ) return( if( peer!=null ) peer.gradientUnits else ObjectBoundingBox ); return r; }
	function set_gradientUnits( v:GradientUnits ) :GradientUnits { return setTrait("gradientUnits",v); }

	public var spreadMethod(get_spreadMethod,set_spreadMethod):SpreadMethod;
	function get_spreadMethod() :SpreadMethod { var r = getTrait("spreadMethod",SpreadMethod,false);
			if( r==null ) return( if( peer!=null ) peer.spreadMethod else PadSpread ); return r; }
	function set_spreadMethod( v:SpreadMethod ) :SpreadMethod { return setTrait("spreadMethod",v); }

	public var stops(get_stops,null): Array<TGradientStop>;

	function get_stops() :Array<TGradientStop> {
		if( stops.length == 0 && peer != null) {
			return peer.get_stops();
		}
		return stops;
	}

	public function new( ?traits:Dynamic ) {
		super( traits );
		stops = new Array<TGradientStop>();
	}
	
	function set_href(v:String) {
		href=v;
		try {
			peer=ownerDocument.getTypedElementByURI( href, Gradient );
		} catch(e:Dynamic) {
			// will retry in onLoad
		}
		return href;
	}
	
	function set_peer(v:Gradient) :Gradient {
		if( v == this ) throw("Gradient #"+id+" referencing itself.");
		peer = v;
		// FIXME: set id?
		redraw();
		return v;
	}
	
	override public function onLoad() :Void {
		super.onLoad();
		if( href!=null && peer==null ) {
			peer=ownerDocument.getTypedElementByURI( href, Gradient );
		}
	}
	
	override public function fromXml( xml:Xml ) :Void {
		super.fromXml(xml);

		// FIXME, maybe: make these normal nodes?
		for(i in xml.elementsNamed("stop")) {
			var s = new GradientStop();
			untyped s.ownerDocument = ownerDocument;
			untyped s.parentElement = this;
			s.fromXml(i);
			stops.push(s);
		}

		if( xml.exists("xlink:href") ) 
			href = xml.get("xlink:href");
	}
}
