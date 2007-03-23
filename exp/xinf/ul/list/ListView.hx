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

import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.ScrollEvent;
import xinf.event.SimpleEvent;

import xinf.ul.Widget;
import xinf.ul.Crop;
import xinf.ul.VScrollbar;
import xinf.ul.model.ListModel;
import xinf.ul.model.ISettable;

class ListView<T> extends Widget {

    var model:ListModel<T>;
    var rr:RoundRobin<T,ISettable<T>>;
    
    var cropper:Crop;
    var scrollbar:VScrollbar;
    
    var cursor:Int;
    var lastCursorItem:ISettable<T>;
    
    public function new( model:ListModel<T>, ?createItem:Void->ISettable<T> ) :Void {
        super();
        this.model = model;
        if( createItem==null ) {
            createItem = function() :ISettable<T> {
                return new ListItem<T>();
            }
        }

        cropper = new Crop();
        attach(cropper);
        
        rr = new RoundRobin<T,ISettable<T>>( model, createItem );
        cropper.attach( rr );

        scrollbar = new xinf.ul.VScrollbar();
        scrollbar.addStyleClass("Scrollbar");
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
    
        var rrs = removePadding( size );
        cropper.resize( rrs.x, rrs.y );
        cropper.moveTo( style.padding.l+style.border.l, style.padding.t+style.border.t ); //FIXME
        rr.resize( rrs.x, rrs.y );
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
        var y = cropper.globalToLocal( { x:1.*e.x, y:1.*e.y }).y;
        var i = rr.indexAt( y );
        setCursor( i );
        pick( i, e.ctrlMod, e.shiftMod );
        setCursor( i ); // hmmm FIXME
    }

    function pick( index:Int, ?add:Bool, ?extend:Bool ) :Void {
        postEvent( new PickEvent<T>( PickEvent.ITEM_PICKED, model.getItemAt(index), cursor, add, extend ) );
    }

    public function onKeyDown( e:KeyboardEvent ) {
    //trace("key: "+e+" "+e.shiftMod );
        switch( e.key ) {
            case "up":
                rr.assureVisible( cursor-1 );
                setCursor( cursor-1 );
                if( e.shiftMod ) pick( cursor, false, true );
            case "down":
                rr.assureVisible( cursor+1 );
                setCursor( cursor+1 );
                if( e.shiftMod ) pick( cursor, false, true );
            case "page up":
                var i=cursor-rr.getPageSize();
                rr.assureVisible( i );
                setCursor( i );
                if( e.shiftMod ) pick( cursor, false, true );
            case "page down":
                var i=cursor+rr.getPageSize();
                rr.assureVisible( i );
                setCursor( i );
                if( e.shiftMod ) pick( cursor, false, true );
            case "space":
                pick( cursor, true );
                setCursor( cursor );
        }
        updateScrollbar();
    }
    
    public function setCursor( index:Int ) :Void {
        if( lastCursorItem!=null ) {
            lastCursorItem.setCursor(false);
        }
        cursor = index;
        if( cursor==-2 ) return;
        if( cursor >= model.getLength() ) cursor = model.getLength()-1;
        if( cursor < 0 ) cursor=0;

        var item = rr.getItem( cursor );
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
        return model.getItemAt(cursor);
    }
    
    public function setModel( m:ListModel<T> ) :Void {
        rr.setModel(m);
    }
}
