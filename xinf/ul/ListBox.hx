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

import xinf.event.Event;
import xinf.ony.Pane;
import xinf.ony.Element;
import xinf.ony.Color;
import xinf.ul.VScrollbar;
import xinf.ul.Label;
import xinf.ul.ListModel;

import xinf.ony.MouseEvent;
import xinf.ony.KeyboardEvent;
import xinf.ony.ScrollEvent;
import xinf.ony.GeometryEvent;

class PickEvent extends Event<PickEvent> {
	static public var ITEM_PICKED = new xinf.event.EventKind<PickEvent>("itemPicked");

	public var index:Int;
	
	public function new( _type:xinf.event.EventKind<PickEvent>, target:xinf.event.EventDispatcher, index:Int ) {
		super(_type,target);
		this.index = index;
	}
}


/**
    Improvised ListBox element.
    
    TODO: currently, all child labels are reassigned. that could be optimized
    to reassign only the ones that need to be, and move the rest.
**/

class ListBox extends Widget {
    private var scrollbar:VScrollbar;
    private var children:Array<Label>;
    private var scrollPane:Pane;
    private var model:ListModel;
    
    private var offset:Float;
    private var cursor:Int;
    private var lastCursorItem:Label;
    private static var rowH:Int = 20;
    private static var rowPad:Int = 1;
    
    public function new( name:String, parent:Element, _model:ListModel ) :Void {
        super( name, parent );
        
		autoSize = false;
		
        offset = 0;
		cursor = -1;
		lastCursorItem = null;
        children = new Array<Label>();
        bounds.addEventListener( GeometryEvent.SIZE_CHANGED, reLayout ); 
        setBackgroundColor( new Color().fromRGBInt( 0xffffff ) );
        
        scrollPane = new Pane( name+"_pane", this );
        scrollPane.crop = true;

        scrollbar = new xinf.ul.VScrollbar( name+"_scroll", this );
        scrollbar.addEventListener( ScrollEvent.SCROLL_TO, scroll );
		scrollbar.visible=false;

        model = _model;
        model.addChangedListener( reDo );
                
        addEventListener( ScrollEvent.SCROLL_STEP, scrollStep );
        addEventListener( ScrollEvent.SCROLL_LEAP, scrollLeap );
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );

        scrollPane.addEventListener( MouseEvent.MOUSE_DOWN, entryClicked );

		setChild( scrollPane );
		scrollbar.visible=false;

		reLayout( null );
		select(0);
    }

    private function reLayout( e:GeometryEvent ) :Void {
        assureChildren( Math.ceil((bounds.height / rowH) + 1) );
        
        // set children sizes
        var w:Float = bounds.width;
        for( child in children ) {
            child.bounds.setSize( w, rowH-(2*rowPad) );
        }
        
        // hide/show the scrollbar
        if( (model.getLength() * rowH) > bounds.height ) {
            scrollbar.bounds.setPosition( bounds.width-scrollbar.bounds.width-1, 1 );
			scrollbar.visible=true;
        } else {
			scrollbar.visible=false;
        }

        reDo(e);
    }
    
    private function reDo<T>( e:Event<T> ) :Void {
        var index = Math.floor(offset/rowH);
        var max = model.getLength();
        var y = (index*rowH)-offset;
        
        for( child in children ) {
            if( index >= max ) {
                child.text = "";
            } else {
                child.text = model.getItemAt(index);
            }
            child.bounds.setPosition( 0, y+rowPad );
            y+=rowH;
            index++;
        }
    }
    
    private function assureChildren( n:Int ) :Void {
        if( children.length < n ) {
            // add labels
            for( i in 0...(n - children.length) ) {
                var child = new Label( name+"_"+children.length, scrollPane );
                child.autoSize = false;
                children.push( child );
            }
        } else if( children.length > n ) {
            // remove labels: TODO
        }
    }
    
    private function scroll( e:ScrollEvent ) :Void {
        offset = ((model.getLength() * rowH) - scrollPane.bounds.height) * e.value;
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
        scrollBy( bounds.height * factor );
		select(cursor);
    }
    
    private function scrollBy( pixels:Float ) :Void {
        offset += pixels;
        if( offset < 0 ) offset = 0;
        if( offset > ((model.getLength() * rowH) - scrollPane.bounds.height) )
            offset = ((model.getLength() * rowH) - scrollPane.bounds.height);
            
        scrollbar.setScrollPosition( offset / ((model.getLength() * rowH) - bounds.height) );
            
        reDo(null);
    }

	private function findItem( index:Int ) :Label {
		var first = Math.floor(offset/rowH);
		return( children[ cursor-first ] );
	}

	public function assureVisible( index:Int ) :Void {
		var first = Math.floor(offset/rowH);
		var sz = Math.floor(scrollPane.bounds.height / rowH);
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
        var y = globalToLocal( new xinf.geom.Point(e.x, e.y) ).y;
        var i:Int = Math.floor((y+offset)/rowH);
		select( i );
		postEvent( new PickEvent( PickEvent.ITEM_PICKED, this, cursor ) );
    }

	public function onKeyDown( e:KeyboardEvent ) {
		if( e.target != null ) return;
		switch( e.key ) {
			case "up":
				assureVisible( cursor-1 );
				select( cursor-1 );
			case "down":
				assureVisible( cursor+1 );
				select( cursor+1 );
			case "page up":
				var i=cursor-Math.round(scrollPane.bounds.height/rowH);
				assureVisible( i );
				select( i );
			case "page down":
				var i=cursor+Math.round(scrollPane.bounds.height/rowH);
				assureVisible( i );
				select( i );
			case "space":
				postEvent( new PickEvent( PickEvent.ITEM_PICKED, this, cursor ) );
		}
	}
}
