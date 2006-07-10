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

package xinf.inity;

import xinf.event.Event;
import xinf.inity.Text;
import xinf.geom.Point;
import xinf.ony.KeyboardEvent;
import xinf.ony.MouseEvent;

/**
    single-line text input element
	
	TODO:
	  * double-click selects word
	  * dragging out of bounds should scroll onEnterFrame.
**/

class LineEdit extends Text {
	private var sel :{ from:Int, to:Int };
    public var selBgColor:xinf.ony.Color;
    public var selFgColor:xinf.ony.Color;
	
	private var xOffset:Float;
	private var mouseSelAnchor:Int;
	private var _mouseMove:Dynamic;
	private var _mouseUp:Dynamic;

    public function new() :Void {
        super();
		sel = { from:0, to:0 };
		xOffset = 0;
		
		selBgColor = new xinf.ony.Color().fromRGBInt( 0x333333 );
		selFgColor = new xinf.ony.Color().fromRGBInt( 0xeeeeee );

        xinf.event.Global.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
    }

    public function onKeyDown( e:KeyboardEvent ) :Void {
		if( e.code >= 32 ) {
			trace("key: "+e.code+", "+e.key );
			switch( e.code ) {
				case 127: // Del
					if( sel.from==sel.to ) {
						sel.to=sel.from+1;
					}
					replaceSelection("");
				default:
					replaceSelection( Std.chr(e.code) );
			}
		} else {
			switch( e.key ) {
				case "backspace":
					if( sel.to==sel.from ) sel.from=sel.to-1;
					replaceSelection("");
				case "left":
					moveCursor( 
						if( e.ctrlMod )
							findLeftWordBoundary()
						else 
							sel.to-1
						, e.shiftMod );
				case "right":
					moveCursor( 
						if( e.ctrlMod )
							findRightWordBoundary()
						else 
							sel.to+1
						, e.shiftMod );
				case "home":
					moveCursor( 0, e.shiftMod );
				case "end":
					moveCursor( _text.length, e.shiftMod );
				case "a":
					selectAll();
				default:
					trace("unhandled control key: "+e.key);
			}
		}
    }
	
	public function onMouseDown( e:MouseEvent ) :Void {
		var p:Point = owner.globalToLocal( new Point( e.x, e.y ) );
		p.x += xOffset;
		_mouseUp = onMouseUp;
		_mouseMove = onMouseMove;
        xinf.event.Global.addEventListener( MouseEvent.MOUSE_UP, _mouseUp );
        xinf.event.Global.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMove );
		
		moveCursor( findIndex(p), false ); // FIXME e.shiftMod );
	}
	
	public function onMouseMove( e:MouseEvent ) :Void {
		var p:Point = owner.globalToLocal( new Point( e.x, e.y ) );
		p.x += xOffset;
		moveCursor( findIndex(p), true );
	}
	
	public function onMouseUp( e:MouseEvent ) :Void {
        xinf.event.Global.removeEventListener( MouseEvent.MOUSE_UP, _mouseUp );
        xinf.event.Global.removeEventListener( MouseEvent.MOUSE_MOVE, _mouseMove );
		_mouseUp = _mouseMove = null;
	}
	
	public function selectAll() :Void {
		sel.from=0; sel.to=_text.length;
		changed();
	}
	
	public function moveCursor( to:Int, extendSelection:Bool ) :Void {
		sel.to=to; 
		if( sel.to < 0 ) sel.to=0;
		else if( sel.to > _text.length ) sel.to=_text.length;
		if( !extendSelection ) sel.from=sel.to;
		changed();
	}

	public function replaceSelection( str:String ) :Void {
		if( sel.from > sel.to ) {
			var t = sel.from;
			sel.from = sel.to;
			sel.to = t;
		}
		if( sel.from<0 ) sel.from=0;
		if( sel.to<sel.from ) sel.to=sel.from;
	
		var t = text;
		var u = t.substr(0,sel.from);
		u += str;
		u += t.substr(sel.to, t.length-sel.to);
		sel.to=sel.from=sel.from+str.length;
		text=u;
	}

	public function findLeftWordBoundary() :Int {
		var p:Int=sel.to-1;
		while( _text.charCodeAt(p)==32 ) p--;
		while( p>=0 && p<_text.length && _text.charCodeAt(p) != 32 ) {
			p-=1;
		}
		p++;
		return p;
	}
	public function findRightWordBoundary() :Int {
		var p:Int=sel.to;
		while( _text.charCodeAt(p)==32 ) p++;
		while( p>=0 && p<_text.length && _text.charCodeAt(p) != 32 ) {
			p++;
		}
		return p;
	}

	public function findIndex( p:Point ) :Int {
		var x:Float=0;
		var i:Int=0;
		var g;
		while( x < p.x && i<_text.length ) {
			g = Text._font.getGlyph(_text.charCodeAt(i));
			if( g != null ) {
				x += Math.round((g.advance*fontSize));
			}
			i++;
		}
		if( g != null ) 
			if( p.x <= x-(Math.round(g.advance*fontSize)/2) ) i--;
			
		return i;
	}

    override function _renderGraphics() :Void {
		// calc selection background
		var selStart:Float = 0;
		var selEnd:Float = 0;
		var x:Float=0;
		var s:Float=fontSize;
		for( i in 0..._text.length+1 ) {
			if( i==sel.from ) selStart = x;
			if( i==sel.to ) selEnd = x;
			
			if( i<_text.length ) {
				var g = Text._font.getGlyph(_text.charCodeAt(i));
				if( g != null ) {
					x += Math.round((g.advance*s));
				}
			}
		}

		// "ScrollIntoView" - FIXME you can do better, no?
		var c=selEnd-xOffset;
		if( c < 10 ) {
			xOffset += c-10;
		}
		if( c > bounds.width-10 ) {
			xOffset += c - (bounds.width-10);
		}
		if( xOffset != 0 && (x-xOffset) < bounds.width ) {
			if( x < bounds.width ) {
				xOffset=0;
			} else {
				xOffset -= (bounds.width - (x-xOffset));
			}
		}
		if( xOffset<0 ) xOffset=0;
		
        GL.PushMatrix();
			GL.Translatef( -xOffset, .0, .0 );

			GL.Color4f( selBgColor.r, selBgColor.g, selBgColor.b, selBgColor.a );
			var x=selStart-1.5; var y=-.5; 
			var w=selEnd-.5; var h=Math.ceil((Text._font.height*fontSize)+.5)-.5;
			GL.Begin( GL.QUADS );
				GL.Vertex3f( x, y, 0. );
				GL.Vertex3f( w, y, 0. );
				GL.Vertex3f( w, h, 0. );
				GL.Vertex3f( x, h, 0. );
			GL.End();
			
			
			// setup styles for selection foreground
			styles = new Array<StyleChange>();
			if( sel.from != sel.to ) {
				styles.push( { pos:Math.round(Math.min(sel.to,sel.from)), color:selFgColor } );
				styles.push( { pos:Math.round(Math.max(sel.to,sel.from)), color:fgColor } );
			}
			
		
			super._renderGraphics();
			
        GL.PopMatrix();
	}
}
