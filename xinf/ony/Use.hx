/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;
import xinf.traits.StringTrait;
import xinf.ony.traits.LengthTrait;
import xinf.ony.type.Length;

class Use extends ElementImpl {
	static var TRAITS = {
		x:new LengthTrait(),
		y:new LengthTrait(),
		href:new StringTrait(),
	};

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Length).value; }
    function set_x( v:Float ) :Float { setTrait("x",new Length(v)); redraw(); return v; }
	
    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Length).value; }
    function set_y( v:Float ) :Float { setTrait("y",new Length(v)); redraw(); return v; }

    public var href(get_href,set_href):String;
    function get_href() :String { return getTrait("href",String); }
    function set_href( v:String ) :String { setTrait("href",v); resolve(); return v; }

    var peer(default,set_peer):ElementImpl;

	function set_peer( p:ElementImpl ) :ElementImpl {
		peer=p;
		// TODO: set href to something sensible?
		//href=null;
		redraw();
		return peer;
	}
	
    function resolve() {
		if( href==null ) return;
		// for now, we dont support external references
		var id = href.split("#")[1];
		try {
			peer = ownerDocument.getTypedElementById( id, ElementImpl );
			if( peer==null ) throw("#"+id+" not found");
		} catch( e:Dynamic ) {
			trace("'Use' peer '"+href+"' invalid: "+e+", ignored.");
		}
		redraw();
	
    }
	
	override public function onLoad() :Void {
		super.onLoad();
		resolve();
	}

}
