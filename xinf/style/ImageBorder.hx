package xinf.style;

import xinf.ony.Image;
import xinf.style.Style;

class ImageBorderStyle {
	public var width :Float;
	private var url:String;
	
	public function new( _width:Float, _url:String ) :Void {
		url=_url;
		width=_width;
	}
	
	public function make( e:xinf.ony.Element ) :Border {
		var i = new Image( "borderPart", e, url );
		return new ImageBorder(width,i);
	}
}

class ImageBorder implements Border {
	private var i:Image;
	public var width:Float;
	
	public function new( _width:Float, _i:Image ) {
		width = _width;
		i = _i;
		i.autoSize=false;
	}
	
	public function setLeft( x:Float, y:Float, h:Float ) {
		i.bounds.setPosition( x, y );
		i.bounds.setSize( width, h );
	}
	public function setRight( x:Float, y:Float, h:Float ) {
		i.bounds.setPosition( x, y );
		i.bounds.setSize( width, h );
	}
	public function setTop( x:Float, y:Float, w:Float ) {
		i.bounds.setPosition( x, y );
		i.bounds.setSize( w, width );
	}
	public function setBottom( x:Float, y:Float, w:Float ) {
		i.bounds.setPosition( x, y );
		i.bounds.setSize( w, width );
	}
	public function set( x:Float, y:Float ) {
		i.bounds.setPosition( x, y );
	}
	public function remove( e:xinf.ony.Element ) :Void {
		i.destroy();
		i=null;
	}
}
