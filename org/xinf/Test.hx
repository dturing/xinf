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

package org.xinf;

import org.xinf.event.Event;
import org.xinf.event.EventDispatcher;

class Foo extends org.xinf.ony.Text {
    public function new( name:String, parent:org.xinf.ony.Element ) {
        super( name, parent );
        text = "Hello,\nWorld.";
        
        for( event in [ Event.MOUSE_DOWN, Event.MOUSE_UP,
                        Event.MOUSE_OVER, Event.MOUSE_OUT ] ) {
            addEventListener( event, handleEvent );
        }
    }
    
    public function handleEvent( e:Event ) : Void {
//        trace("Event on "+this+": "+e.type );
        
        var t:String = name+"\n"+e.type+"\n";
        text = t;
    }
    
}

/**
    Informal xinf Test (used during development).
**/
class Test {
    static var container:org.xinf.ony.Element;
    static var x:Int;
    
    static function main() {
        x=0;
        
        var root = org.xinf.ony.Root.getRoot();

        var cbg = new org.xinf.ony.Color();
        cbg.fromRGBInt( 0xeeeeee );
        
        var cont = new org.xinf.ony.Pane("container", root);
        cont.setBackgroundColor( cbg );
        cont.crop = true;
        cont.bounds.setPosition( 10, 10 );
        cont.bounds.setSize( 300, 100 );
        container = cont;

/*        
        var i = new org.xinf.ony.Image("test", cont, "assets/test.jpg");
        i.bounds.setPosition( 100, 0 );
//        i.bounds.setSize( 80, 60 );
*/

        var bg = new org.xinf.ony.Color();
        bg.fromRGBInt( 0x336699 );
        var fg = new org.xinf.ony.Color();
        fg.fromRGBInt( 0xffffff );
        
            for( i in 0...3 ) {
                var box = new Foo("box"+i, cont);
                box.setBackgroundColor( bg );
                box.setTextColor( fg );
                box.bounds.setPosition( 10, i*40 ); //last.bounds.y+last.bounds.height+2 );
            }

        var slider = new org.xinf.ul.VerticalSlider( "test", cont );

        org.xinf.ony.Root.getRoot().run();
    }
}
