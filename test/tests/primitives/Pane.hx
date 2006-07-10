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
    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

    // a red square
        var sq = new xinf.ony.Pane( "testPane", this );
        sq.setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0xff0000 ) );
        sq.bounds.setPosition( 10, 10 );
        sq.bounds.setSize( 50, 50 );

    // a green square, next to it
        var sq2 = new xinf.ony.Pane( "testPane2", this );
		sq2.setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0x00ff00 ) );
        sq2.bounds.setPosition( 70, 10 );
        sq2.bounds.setSize( 50, 50 );

    // a blue square, visually next to, but logically inside of, green
        var sq3 = new xinf.ony.Pane( "testPane3", sq2 );
        sq3.setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0x0000ff ) );
        sq3.bounds.setPosition( 60, 0 );
        sq3.bounds.setSize( 50, 50 );

// test cropping

    // cropping element
        var c = new xinf.ony.Pane( "cropper", this );
		c.crop=true;
        c.setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0xdddddd ) );
        c.bounds.setPosition( 10, 70 );
        c.bounds.setSize( 110, 50 );

	// a red square, left
        var sq = new xinf.ony.Pane( "testPane", c );
        sq.setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0xff0000 ) );
        sq.bounds.setPosition( -50, -10 );
        sq.bounds.setSize( 100, 70 );

	// a green square, left
        var sq = new xinf.ony.Pane( "testPane", c );
        sq.setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0x00ff00 ) );
        sq.bounds.setPosition( 60, -10 );
        sq.bounds.setSize( 100, 70 );

    // TODO: 
    // test alpha, once it's around.

	
	trace("Created Panes");

        screenshotFrame1();
    }
}
