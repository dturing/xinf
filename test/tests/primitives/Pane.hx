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

package tests.primitives;

class Pane extends TestCase {
    public function new( parent:org.xinf.ony.Element ) :Void {
        super( parent, "Pane", "tests xinf.ony.Pane for proper position, size, color, hierarchy", 1.0 );

    // a red square
        var sq = new org.xinf.ony.Pane( "testPane", this );
        sq.setBackgroundColor( new org.xinf.ony.Color().fromRGBInt( 0xff0000 ) );
        sq.bounds.setPosition( 10, 10 );
        sq.bounds.setSize( 100, 100 );

    // a green square, next to it
        var sq2 = new org.xinf.ony.Pane( "testPane2", this );
        sq2.setBackgroundColor( new org.xinf.ony.Color().fromRGBInt( 0x00ff00 ) );
        sq2.bounds.setPosition( 110, 10 );
        sq2.bounds.setSize( 100, 100 );

    // a blue square, visually next to, but logically inside of, green
        var sq3 = new org.xinf.ony.Pane( "testPane3", sq2 );
        sq3.setBackgroundColor( new org.xinf.ony.Color().fromRGBInt( 0x0000ff ) );
        sq3.bounds.setPosition( 100, 0 );
        sq3.bounds.setSize( 100, 100 );
        
    // TODO: test alpha, once it's around.

        screenshotFrame1();
    }
}
