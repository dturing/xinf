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

package xinf.svg;

import xinf.erno.Renderer;
import xinf.erno.TextFormat;
import xinf.erno.Color;

import xinf.event.MouseEvent;

/**
    SVG Text element.
**/

class Text extends Element {
    public var x:Float;
    public var y:Float;
    var text(getText,setText):String;
    var format:TextFormat;

    public function getText() :String {
        return text;
    }
    public function setText( s:Dynamic ) :String {
        text=Std.string(s);
        scheduleRedraw();
        return text;
    }

    public function new() :Void {
        super();
        format = TextFormat.getDefault();
    }

    function getFloat( xml:Xml, name:String, ?def:Float ) :Float {
        if( xml.exists(name) ) return Std.parseFloat(xml.get(name));
        if( def==null ) def=0;
        return def;
    }
    
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
        return text;
    }


    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x = getFloatProperty(xml,"x");
        y = getFloatProperty(xml,"y");
        
        text=xmlUnescape(StringTools.trim(textContent(xml)));
        
        var t:Dynamic;
        var family:String="_sans";
        var size:Float=12.0;
        if( (t=style.get("font-family"))!=null ) {
            family=t;
        }
        if( (t=style.get("font-size"))!=null ) {
            size=t;
        }
        if( family!=null || size!=null ) {
            format = TextFormat.create(family,size);
        }
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        //var format = getStyleTextFormat();

        if( text!=null ) {
            var s = format.textSize(text);
            
//            trace("draw text "+text+" font: "+format.font+" size "+format.size );
            g.text( x,y-format.size,text,format );
        
            // FIXME: for hittest, maybe GLRenderer should do that?
            g.setFill( 0,0,0,0 ); //.3 );
            g.rect( x,y-s.y,s.x,s.y);
        }
    }

	/**
		Unescape XML special characters of the string.
	**/
	public static function xmlUnescape( s : String ) : String {
		return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&").split("&quot;").join("\"");
	}

}
