package xinf.ony.base;

import xinf.erno.Paint;
import xinf.geom.Transform;

enum GradientUnits {
	UserSpaceOnUse;
	ObjectBoundingBox;
}

class Gradient extends PaintElement {
	
    public var href(default,set_href):String;
    public var peer(default,set_peer):Gradient;

	public var gradientTransform(get_gradientTransform,null) :Transform;
	public var gradientUnits(get_gradientUnits,null) :GradientUnits;
	public var spreadMethod(get_spreadMethod,null) :SpreadMethod;
	public var stops(get_stops,null): Array<TGradientStop>;

	function get_gradientTransform() :Transform {
		if( gradientTransform == null && peer != null)
			return peer.get_gradientTransform();
		return gradientTransform;
	}
	
	function get_gradientUnits() :GradientUnits {
		if( gradientUnits == null ) {
			if( peer != null )
				return peer.gradientUnits;
			else
				return ObjectBoundingBox;
		}
		return gradientUnits;
	}
	
	function get_spreadMethod() :SpreadMethod {
		if( spreadMethod == null ) {
			if( peer != null )
				return peer.spreadMethod;
			else
				return PadSpread;
		}
		return spreadMethod;
	}
	
	function get_stops() :Array<TGradientStop> {
		if( stops.length == 0 && peer != null) {
			return peer.get_stops();
		}
		return stops;
	}

	public function new() {
		super();
		gradientUnits = null;
		spreadMethod = null;
		transform = new Identity();
		stops = new Array<TGradientStop>();
	}
	
    function set_href(v:String) {
		href=v;
		try {
			peer=document.getTypedElementByURI( href, Gradient );
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
			peer=document.getTypedElementByURI( href, Gradient );
		}
	}
	
	override public function fromXml( xml:Xml ) :Void {
		super.fromXml(xml);

        if( xml.exists("gradientTransform") ) {
            gradientTransform = TransformParser.parse( xml.get("gradientTransform") );
        }

		if( xml.exists("gradientUnits") )
			if(xml.get("gradientUnits") == "userSpaceOnUse")
				gradientUnits = UserSpaceOnUse;
			else
				gradientUnits = ObjectBoundingBox;

		if( xml.exists("spreadMethod") ) {
			switch(xml.get("spreadMethod")) {
				case "reflect":
					spreadMethod = ReflectSpread;
				case "pad":
					spreadMethod = PadSpread;
				case "repeat":
					spreadMethod = RepeatSpread;
				default:
					trace("Unknown spreadMethod "+xml.get("spreadMethod"));
			}
		}

		for(i in xml.elementsNamed("stop")) {
			try {
				var s = new GradientStop();
				s.fromXml(i);
				stops.push(s);
			} catch(e:Dynamic) {
				throw("Error parsing GradientStop: "+e);
			}
		}

		if( xml.exists("xlink:href") ) 
			href = xml.get("xlink:href");

	}
}
