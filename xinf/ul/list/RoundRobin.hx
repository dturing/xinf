/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;
import xinf.ul.model.ListModel;
import xinf.ul.model.ISettable;
import xinf.ul.layout.Helper;
import xinf.ul.Component;
import xinf.ony.traits.LineIncrementTrait;

/*
	TODO: when height is not an exact multiple of lineIncrement,
	scroll better.
*/

/*
	  i   rr
	 _
	| 0 _   ___ rrstart, 1: rr start index
   _| 1 _ 3
  | | 2 _ 4 ___ rrofs, 2: rr offset
  | | 3 _ 0 
  | | 4 _ 1
  |_| 5 _ 2
	|_6   

  n:5
*/

/**
	RoundRobin maintains a short list of Items (which must implement ISettable<T>) 
	to display a long list of values (of type T).
**/

class RoundRobin<T,Item:ISettable<T>> extends Group {

	static var tagName = "RoundRobin";

	static var TRAITS = {
		lineincrement:new LineIncrementTrait(),
	}

	public var lineIncrement(get_line_increment,set_line_increment):Float;
	function get_line_increment() :Float { 
		var r:Float = getStyleTrait("lineincrement",Float);
		if( r==-1 ) // auto
			r = fontSize*1.1;
		return r; 
	}
	function set_line_increment( v:Float ) :Float { setStyleTrait("lineincrement",v); redraw(); return v; }

	var model:ListModel<T>;
	var createItem:Void->Item;

	var n:Int;			  // number of slots
	var rr:Array<Item>;	 // the round-robin array
	var rrofs:Int;
	var rrstart:Int;
	
	var height:Float; // pixel height of display crop
	var width:Float; // pixel width of display crop
	
	var cOffset:Float;	  // current negative offset in rows
	var umod:Float;			// crop height % lineIncrement
	
	var component:Component; // reference component (for padding)
	
	public function new( model:ListModel<T>, createItem:Void->Item, c:Component ) :Void {
		super();
		
		this.model = model;
		this.createItem = createItem;
		
		n = 0;
		rr = new Array<Item>();
		rrofs = 0;
		rrstart = 0;
		
		component = c;
		cOffset = 0;
		
		// not quite clear why, but this is needed for lineIncrement to be right for Dropdown...
		updateClassStyle();
	}

	public function resize( x:Float, y:Float ) :Void {
		width=x; height=y;
		setup( x, y );
	}
	
	override public function styleChanged( ?a:String ) {
		super.styleChanged(a);
		redoAll();
	}

	function setup( w:Float, total:Float ) :Void {
		umod = 2-((total % lineIncrement)/lineIncrement);
		
		// adjust n.
		var n = Math.ceil( total/lineIncrement )+1;
		if( n != this.n ) {
			for( i in this.n...n ) {
				var item = createItem();
				item.attachTo(this);
				rr.push( item );
			}
			// TODO: remove superfluous items in rr
			
			this.n = n;
		}
		
		for( item in rr ) {
			item.resize( w, lineIncrement );
		}
		
		redoAll();
	}

	public function redoAll() :Void {
		rrstart = Math.floor( cOffset ); // FIXME: spare
		rrofs = 0;
		
		var pos = rrstart*lineIncrement;
		var i = rrstart;
		var j = 0;
		for( item in rr ) {
			item.moveTo( 0, pos );
			var value = if( i>=model.getLength() ) null else model.getItemAt(i);
			item.set( value );
			i++;
			pos+=lineIncrement;
		}
	}
	
	function shiftDown() :Void {
		var item = rr[rrofs];
		item.moveTo( 0, ((rrstart+n)*lineIncrement) );
		item.set( model.getItemAt(rrstart+n) );
		
		rrstart++;
		rrofs=(rrofs+1)%n;
	}

	function shiftUp() :Void {
		rrstart--;
		rrofs=(rrofs-1);
		if( rrofs<0 ) rrofs+=n;
		
		var item = rr[rrofs];
		item.moveTo( 0, (rrstart)*lineIncrement );
		item.set( model.getItemAt(rrstart) );
	}

	public function scrollTo( offset:Float ) :Void {
		cOffset = offset;
		var s = cOffset*lineIncrement;
		//if( s>height ) s=height;
		//trace("scroll "+s+", h "+height );
		transform = new Translate( 0, -s );
		redoAll();
	}
	
	public function scrollToNormalized( offset:Float ) :Void {
		scrollBy( (offset * (model.getLength()-(n-umod))) - cOffset );
	}

	public function assureVisible( index:Int ) :Void {
		var l = cOffset+n-umod;
		if( index < cOffset ) {
			scrollBy( index-cOffset );
		} else if( index >= l-1 ) {
			scrollBy( (index-l)+1 );
		}
		//var ofs = Math.max( 0, Math.min( (model.getLength()-(n-umod)), cOffset ) );
		//if( ofs != cOffset ) scrollBy( cOffset-ofs );
	}

	public function scrollBy( offset:Float ) :Void {
		var ofs = cOffset+offset;
		ofs = Math.max( 0, Math.min( (model.getLength()-(n-umod)), ofs ) );

			scrollTo( ofs );
		return; // FIXME
		if( offset >= n ) {
			scrollTo( ofs );
		} else {
			// some items will remain the same. do the robin.
			cOffset = ofs;
			transform = new Translate( 0, -(cOffset*lineIncrement) ); 
			while( (rrstart+1) < ofs ) {
				shiftDown();
			}
			while( rrstart > ofs ) {
				shiftUp();
			}
		}
	}

	public function getPositionNormalized() :Float {
		return( cOffset / (model.getLength()-(n-umod)) );
	}
	
	public function getPageSize() :Int {
		return( n-1 );
	}

	public function allVisible() :Bool {
		return( n > model.getLength() );
	}

	public function getItem( index:Int ) :Item {
		var i = Math.floor( index-rrstart );
		if( i<0 || i>=n ) return null;
		return( rr[ (i+rrofs)%n ] );
	}
	
	public function indexAt( offset:Float ) :Int {
		return Math.floor( (offset/lineIncrement)+cOffset );
	}

	public function positionOf( index:Int ) :Float {
		return( (index-cOffset)*lineIncrement );
	}

	public function setModel( m:ListModel<T> ) :Void {
		model = m;
		redoAll();
	}
}
