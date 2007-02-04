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

import xinf.erno.Renderer;
import xinf.erno.Color;
import xinf.erno.TextFormat;

/**
    A simple Xinfony Object displaying a string of text.
**/
class Text extends Object {
    
    public var color:Color;
    public var text(default,setText):String;
    public var format(default,setFormat):TextFormat;
    public var autoSize(default,setAutoSize):Bool;
    
    public function new( ?text:String, ?color:Color ) :Void {
        if( color==null ) color = Color.BLACK;
        this.color=color;
        this.text=text;
        this.format=TextFormat.getDefault();
        //format.size = 12;
        //format.family = "_sans";
        super();
    }
    
    function setText( t:String ) :String {
        this.text = t;
        calcSize();
        return text;
    }

    function setFormat( format:TextFormat ) :TextFormat {
        this.format = format;
        calcSize();
        return format;
    }

    function setAutoSize( a:Bool ) :Bool {
        this.autoSize = a;
        calcSize();
        return a;
    }

    public function calcSize() :Void {
        if( autoSize ) {
            var s = format.textSize( text );
            if( s.x!=size.x || s.y!=size.y ) {
                resize( s.x, s.y );
            }
//            trace("calc font size for text '"+text+"': "+s.x+"/"+s.y );
        }
    }
    
    public function drawContents( g:Renderer ) :Void {
        if( text!=null ) {
            g.setFill( 1,1,1,.5 );
            g.rect( 0, 0, 500, 500 ); //size.x, size.y );
            g.setFill( color.r, color.g, color.b, color.a );
            g.text(0,0,text,format);
        }
    }
    
}
