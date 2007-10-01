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

package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;

/**
    A simple Xinfony Object displaying a string of text.
**/
class Text extends Object, implements xinf.ony.Text {
    
    public var text(default,set_text):String;
    public var x(default,set_x):Float;
    public var y(default,set_y):Float;

    private var format:TextFormat;

    private function set_x(v:Float) {
        x=v; scheduleRedraw(); return x;
    }
    private function set_y(v:Float) {
        y=v; scheduleRedraw(); return y;
    }
    private function set_text( t:String ) :String {
        text=t; scheduleRedraw(); return text;
    }

	public function new() :Void {
		super();
		x=y=0;
		format = TextFormat.getDefault();
	}

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x = getFloatProperty(xml,"x");
        y = getFloatProperty(xml,"y");
        text = textContent(xml);
    }
    
    override public function styleChanged() :Void {
        super.styleChanged();
        
        var family = style.fontFamily;
        var size = style.fontSize;
        format = TextFormat.create( if(family!=null) family.list[0] else null, size ); 
        // TODO: weight
    }
    
    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        if( text!=null ) {
            g.text(x,y-format.size,text,format);
        }
    }
    
    
/* helpers *******************/

    function textContent( xml:Xml ) :String {
        var text = "";
        for( child in xml ) {
            switch( child.nodeType ) {
                case Xml.PCData:
                    text+=child.nodeValue;
                case Xml.Element:
                    text+=textContent(child)+"\n";
                default:
            }
        }
        return xmlUnescape(StringTools.trim( text ));
    }
    
	/**
		Unescape XML special characters of the string.
	**/
	public static function xmlUnescape( s : String ) : String {
		return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&").split("&quot;").join("\"");
	}
}
