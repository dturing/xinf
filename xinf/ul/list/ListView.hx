/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;

import xinf.ul.widget.Widget;
import xinf.ul.widget.VScrollbar;
import xinf.ul.model.ListModel;
import xinf.ul.model.ISettable;
import xinf.ul.layout.Helper;
import xinf.ony.type.Paint;

class ListView<T> extends Widget {

	var model:ListModel<T>;
	var rr:RoundRobin<T,ISettable<T>>;
	
	var rrgroup:Group;
	var cursor:Rectangle;
	var cropper:Crop;
	var scrollbar:VScrollbar;
	
	var cursorPosition:Int;
	var lastCursorItem:ISettable<T>;
	
	public function new( model:ListModel<T>, ?createItem:Null<Void->ISettable<T>> ) :Void {
		super();
		this.model = model;
		if( createItem==null ) {
			createItem = function() :ISettable<T> {
				return new xinf.ul.list.ListItem<T>();
			}
		}

		cropper = new Crop();
		group.appendChild(cropper);

		rrgroup = new Group();
		cropper.appendChild( rrgroup );

		cursor = new Rectangle({ y:-100 });
		cursor.addStyleClass("Cursor");
//		cursor.width = 8; cursor.height = 2;
//		cursor.x = 0; cursor.y = -100;
//		cursor.fill = focusColor;
		rrgroup.appendChild( cursor );
		
		rr = new RoundRobin<T,ISettable<T>>( model, createItem, this );
		rrgroup.appendChild( rr );

		scrollbar = new VScrollbar();
		scrollbar.addEventListener( ScrollEvent.SCROLL_TO, scroll );
//		scrollbar.visible=false;
		appendChild( scrollbar );

		group.addEventListener( MouseEvent.MOUSE_DOWN, entryClicked );
		group.addEventListener( ScrollEvent.SCROLL_STEP, scrollStep );
		scrollbar.addEventListener( ScrollEvent.SCROLL_LEAP, scrollLeap );
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		
		setCursor(-2);
	}

	override public function set_size( s:TPoint ) :TPoint {
		super.set_size( s );

		scrollbar.position = {  x:size.x-scrollbar.size.x, y:0. };
		scrollbar.size = { x:scrollbar.size.x, y:size.y };
	
		cursor.width = s.x-scrollbar.size.x;
		cursor.height = rr.lineIncrement;
		cursor.x = -padding.l;
	
		cropper.width = s.x-scrollbar.size.x;
		cropper.height = s.y-1;

		var rrs = Helper.removePadding( size, this );
		rrs.x -= scrollbar.size.x;
		var itl = Helper.innerTopLeft( this );
		rrgroup.transform = new Translate( itl.x, itl.y );
		rr.resize( rrs.x, rrs.y );
		
		return size;
	}
	
	function scrollBy( value:Float ) {
		rr.scrollBy( value );
		updateScrollbar();
		setCursor(cursorPosition);
	}

	function scroll( e:ScrollEvent ) :Void {
		rr.scrollToNormalized( e.value );
		setCursor(cursorPosition);
	}

	function scrollStep( e:ScrollEvent ) :Void {
		var factor = e.value;
		scrollBy( 1.5 * factor ); //* rowH );
	}

	function scrollLeap( e:ScrollEvent ) :Void {
		var factor = e.value;
		scrollBy( size.y * factor );
	}
	
	function entryClicked( e:MouseEvent ) :Void {
		var y = rrgroup.globalToLocal( { x:1.*e.x, y:1.*e.y }).y;
		var i = rr.indexAt( y );
		setCursor( i );
		pick( i, e.ctrlMod, e.shiftMod );
	}

	function pick( index:Int, ?add:Bool, ?extend:Bool ) :Void {
		postEvent( new PickEvent<T>( untyped PickEvent.ITEM_PICKED, model.getItemAt(index), cursorPosition, add, extend ) );
	}

	public function onKeyDown( e:KeyboardEvent ) {
	//trace("key: "+e+" "+e.shiftMod );
		switch( e.key ) {
			case "up":
				rr.assureVisible( cursorPosition-1 );
				setCursor( cursorPosition-1 );
				if( e.shiftMod ) pick( cursorPosition, false, true );
			case "down":
				rr.assureVisible( cursorPosition+1 );
				setCursor( cursorPosition+1 );
				if( e.shiftMod ) pick( cursorPosition, false, true );
			case "page up":
				var i=cursorPosition-rr.getPageSize();
				rr.assureVisible( i );
				setCursor( i );
				if( e.shiftMod ) pick( cursorPosition, false, true );
			case "page down":
				var i=cursorPosition+rr.getPageSize();
				rr.assureVisible( i );
				setCursor( i );
				if( e.shiftMod ) pick( cursorPosition, false, true );
			case " ":
				pick( cursorPosition, true );
				setCursor( cursorPosition );
		}
		updateScrollbar();
	}
	
	public function setCursor( index:Int ) :Void {
		if( lastCursorItem!=null ) {
			lastCursorItem.setCursor(false);
		}
		cursorPosition = index;
		
		if( cursorPosition==-2 ) return;
		if( cursorPosition >= model.getLength() ) cursorPosition = model.getLength()-1;
		if( cursorPosition < 0 ) cursorPosition=0;

//		trace("cursor @"+cursorPosition+" ==> "+rr.positionOf( cursorPosition ) );
		cursor.y = rr.positionOf( cursorPosition );

		var item = rr.getItem( cursorPosition );
		if( item != null ) item.setCursor(true);
		lastCursorItem = item;
	}
	
	public function updateScrollbar() :Void {
		scrollbar.setScrollPosition( rr.getPositionNormalized() );
	}
	
	public function assureVisible( i:Int ) :Void {
		rr.assureVisible(i);
		setCursor(cursorPosition);
		updateScrollbar();
	}
	
	public function getCurrentItem() :T {
		return model.getItemAt(cursorPosition);
	}
	
	public function setModel( m:ListModel<T> ) :Void {
		rr.setModel(m);
	}
}
