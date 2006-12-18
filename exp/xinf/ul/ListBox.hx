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

import xinf.ul.Pane;
import xinf.ul.VScrollbar;
import xinf.ul.Label;
import xinf.ul.ListModel;

import xinf.erno.Color;
import xinf.erno.Renderer;
import xinf.event.Event;

import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.ScrollEvent;
import xinf.event.SimpleEvent;

/**
    Improvised ListBox element.
    
    TODO: currently, all child labels are reassigned. that could be optimized
    to reassign only the ones that need to be, and move the rest.
**/

class ListBox<T> extends Widget {
	
    private var scrollbar:VScrollbar;
    private var labels:Array<Label>;
    private var scrollPane:Pane;
    private var model:ListModel<T>;
    
    private var offset:Float;
    private var cursor:Int;
    private var lastCursorItem:Label;
    private static var rowH:Int = 20;
    private static var rowPad:Int = 1;
    
    public function new( _model:ListModel<T> ) :Void {
        super();
        
        offset = 0;
		cursor = -1;
		lastCursorItem = null;
        labels = new Array<Label>();
        
        scrollPane = new Pane();
        scrollPane.addEventListener( MouseEvent.MOUSE_DOWN, entryClicked );
		attach( scrollPane );
		
        scrollbar = new xinf.ul.VScrollbar();
        scrollbar.addEventListener( ScrollEvent.SCROLL_TO, scroll );
//		scrollbar.visible=false;
		attach( scrollbar );

		setModel(_model);

        assureChildren( Math.ceil((size.y/ rowH) + 1) );
		select(0);
		
        addEventListener( ScrollEvent.SCROLL_STEP, scrollStep );
        addEventListener( ScrollEvent.SCROLL_LEAP, scrollLeap );
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
    }
	
	public function resize( x:Float, y:Float ) :Void {
		super.resize(x,y);
		reLayout( null );
	}

	public function drawContents( g:Renderer ) :Void {
		reLayout(null);
		super.drawContents(g);
	}
	
	public function setModel( _model:ListModel<T> ) :Void {
        model = _model;
        model.addChangedListener( reDo );
		cursor=0;
		reDo(null);
		sendPickEvent();
	}
	
    private function reLayout( e:SimpleEvent ) :Void {
        assureChildren( Math.ceil((size.y/ rowH) + 1) );
        
        // set children sizes
        var w:Float = size.x;
        for( child in labels ) {
            child.resize( w, rowH-(2*rowPad) );
        }
		
		scrollbar.moveTo( size.x-scrollbar.size.x, 0 );
		scrollPane.crop = true;
		scrollPane.resize( size.x, size.y );
        
        // hide/show the scrollbar
		scrollbar.resize( scrollbar.size.x, size.y );
        if( (model.getLength() * rowH) > size.y ) {
			//scrollbar.bounds.setPosition( bounds.width-scrollbar.bounds.width-1, 1 );
			//scrollbar.visible=true;
        } else {
			//scrollbar.visible=false;
        }

        reDo(e);
    }
    
    private function reDo<T>( e:Event<T> ) :Void {
        var index = Math.floor(offset/rowH);
        var max = model.getLength();
        var y = (index*rowH)-offset;
        
        for( child in labels ) {
            if( index >= max ) {
                child.text = "";
            } else {
                child.text = model.getNameAt(index);
            }
            child.moveTo( 0, y+rowPad );
			child.scheduleRedraw();
			y+=rowH;
            index++;
        }
    }
    
    private function assureChildren( n:Int ) :Void {
        if( labels.length < n ) {
            // add labels
            for( i in 0...(n - labels.length) ) {
                var child = new Label();
				child.resize( size.x, rowH );
				scrollPane.attach( child );
                labels.push( child );
            }
        } else if( labels.length > n ) {
            // remove labels: TODO
        }
    }
    
    private function scroll( e:ScrollEvent ) :Void {
        offset = Math.round(((model.getLength() * rowH) - scrollPane.size.y) * e.value);
        reDo(null);
		select(cursor);
    }

    private function scrollStep( e:ScrollEvent ) :Void {
        var factor = e.value;
        scrollBy( 3 * factor * rowH );
		select(cursor);
    }

    private function scrollLeap( e:ScrollEvent ) :Void {
        var factor = e.value;
        scrollBy( size.y * factor );
		select(cursor);
    }
    
    private function scrollBy( pixels:Float ) :Void {
        offset += pixels;
        if( offset < 0 ) offset = 0;
        if( offset > ((model.getLength() * rowH) - scrollPane.size.y ) )
            offset = ((model.getLength() * rowH) - scrollPane.size.y );
            
        scrollbar.setScrollPosition( offset / ((model.getLength() * rowH) - size.y) );
            
        reDo(null);
    }

	private function findItem( index:Int ) :Label {
		var first = Math.floor(offset/rowH);
		return( labels[ cursor-first ] );
	}

	public function assureVisible( index:Int ) :Void {
		var first = Math.floor(offset/rowH);
		var sz = Math.floor(scrollPane.size.y / rowH);
		var l = (first+sz)-1;
		var ofs = offset % rowH;
		if( index < first ) {
			scrollBy( ((index-first)*rowH)-ofs );
		} else if( index > l ) {
			scrollBy( ((l-index)*-rowH)-ofs );
		}
	}

	public function select( index:Int ) :Void {
		if( lastCursorItem!=null ) {
			lastCursorItem.removeStyleClass( ":cursor" );
		}
	
		cursor = index;
		if( cursor > model.getLength()-1 ) cursor = model.getLength()-1;
		if( cursor < 0 ) cursor=0;

		var item = findItem( cursor );
		if( item != null )
			item.addStyleClass( ":cursor" );
		lastCursorItem = item;
	}

	private function entryClicked( e:MouseEvent ) :Void {
        var y = globalToLocal( { x:e.x, y:e.y }).y;
        var i:Int = Math.floor((y+offset)/rowH);
		select( i );
		sendPickEvent();
    }
	
	private function sendPickEvent() :Void {
		postEvent( new PickEvent<T>( PickEvent.ITEM_PICKED, model.getItemAt(cursor), cursor ) );
	}
	
	public function getCurrentItem() :T {
		return model.getItemAt(cursor);
	}

	public function onKeyDown( e:KeyboardEvent ) {
		switch( e.key ) {
			case "up":
				assureVisible( cursor-1 );
				select( cursor-1 );
			case "down":
				assureVisible( cursor+1 );
				select( cursor+1 );
			case "page up":
				var i=cursor-Math.round(scrollPane.size.y/rowH);
				assureVisible( i );
				select( i );
			case "page down":
				var i=cursor+Math.round(scrollPane.size.y/rowH);
				assureVisible( i );
				select( i );
			case "space":
				sendPickEvent();
		}
	}
	
}
