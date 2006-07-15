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

package xinf.ony;

import xinf.geom.Point;
import xinf.event.Event;

#if js
    import js.Dom;
#end

/**
	One-line Text Input element
**/
class TextEntry extends Pane {
    /**
        The actual text that will be displayed. 
    **/
    public var text( getText, setText ) :String;

    private var textColor:Color;

    private var _t
        #if neko
            :xinf.inity.LineEdit
        #else js
            :js.HtmlDom
        #else flash
            :flash.TextField
        #end
        ;

    /**
        Constructor. Text content will be empty.
    **/    
    public function new( name:String, parent:Element ) {
        super(name,parent);
        setTextColor( Color.BLACK );
		#if neko
		// FIXME
			addEventListener( xinf.ony.MouseEvent.MOUSE_DOWN, _t.onMouseDown );
			addEventListener( xinf.ony.KeyboardEvent.KEY_DOWN, _t.onKeyDown );
		#end
    }
    
    override function createPrimitive() :Primitive {
        _t =
            #if neko
                new xinf.inity.LineEdit()
            #else js
                js.Lib.document.createElement("input")
            #else true
                null
            #end
            ;

        #if js
            _t.style.overflow = "hidden";
            _t.style.whiteSpace = "nowrap";
            _t.style.fontFamily = "Bitstream Vera Sans, Arial, sans-serif";
            _t.style.fontSize = 11;
            _t.style.paddingTop = 0;
            _t.style.paddingBottom = 0;
            _t.style.paddingLeft = 2;
            _t.style.paddingRight = 2;
            _t.style.lineHeight = "110%";
            _t.style.background = "transparent";
			_t.style.border = "none";
			return _t;
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            var e = parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
			
			e.createTextField( name+"_t", e.getNextHighestDepth(), -1, -1, 50, 50 );
            _t = Reflect.field( e, name+"_t" );
			
            _t.autoSize = false;
            _t.selectable = true;
			_t.type = "input";
			_t.border=false;
			
			var tListener = { 
				onChanged: function( textfield:flash.TextField ) {
					trace("TextField "+textfield+" changed: "+textfield.text );
					trace("pos: "+textfield._x+"/"+textfield._y );
				}
			};
			_t.addListener(tListener);

            var format:flash.TextFormat = new flash.TextFormat();
            format.size = 11; //*1.05;
            format.font = "Bitstream Vera Sans";
            _t.setNewTextFormat( format );
            
            return e;     
        #else neko
            _t.fontSize = 11;
			return _t;
        #end
    }

	#if flash
    override private function onSizeChanged( e:GeometryEvent ) :Void {
		super.onSizeChanged(e);
		_t._width = e.x;
		_t._height = e.y+2;
	}
	#end
	
	#if neko
	override public function focus() :Void {
		_t.focus = true;
		super.focus();
	}

	override public function blur() :Void {
		_t.focus = false;
		super.blur();
	}
	#end
	
    private function setText( t:String ) :String {
        #if neko
            _t.text = t;
        #else js
			untyped _t.value = t;
        #else flash
            _t.text = t;
        #end
        
        return getText();
    }
    private function getText() :String {
        #if neko
            return _t.text;
        #else js
            return untyped _t.value;
        #else flash
            return _t.text;
        #end
    }
    public function setTextColor( c:Color ) :Void {
        textColor = c;
        
        #if neko
            _p.fgColor = textColor;
            _p.changed();
        #else js
            _p.style.color = textColor.toRGBString();
        #else flash
            _t.textColor = textColor.toRGBInt();
        #end
    }

	public function setFontSize( s:Float ) :Void {
        s = Math.floor(s);
        #if neko
            _t.fontSize = s;
            _p.changed();
        #else js
            _p.style.fontSize = ""+(s*1.0)+"px";
        #else flash
            var format:flash.TextFormat = new flash.TextFormat();
            format.size = s;//*1.05;
            format.font = "Bitstream Vera Sans";
            _t.setNewTextFormat( format );
            _t.setTextFormat( format );
        #end
    }
}
