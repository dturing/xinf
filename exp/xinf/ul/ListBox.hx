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

package xinf.ul;

import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.ScrollEvent;
import xinf.event.SimpleEvent;

import xinf.ul.RoundRobin;

class ListItem<T> extends Label, implements Settable<T> {
    var value:T;
    
    public function new( ?value:T ) :Void {
        super( ""+value );
        this.value = value;
    }
    
    public function set( ?value:T ) :Void {
        this.value = value;
        this.text = if( value==null ) "" else ""+value;
    }
    
    public function attachTo( parent:xinf.ony.Container<xinf.ony.Object> ) :Void {
        parent.attach(this);
    }
}

class ListBox<T> extends Widget {
    var model:ListModel<T>;
    var rr:RoundRobin<T,Settable<T>>;
    var scrollbar:VScrollbar;
    var cursor:Int;
    var lastCursorItem:Settable<T>;
    
    public function new( model:ListModel<T>, ?createItem:Void->Settable<T> ) :Void {
        super();
        this.model = model;
        crop=true;
        
        if( createItem==null ) {
            createItem = function() :Settable<T> {
                return new ListItem<T>();
            }
        }

        rr = new RoundRobin<T,Settable<T>>( model, createItem );
        attach( rr );

        scrollbar = new xinf.ul.VScrollbar();
        scrollbar.addEventListener( ScrollEvent.SCROLL_TO, scroll );
//        scrollbar.visible=false;
        attach( scrollbar );

        addEventListener( MouseEvent.MOUSE_DOWN, entryClicked );
        addEventListener( ScrollEvent.SCROLL_STEP, scrollStep );
        addEventListener( ScrollEvent.SCROLL_LEAP, scrollLeap );
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        
        setCursor(-2);
    }
    
    override public function resize( x:Float, y:Float ) :Void {
        super.resize( x, y );

        scrollbar.moveTo( size.x-scrollbar.size.x, 0 );
        scrollbar.resize( scrollbar.size.x, size.y );
    
        // FIXME: border, padding?
        rr.resize( size.x-scrollbar.size.x, innerSize.y );
    }

    function scrollBy( value:Float ) {
        rr.scrollBy( value );
        updateScrollbar();
        setCursor(cursor);
    }

    function scroll( e:ScrollEvent ) :Void {
        rr.scrollToNormalized( e.value );
        setCursor(cursor);
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
        var y = globalToLocal( { x:e.x, y:e.y }).y;
        var i = rr.indexAt( y );
        setCursor( i );
        sendPickEvent();
    }

    function sendPickEvent() :Void {
        postEvent( new PickEvent<T>( PickEvent.ITEM_PICKED, model.getItemAt(cursor), cursor ) );
    }

    public function onKeyDown( e:KeyboardEvent ) {
        switch( e.key ) {
            case "up":
                rr.assureVisible( cursor-1 );
                setCursor( cursor-1 );
            case "down":
                rr.assureVisible( cursor+1 );
                setCursor( cursor+1 );
            case "page up":
                var i=cursor-rr.getPageSize();
                rr.assureVisible( i );
                setCursor( i );
            case "page down":
                var i=cursor+rr.getPageSize();
                rr.assureVisible( i );
                setCursor( i );
            case "space":
                sendPickEvent();
        }
        updateScrollbar();
    }
    
    public function setCursor( index:Int ) :Void {
        if( lastCursorItem!=null ) {
            lastCursorItem.removeStyleClass( ":cursor" );
        }
        cursor = index;
        if( cursor==-2 ) return;
        if( cursor >= model.getLength() ) cursor = model.getLength()-1;
        if( cursor < 0 ) cursor=0;

        var item = rr.getItem( cursor );
        if( item != null ) item.addStyleClass(":cursor");
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
        return model.getItemAt(cursor);
    }
    
    public function setModel( m:ListModel<T> ) :Void {
        rr.setModel(m);
    }
}
