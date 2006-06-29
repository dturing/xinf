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
class TextField extends Pane {
    /**
        The actual text that will be displayed. 
    **/
    public var text( getText, setText ) :String;

    private var textColor:xinf.ony.Color;

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
        setTextColor( new xinf.ony.Color().fromRGBInt(0) );
		#if neko
			addEventListener( Event.MOUSE_DOWN, _t.onMouseDown );
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
            _t.style.paddingTop = 2;
            _t.style.paddingBottom = 2;
            _t.style.paddingLeft = 2;
            _t.style.paddingRight = 2;
            _t.style.lineHeight = "110%";
			return _t;
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            var e = parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
            
			e.createTextField("_"+name, e.getNextHighestDepth(), 0, 0, 0, 0 );
            _t = Reflect.field( e, "_"+name );
            
            _t.autoSize = false;
            _t.selectable = true;
            
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
    public function setTextColor( c:xinf.ony.Color ) :Void {
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
