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
import xinf.style.ImageBorder;

/**
	StyledElement
**/

class StyledElement extends Pane {
    private var child:Element;
	private var style:Style;
    
	private var border:SidesAndCorners<Border>;
	
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );
		autoSize=true;
		
		style = {
			padding: { l:6, t:3, r:6, b:3 },
			border: {
				l: 	new ImageBorderStyle( 2, "assets/button/button_l.png" ),
				t: 	new ImageBorderStyle( 2, "assets/button/button_t.png" ),
				r: 	new ImageBorderStyle( 2, "assets/button/button_r.png" ),
				b:  new ImageBorderStyle( 2, "assets/button/button_b.png" ),
				tl: new ImageBorderStyle( 2, "assets/button/button_tl.png" ),
				tr: new ImageBorderStyle( 2, "assets/button/button_tr.png" ),
				bl:	new ImageBorderStyle( 2, "assets/button/button_bl.png" ),
				br: new ImageBorderStyle( 2, "assets/button/button_br.png" )
			},
			color: new xinf.ony.Color().fromRGBInt( 0xaa0000 ),
			background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
			minWidth: 75.,
			hAlign: .5
		};
		applyStyle();
    }
    
	public function applyStyle() :Void {
		if( style == null ) return;
		
		border = { l:null, t:null, r:null, b:null,
					tl:null, tr:null, bl:null, br:null };
		
		if( style.border != null ) {
			border.l = style.border.l.make( this );
			border.t = style.border.t.make( this );
			border.r = style.border.r.make( this );
			border.b = style.border.b.make( this );
			border.tl = style.border.tl.make( this );
			border.tr = style.border.tr.make( this );
			border.bl = style.border.bl.make( this );
			border.br = style.border.br.make( this );
		}
		
		if( style.color != null ) {
			// FIXME: no such thing as foreground yet.
//			setForegroundColor( style.color );
		}
		if( style.background != null ) {
			setBackgroundColor( style.background );
		}
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
			w = bounds.width - ( border.l.width + border.r.width );
			h = bounds.height - ( border.t.width + border.b.width );
		}

		if( w < style.minWidth ) w=style.minWidth;

		border.l.setLeft( 0, border.tl.width, h );
		border.r.setRight( border.l.width+w, border.tr.width, h );
		border.t.setTop( border.tl.width, 0, w );
		border.b.setBottom( border.tl.width, border.t.width+h, w );
		border.tl.set(0,0);
		border.tr.set(border.l.width+w,0);
		border.bl.set(0,border.t.width+h);
		border.br.set(border.l.width+w,border.t.width+h);

		if( autoSize ) {
			bounds.setSize( w+border.l.width+border.r.width, h+border.t.width+border.b.width );
		}
		if( child != null ) {
			var l = style.hAlign * ((w-(pad.r+pad.l))-child.bounds.width);
			child.bounds.setPosition( l + pad.l+border.l.width, pad.t+border.t.width );
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
