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

package tests;

class TestPane extends TestCase {
    var sq:org.xinf.ony.Pane;
    public function new( parent:org.xinf.ony.Element ) :Void {
        super( parent, "TestPane", "tests xinf.ony.Pane for proper position, size, color, hierarchy", 1.0 );

        sq = new org.xinf.ony.Pane( "testPane", this );
        sq.setBackgroundColor( new org.xinf.ony.Color().fromRGBInt( 0xff0000 ) );
        sq.bounds.setPosition( 10, 10 );
        sq.bounds.setSize( 100, 100 );

    /* todo: green peer, blue child */

        screenshotFrame1();
    }
}
