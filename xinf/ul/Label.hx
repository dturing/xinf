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

import xinf.ony.Pane;
import xinf.ony.Element;
import xinf.event.Event;
import xinf.ony.Color;
import xinf.ony.Text;

/**
    Simple Label element.
**/

class Label extends Pane {
    private static var hpadding:Float = 6;
    private static var vpadding:Float = 3;
    
    private var hoverColor:Color;
    private var nonHoverColor:Color;

    public var text(get_text,set_text):String;
    private var textE:Text;
    
    public function new( name:String, parent:Element ) :Void {
        super( name, parent );

        nonHoverColor = new Color().fromRGBInt( 0xffffff );
       // setBackgroundColor( nonHoverColor );

        textE = new xinf.ony.Text( name+"_text", this );
        textE.bounds.setPosition( hpadding, vpadding-1 );
        textE.bounds.addEventListener( Event.SIZE_CHANGED, textResized );

        bounds.setSize( textE.bounds.width + (2*hpadding), textE.bounds.height + (2*vpadding) );
        /*
        addEventListener( Event.MOUSE_OUT, onMouseOut );
        addEventListener( Event.MOUSE_OVER, onMouseOver );
        */
    }
    
    private function get_text() :String {
        return(textE.text);
    }
    private function set_text( t:String ) :String {
        textE.text = t;
        return(t);
    }

    public function textResized( e:Event ) {
        if( autoSize ) {
            bounds.setSize( textE.bounds.width + (2*hpadding), textE.bounds.height + (2*vpadding) );
        }
    }

    public function setHoverColor( c:xinf.ony.Color ) :Void {
        hoverColor=c;
    }
    
    public function onMouseOver( e:Event ) :Void {
        if( hoverColor != null ) {
            setBackgroundColor( hoverColor );
        }
    }
    public function onMouseOut( e:Event ) :Void {
        setBackgroundColor( nonHoverColor );
    }
    
}
