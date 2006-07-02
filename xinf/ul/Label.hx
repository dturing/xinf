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
import xinf.ony.Text;
import xinf.style.StyleClassElement;

/**
    Simple Label element.
**/

class Label extends StyleClassElement {
    public var text(get_text,set_text):String;
    private var textE:Text;
    
    public function new( name:String, parent:Element ) :Void {
		super( name, parent );

        textE = new xinf.ony.Text( name+"_text", this );
		setChild( textE );
    }
    
    private function get_text() :String {
        return(textE.text);
    }
    private function set_text( t:String ) :String {
        textE.text = t;
        return(t);
    }
}
