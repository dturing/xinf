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

import xinf.erno.Renderer;

#if neko
import xinf.event.Event;
import xinf.event.KeyboardEvent;
import xinf.event.MouseEvent;
import xinf.geom.Types;
import xinf.erno.Color;
import xinf.erno.FontStyle;
import xinf.erno.Renderer;
import xinf.inity.font.Font;
import xinf.inity.GLRenderer;

/**
    single-line text input element (xinfinity only)
    
    TODO:
      * double-click selects word
      * dragging out of bounds should scroll onEnterFrame.
**/

class LineEdit extends Widget {
    
    private var sel :{ from:Int, to:Int };
    public var text :String;
    
    private var font :Font;
    private var xOffset :Float;

    public function new() :Void {
        super();
        sel = { from:0, to:0 };
        xOffset = 0;
        text = "";
        
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
    }

    public function onKeyDown( e:KeyboardEvent ) :Void {
        if( e.code >= 32 && e.code < 127 ) {
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
                    moveCursor( text.length, e.shiftMod );
                case "a":
                    selectAll();
                default:
                    trace("unhandled control key: "+e.key);
            }
        }
        scheduleRedraw();
    }

    private function onMouseDown( e:MouseEvent ) :Void {
        var p = globalToLocal( {x:e.x, y:e.y } );
        p.x += (xOffset-style.padding.l);
        moveCursor( findIndex(p), false ); // FIXME e.shiftMod );
        new Drag<Float>( e, dragSelect, null, e.x );
    }
    
    public function dragSelect( x:Float, y:Float, marker:Float ) {
        var p = globalToLocal( {x:x+marker, y:y } );
        p.x += (xOffset-style.padding.l);
        moveCursor( findIndex(p), true );
    }
    
    public function selectAll() :Void {
        sel.from=0; sel.to=text.length;
        scheduleRedraw();
    }
    
    public function moveCursor( to:Int, extendSelection:Bool ) :Void {
        sel.to=to; 
        if( sel.to < 0 ) sel.to=0;
        else if( sel.to > text.length ) sel.to=text.length;
        if( !extendSelection ) sel.from=sel.to;
        scheduleRedraw();
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
        while( text.charCodeAt(p)==32 ) p--;
        while( p>=0 && p<text.length && text.charCodeAt(p) != 32 ) {
            p-=1;
        }
        p++;
        return p;
    }
    
    public function findRightWordBoundary() :Int {
        var p:Int=sel.to;
        while( text.charCodeAt(p)==32 ) p++;
        while( p>=0 && p<text.length && text.charCodeAt(p) != 32 ) {
            p++;
        }
        return p;
    }

    public function findIndex( p:TPoint ) :Int {
        if( font==null ) throw("Font unknown as yet");
        var fontSize:Float = style.get("fontSize",11);
        
        var x:Float=0;
        var i:Int=0;
        var g;
        while( x < p.x && i<text.length ) {
            g = font.getGlyph(text.charCodeAt(i));
            if( g != null ) {
                x += Math.round((g.advance*fontSize));
            }
            i++;
        }
        if( g != null ) 
            if( p.x <= x-(Math.round(g.advance*fontSize)/2) ) i--;
            
        return i;
    }

    public function drawContents( g:Renderer ) :Void {
        //super.drawContents(g); FIXME: why not. the code below doubles Pane(?)
        
        g.setFill( style.background.r, style.background.g, style.background.b, style.background.a );
        
        g.setStroke( 0,0,0,0,0 );
        g.rect( 0, 0, size.x, size.y );
        
        if( style.border.l > 0 ) {
            var b = style.border.l/4;
            g.setFill(0,0,0,0);
            g.setStroke(style.color.r,style.color.g,style.color.b,style.color.a,style.border.l);
            g.rect( -b, -b, size.x+(4*b), size.y+(4*b) );
        }


        var fontSize:Float = style.get("fontSize",11);
            
        var gl = cast(g,GLRenderer);
        font = gl.font;
        
        // calc selection background
        var selStart:Float = 0;
        var selEnd:Float = 0;
        var x:Float=0;
        var s:Float=fontSize;
        for( i in 0...text.length+1 ) {
            if( i==sel.from ) selStart = x;
            if( i==sel.to ) selEnd = x;
            
            if( i<text.length ) {
                var g = font.getGlyph(text.charCodeAt(i));
                if( g != null ) {
                    x += Math.round((g.advance*s));
                }
            }
        }

        
        // "ScrollIntoView" - FIXME you can do better, no?
        var c=selEnd-(xOffset-(style.padding.l));
        var d=10;
        if( c < d ) {
            xOffset += c-d;
        }
        if( c > size.x-d ) {
            xOffset += c - (size.x-d);
        }
        if( xOffset != 0 && (x-xOffset) < size.x-d ) {
            if( x < size.x-d ) {
                xOffset=0;
            } else {
                xOffset -= ((size.x-d) - (x-xOffset));
            }
        }
        if( xOffset<0 ) xOffset=0;
        
        
        var fgColor:Color = style.get("textColor",Color.BLACK);
        var selBgColor:Color = style.get("selectionBackground",Color.BLACK);
        var selFgColor:Color = style.get("selectionForeground",Color.WHITE);
        var focus = hasStyleClass(":focus");
        
            g.clipRect( size.x-2, size.y-2 );
            
            var xofs=-(xOffset-style.padding.l);
            var yofs=style.padding.t;

            // draw selection background/caret
            if( focus ) {
                g.setFill( selBgColor.r, selBgColor.g, selBgColor.b, selBgColor.a );
                g.setStroke( 0,0,0,0,0 );
                
                var x=selStart-1.5; var y=-.5; 
                var w=selEnd-.5; var h=Math.ceil((font.height*fontSize)+.5)-.5;
                g.rect( xofs+x, yofs+y, w-x,h-y );
            }
            
            
            g.setFill( fgColor.r, fgColor.g, fgColor.b, fgColor.a );
            g.setFont( style.get("fontFamily","_sans"), false, false, fontSize );
            
            // setup styles for selection foreground
            var styles = new FontStyle();
            if( focus && sel.from != sel.to ) {
                styles.push( { pos:Math.round(Math.min(sel.to,sel.from)), color:selFgColor } );
                styles.push( { pos:Math.round(Math.max(sel.to,sel.from)), color:fgColor } );
            }
            
            g.text( xofs, yofs, text ); // FIXME, styles );
            
    }
}

#else true
class LineEdit extends Widget {
    
    public var text(get_text,set_text) :String;
    private var _text :String;

    var native:Dynamic;

    private function get_text() :String {
        return _text;
    }
    
    private function set_text(t:String) :String {
        return _text=t;
    }

    public function new() :Void {
        super();
        _text = "foo";
        #if js
            var _t = js.Lib.document.createElement("input");
            native = _t;
            untyped _t.value = _text;
            _t.style.overflow = "hidden";
            _t.style.whiteSpace = "nowrap";
            _t.style.fontFamily = style.get("fontFamily","sans");
            _t.style.fontSize = style.get("fontSize",10);
            _t.style.paddingTop = 0;
            _t.style.paddingBottom = 0;
            _t.style.paddingLeft = 0;
            _t.style.paddingRight = 0;
            _t.style.lineHeight = "110%";
            _t.style.background = "#f00"; //"transparent";
            _t.style.border = "none";
            _t.style.position="absolute";
            //_t.style.top = "-10";
        #end
    }

    public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        
        g.native(native);
    }
    
}
#end
