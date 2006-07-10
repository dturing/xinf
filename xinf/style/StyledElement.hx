/* 
   xinf is not flash.
   Copyr (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.style;

import xinf.ony.Pane;
import xinf.ony.Element;
import xinf.event.Event;
import xinf.ony.Color;
import xinf.ony.Image;

import xinf.style.Style;
import xinf.ony.SimpleEvent;
import xinf.ony.GeometryEvent;

/**
	StyledElement
**/

class StyledElement extends Pane {
    private var child:Element;
	private var style:Style;
    
	private var skin:Skin;
	
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
		autoSize=true;
		addEventListener( SimpleEvent.STYLE_CHANGED, reallyApplyStyle );
    }
    
	public function applyStyle() :Void {
		postEvent( new SimpleEvent( SimpleEvent.STYLE_CHANGED, this ) );
	}
	
	private function reallyApplyStyle( e:SimpleEvent ) {
		if( style == null ) return;

		if( style.skin != null ) {
			if( skin == null ) skin = new Skin( this );
			skin.set( "assets/"+style.skin, 
				style.border.l, style.border.t, style.border.r, style.border.b ); // FIXME: always 2? neee.
		} else {
			if( skin != null )
				skin.reset();
		}
		
		setForegroundColor( style.color );
		setBackgroundColor( style.background );
		
		updateSize();
	}

    private function updateSize() {
		var pad:Sides<Float>;
		if( style!=null && style.padding!=null ) {
			pad = style.padding;
		} else {
			pad = { l:0, t:0, r:0, b:0 };
		}
		var w:Float;
		var h:Float;
		if( autoSize && child != null ) {
			w = child.bounds.width + pad.l + pad.r;
			h = child.bounds.height + pad.t + pad.b;
		} else {
			w = bounds.width;
			h = bounds.height;
		}
		
		if( style.minWidth != null && w < style.minWidth ) w=style.minWidth;

		if( skin != null ) skin.update( w, h );
				
		if( autoSize ) {
			bounds.setSize( w, h );
		}
		
		if( child != null ) {
			var l = style.textAlign * ((w-(pad.r+pad.l))-child.bounds.width);
			child.bounds.setPosition( l+pad.l, pad.t );
			if( !autoSize ) {
				child.bounds.setSize( w-(pad.l+pad.r), h-(pad.t+pad.b) );
				trace(""+this+" !autoSize: "+child.bounds);
			}
		}
    }
    
    override private function onSizeChanged( e:GeometryEvent ) :Void {
		// HACK, FIXME just for js' background. Element wont set size if autoSize=true
		// this prob should go away once we do styles natively on js..
		var o=autoSize;
		autoSize=false;
		super.onSizeChanged(e);
		autoSize=o;
		
        if( !autoSize ) {
            updateSize();
        }
    }

    public function childSizeChanged( e:GeometryEvent ) {
        if( autoSize ) {
            updateSize();
        }
    }
    
    public function setChild( e:Element ) :Void {
        // FIXME: unregister old handler
        child = e;
        child.bounds.addEventListener( GeometryEvent.SIZE_CHANGED, childSizeChanged );
        updateSize();
    }
	
	#if flash
	// FIXME 
    override public function setForegroundColor( fg:xinf.ony.Color ) :Void {
		super.setForegroundColor(fg);
		if( child!=null && Std.is( child, xinf.ony.Pane )) {
			var c:xinf.ony.Pane = cast(child,xinf.ony.Pane);
			c.setForegroundColor(fg);
		}
    }
	#end
}
