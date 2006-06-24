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

package tests.xinful;

class Scrollbar extends TestCase {
    private var display:xinf.ony.Text;

    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

    // BG
        var bg = new xinf.ony.Pane( "bg", this );
        bg.setBackgroundColor( new xinf.ony.Color().fromRGBInt(0xffaaaa) );
        bg.bounds.setPosition( 10, 10 );
        bg.bounds.setSize( 300, 220 );

    // Display
        display = new xinf.ony.Text( "display", bg );
        display.bounds.setPosition( 10, 10 );

    // VScrollbar
        var sb = new xinf.ul.VScrollbar( "test", bg );
        sb.bounds.setPosition( 290, 0 );
//        sq.bounds.setSize( 100, 10 );

        sb.addEventListener( xinf.event.Event.SCROLLED, displayScrollEvent );
        sb.addEventListener( xinf.event.Event.SCROLL_LEAP, displayScrollEvent );
        bg.addEventListener( xinf.event.Event.SCROLL_STEP, displayScrollEvent );

        screenshotFrame1();
    }
    
    public function displayScrollEvent( e:xinf.event.Event ) {
        display.text = ""+e.type+"\n"+e.data;
    }
}
