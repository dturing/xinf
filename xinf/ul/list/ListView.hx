/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ul.list;

import Xinf;

import xinf.ul.widget.Widget;
import xinf.ul.widget.VScrollbar;
import xinf.ul.model.ListModel;
import xinf.ul.model.ISettable;
import xinf.ul.layout.Helper;

import xinf.erno.Paint;

class ListView<T> extends Widget {

    var model:ListModel<T>;
    var rr:RoundRobin<T,ISettable<T>>;
    
    var cursor:Rectangle;
    var cropper:Crop;
    var scrollbar:VScrollbar;
    
    var cursorPosition:Int;
    var lastCursorItem:ISettable<T>;
	var itemStyle:ElementStyle;
    
    public function new( model:ListModel<T>, ?createItem:Void->ISettable<T> ) :Void {
		itemStyle = new ElementStyle();
		
        super();
        this.model = model;
        if( createItem==null ) {
            //createItem = function() :ISettable<T> {
                //return new xinf.ul.list.ListItem<T>();
            //}
        }

        cropper = new Crop();
        group.attach(cropper);

        rr = new RoundRobin<T,ISettable<T>>( model, createItem, itemStyle, style );
        cropper.attach( rr );

        cursor = new Rectangle();
		cursor.width = 8; cursor.height = 18;
		cursor.x = 0; cursor.y = -100;
		cursor.style.fill = SolidColor(0,.5,0,.5);
        cropper.attach( cursor );

        scrollbar = new VScrollbar();
        scrollbar.addEventListener( ScrollEvent.SCROLL_TO, scroll );
//        scrollbar.visible=false;
        attach( scrollbar );

        group.addEventListener( MouseEvent.MOUSE_DOWN, entryClicked );
        scrollbar.addEventListener( ScrollEvent.SCROLL_STEP, scrollStep );
        scrollbar.addEventListener( ScrollEvent.SCROLL_LEAP, scrollLeap );
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        
        setCursor(-2);
    }
    
    override public function set_size( s:TPoint ) :TPoint {
        super.set_size( s );

        scrollbar.position = {  x:size.x-scrollbar.size.x, y:0. };
        scrollbar.size = { x:scrollbar.size.x, y:size.y };
    
		cursor.width = s.x;
	
        var rrs = Helper.removePadding( size, style );
		rrs.x -= scrollbar.size.x;
        cropper.width = rrs.x;
		cropper.height = rrs.y;

        var itl = Helper.innerTopLeft( style );
		cropper.transform = new Translate( itl.x, itl.y );
        rr.resize( rrs.x, rrs.y );
		
		return size;
    }

	override public function styleChanged() :Void {
		super.styleChanged();
		
		itemStyle.fontSize = style.fontSize;
		itemStyle.fontFamily = style.fontFamily;
		//FIXME textColor breaks
		itemStyle.fill = SolidColor(.5,.5,.5,.5);//style.textColor.toSolidColor();
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
        var y = cropper.globalToLocal( { x:1.*e.x, y:1.*e.y }).y;
        var i = rr.indexAt( y );
        setCursor( i );
        pick( i, e.ctrlMod, e.shiftMod );
    //    setCursor( i ); // hmmm FIXME
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
            case "space":
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

//        trace("cursor @"+cursorPosition+" ==> "+rr.positionOf( cursorPosition ) );
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
        setCursor(i);
    }
    
    public function getCurrentItem() :T {
        return model.getItemAt(cursorPosition);
    }
    
    public function setModel( m:ListModel<T> ) :Void {
        rr.setModel(m);
    }
}
