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
		skin = new Skin( this );
		addEventListener( xinf.event.Event.STYLE_CHANGED, reallyApplyStyle );
    }
    
	public function applyStyle() :Void {
		postEvent( xinf.event.Event.STYLE_CHANGED, null );
	}
	
	private function reallyApplyStyle( e:xinf.event.Event ) {
		if( style == null ) return;
		
		if( style.skin != null ) {
			skin.set( "assets/"+style.skin, 2 ); // FIXME: always 2? neee.
		} else {
			skin.reset();
		}
		
		if( style.color != null ) {
			// FIXME: no such thing as foreground yet.
//			setForegroundColor( style.color );
		}
		if( style.background != null ) {
			setBackgroundColor( style.background );
		}
		
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

		var p = skin.update( w, h );
				
		if( autoSize ) {
			bounds.setSize( w, h );
		}
		
		if( child != null ) {
			var l = style.textAlign * ((w-(pad.r+pad.l))-child.bounds.width);
			child.bounds.setPosition( l+p.x+pad.l, p.y+pad.t );
		}
    }
    
    override private function onSizeChanged( e:Event ) :Void {
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

    public function childSizeChanged( e:Event ) {
        if( autoSize ) {
            updateSize();
        }
    }
    
    public function setChild( e:Element ) :Void {
        // FIXME: unregister old handler
        child = e;
        child.bounds.addEventListener( Event.SIZE_CHANGED, childSizeChanged );
        updateSize();
    }
}
