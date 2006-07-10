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
    Text is an Element that displays Text. Handling of the font style is not yet finalized. The Text is not editable.
**/
class Text extends Pane {
    /**
        The actual text that will be displayed. 
        Setting the text with autoSize set to true will trigger a SIZE_CHANGED event on the Element's bounds.
    **/
    public var text( getText, setText ) :String;

    /* FIXME. autoSized moved somewhere else.
        If autoSize is set to true, the Element's bounds rectangle will automatically be set to enclose the
        contained text. If false, it will always be the size you specified, with text content probably overflowing.
    */

    private var _t
        #if neko
            :xinf.inity.Text
        #else js
            :js.HtmlDom
        #else flash
            :flash.TextField
        #end
        ;

    /**
        Constructor. Initializes to autoSize=true; text content will be empty.
    **/    
    public function new( name:String, parent:Element ) {
        super(name,parent);
        autoSize = true;
    }
    
    override function createPrimitive() :Primitive {
        _t =
            #if neko
                new xinf.inity.Text()
            #else js
                js.Lib.document.createElement("div")
            #else true
                null
            #end
            ;

        #if js
            _t.style.cursor = "default";
            _t.style.overflow = "hidden";
            _t.style.whiteSpace = "nowrap";
            _t.style.fontFamily = "Bitstream Vera Sans, Arial, sans-serif";
            _t.style.fontSize = 11;
            _t.style.lineHeight = "110%";
			return _t;
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
			var e = parent._p.createEmptyMovieClip(name,parent._p.getNextHighestDepth());
            
            e.createTextField("_"+name, e.getNextHighestDepth(), -2, -2, 0, 0 );
            _t = Reflect.field( e, "_"+name );
            
            _t.autoSize = true;
            _t.selectable = false;
            
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
    override public function setForegroundColor( fg:Color ) :Void {
		super.setForegroundColor(fg);
		_t.textColor = fgColor.toRGBInt();
    }
	#end
    
    private function setText( t:String ) :String {
        #if neko
            _t.text = t;
        #else js
            while( _t.firstChild != null ) _t.removeChild( _t.firstChild );
            var ta = t.split("\n");
            _t.appendChild( untyped js.Lib.document.createTextNode( ta.shift() ) );
            var ct = ta.shift();
            while( ct != null ) {
                _t.appendChild( js.Lib.document.createElement("br") );
                _t.appendChild( untyped js.Lib.document.createTextNode( ct ) );
                ct = ta.shift();
            }
        #else flash
            _t.text = t;
        #end
        
        if( autoSize ) calcSize();
        return getText();
    }
    private function getText() :String {
        #if neko
            return _t.text;
        #else js
            return untyped _t.innerHTML.split("<br/>").join("\n");
        #else flash
            return _t.text;
        #end
    }
    
    private function calcSize() :Void {
        var s:Point;
        #if neko
            s = _t.getTextExtends();
        #else js
            s = new Point(untyped _t.offsetWidth, untyped _t.offsetHeight);
        #else flash
            s = new Point( _t._width-4, _t._height-4 );
        #end
        
        #if js
            /* in js, at least mozilla, offsetWidth awkwardly is 0 until the
               page is rendered. i dont know how i can trigger- or wait for- 
               rendering, so we timeout here until we have a  proper value..
               gives us some flickering, sadly. */
            if( text != "" && s.x == 0 ) {
                var self = this;
                untyped js.Lib.window.setTimeout( function() {
                    self.calcSize();
                }, 100 );
            } else {
                bounds.setSize( s.x, s.y );
            }
        #else true
            bounds.setSize( Math.round(s.x), Math.round(s.y) );
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
