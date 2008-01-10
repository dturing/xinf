/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;

class Interface extends Container {

	static var TRAITS = {
		width:new LengthTrait(),
		height:new LengthTrait(),
	}

	public var width(get_width,set_width):Float;
    function get_width() :Float { return getTrait("width",Length).value; }
    function set_width( v:Float ) :Float { setTrait("width",new Length(v)); setPrefSize({x:width,y:height}); return v; }
	
    public var height(get_height,set_height):Float;
    function get_height() :Float { return getTrait("height",Length).value; }
    function set_height( v:Float ) :Float { setTrait("height",new Length(v)); setPrefSize({x:width,y:height}); return v; }
	
	public function new( ?traits:Dynamic ) {
		super(traits);
		setPrefSize( size={x:width,y:height} );
	}
	
	public function captureRoot() {
		Root.addEventListener( GeometryEvent.STAGE_SCALED, rootResized );
		setPrefSize( size={ x:Root.width, y:Root.height } );
		Root.appendChild( getElement() );
		setOwnerDocument( Root.getRootSvg().ownerDocument ); // FIXME
	}
	
	public function appendTo( e:Group, w:Float, h:Float ) {
		setPrefSize( size={ x:w, y:h } );
		e.appendChild( getElement() );
		setOwnerDocument( e.ownerDocument ); // FIXME
	}
	
	function rootResized( e:GeometryEvent ) {
		setPrefSize( size=e );
		relayout();
	}
	
	override public function onLoad() {
		super.onLoad();
		setPrefSize( size={x:width,y:height} );
			trace("size: "+size );
/*		
		var svgParent = getTypedParent( Group );
		if( svgParent!=null ) svgParent.appendChild( getElement() );
		*/
	}
}
