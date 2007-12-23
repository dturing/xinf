/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.base;
import xinf.ony.base.Implementation;
import xinf.traits.LengthTrait;
import xinf.type.Length;

class Use extends ElementImpl {
	static var TRAITS = {
		x:new LengthTrait(),
		y:new LengthTrait(),
	};

    public var x(get_x,set_x):Float;
    function get_x() :Float { return getTrait("x",Length).value; }
    function set_x( v:Float ) :Float { setTrait("x",new Length(v)); redraw(); return v; }
	
    public var y(get_y,set_y):Float;
    function get_y() :Float { return getTrait("y",Length).value; }
    function set_y( v:Float ) :Float { setTrait("y",new Length(v)); redraw(); return v; }

    public var href(default,set_href):String;
    public var peer(default,set_peer):ElementImpl;

    private function set_href(v:String) {
		// for now, we dont support external references
		var id = v.split("#")[1];
		peer = ownerDocument.getTypedElementById( id, ElementImpl );
		if( peer==null ) throw("'Use' peer #"+id+" not found");
		href = "#"+id;
		
		redraw();
        return href;
    }
	
	private function set_peer(v:ElementImpl) :ElementImpl {
		peer = v;
		// FIXME: set id?
		redraw();
		return v;
	}
	
    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
		if( xml.exists("xlink:href") ) 
			href = xml.get("xlink:href");
    }

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties(to);
		if( href!=null ) to.set_href( href );
	}

}
