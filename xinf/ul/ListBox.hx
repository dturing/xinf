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
import xinf.ony.ScrollEvent;
import xinf.ony.GeometryEvent;

/**
    Improvised ListBox element.
    
    TODO: currently, all child labels are reassigned. that could be optimized
    to reassign only the ones that need to be, and move the rest.
**/

class ListBox extends xinf.style.StyleClassElement {
    private var scrollbar:VScrollbar;
    private var children:Array<Label>;
    private var scrollPane:Pane;
    private var model:ListModel;
    
    private var offset:Float;
    
    private static var labelHeight:Int = 20;
    
    public function new( name:String, parent:Element, _model:ListModel ) :Void {
        super( name, parent );
        
		autoSize = false;
		
        offset = 0;
        children = new Array<Label>();
        bounds.addEventListener( GeometryEvent.SIZE_CHANGED, reLayout ); 
        setBackgroundColor( new Color().fromRGBInt( 0xffffff ) );
        
        scrollPane = new Pane( name+"_pane", this );
        scrollPane.crop = true;
//		scrollPane.bounds.setPosition( 2, 2 );

        scrollbar = new xinf.ul.VScrollbar( name+"_scroll", this );
        scrollbar.addEventListener( ScrollEvent.SCROLL_TO, scroll );

        model = _model;
        model.addChangedListener( reDo );
                
        addEventListener( ScrollEvent.SCROLL_STEP, scrollStep );
        addEventListener( ScrollEvent.SCROLL_LEAP, scrollLeap );

        scrollPane.addEventListener( MouseEvent.MOUSE_DOWN, entryClicked );

		setChild( scrollPane );
                
        reLayout( null );
    }

    private function reLayout( e:GeometryEvent ) :Void {
        assureChildren( Math.ceil((bounds.height / labelHeight) + 1) );
        
        // set children sizes
        var w:Float = bounds.width;
        for( child in children ) {
            child.bounds.setSize( w, labelHeight-2 );
        }
        
        // hide/show the scrollbar
        if( (model.getLength() * labelHeight) > bounds.height ) {
       //     scrollPane.bounds.setSize( bounds.width-scrollbar.bounds.width, bounds.height );
            scrollbar.bounds.setPosition( bounds.width-scrollbar.bounds.width-1, 1 );
        } else {
       //     scrollPane.bounds.setSize( bounds.width, bounds.height );
            scrollbar.bounds.setPosition( bounds.width, 100 );
        }

        reDo(e);
    }
    
    private function reDo<T>( e:Event<T> ) :Void {
        var index = Math.floor(offset/labelHeight);
        var max = model.getLength();
        var y = (index*labelHeight)-offset;
        
        for( child in children ) {
            if( index >= max ) {
                child.text = "";
            } else {
                child.text = model.getItemAt(index);
            }
            child.bounds.setPosition( 0, y );
            y+=labelHeight;
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
        offset = ((model.getLength() * labelHeight) - bounds.height) * e.value;
        reDo(null);
    }

    private function scrollStep( e:ScrollEvent ) :Void {
        var factor = e.value;
        scrollBy( 3 * factor * labelHeight );
    }

    private function scrollLeap( e:ScrollEvent ) :Void {
        var factor = e.value;
        scrollBy( bounds.height * factor );
    }
    
    private function scrollBy( pixsels:Float ) :Void {
        offset += pixsels;
        if( offset < 0 ) offset = 0;
        if( offset > ((model.getLength() * labelHeight) - scrollPane.bounds.height) )
            offset = ((model.getLength() * labelHeight) - scrollPane.bounds.height);
            
        scrollbar.setScrollPosition( offset / ((model.getLength() * labelHeight) - bounds.height) );
            
        reDo(null);
    }

    private function entryClicked( e:MouseEvent ) :Void {
        var y = globalToLocal( new xinf.geom.Point(e.x, e.y) ).y;
        var i:Int = Math.floor((y+offset)/labelHeight);
		trace("Item Picked: "+i+", no event (yet) FIXME");
   // FIXME     postEvent( Event.ITEM_PICKED, { index:i } );
    }
    
}
