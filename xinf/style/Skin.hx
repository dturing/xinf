package xinf.style;

import xinf.ony.Image;
import xinf.style.Style;

signature SidesAndCorners<T> {
	var l:T;
	var t:T;
	var r:T;
	var b:T;
	var tl:T;
	var tr:T;
	var bl:T;
	var br:T;
}

class Skin {
	private var images:SidesAndCorners<Image>;
	private var border:Sides<Float>;
	private var target:xinf.ony.Element;
	
	public function new( _target:xinf.ony.Element ) :Void {
		target=_target;
		images = {
			l: new Image( "skin_l", target ),
			t: new Image( "skin_t", target ),
			r: new Image( "skin_r", target ),
			b: new Image( "skin_b", target ),
			tl: new Image( "skin_tl", target ),
			tr: new Image( "skin_tr", target ),
			bl: new Image( "skin_bl", target ),
			br: new Image( "skin_br", target )
		};
		images.l.autoSize = images.t.autoSize = 
		images.r.autoSize = images.b.autoSize = 
		images.tl.autoSize = images.tr.autoSize = 
		images.bl.autoSize = images.br.autoSize = 
		false;
		border = { l:0, t:0, r:0, b:0 };
	}
	
	public function set( name:String, l:Float, ?t:Float, ?r:Float, ?b:Float ) :Void {
		if( t==null ) t=l;
		if( r==null ) r=l;
		if( b==null ) b=t;
		border = { l:l, t:t, r:r, b:b };

		if( border.l!=0 ) images.l.load( name+"l.png" );
		if( border.t!=0 ) images.t.load( name+"t.png" );
		if( border.r!=0 ) images.r.load( name+"r.png" );
		if( border.b!=0 ) images.b.load( name+"b.png" );
		if( border.t!=0 && border.l!=0 ) images.tl.load( name+"tl.png" );
		if( border.t!=0 && border.r!=0 ) images.tr.load( name+"tr.png" );
		if( border.b!=0 && border.l!=0 ) images.bl.load( name+"bl.png" );
		if( border.b!=0 && border.r!=0 ) images.br.load( name+"br.png" );
	}
	
	public function reset() :Void {
		border = { l:0, t:0, r:0, b:0 };
	}
	
	public function update( w:Float, h:Float ) :Void {
		var x=w-border.r;
		var y=h-border.b;
		images.l.bounds.setPosition( 0, border.t );
		images.t.bounds.setPosition( border.l, 0 );
		images.r.bounds.setPosition( x, border.t );
		images.b.bounds.setPosition( border.l, y );
		
		images.tl.bounds.setPosition(0,0);
		images.tr.bounds.setPosition(x,0);
		images.bl.bounds.setPosition(0,y);
		images.br.bounds.setPosition(x,y);
		images.tl.bounds.setSize( border.l, border.t );
		images.tr.bounds.setSize( border.r, border.t );
		images.bl.bounds.setSize( border.l, border.b );
		images.br.bounds.setSize( border.r, border.b );

		x-=border.l;
		y-=border.t;
		images.l.bounds.setSize( border.l, y );
		images.t.bounds.setSize( x, border.t );
		images.r.bounds.setSize( border.r, y );
		images.b.bounds.setSize( x, border.b );
	}
}