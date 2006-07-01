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

class Image extends TestCase {
    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

    // 2x2px checkerboard, scaled
        var t = new xinf.ony.Image( "test2x2", this, "assets/checker2x2.png" );
        t.autoSize = false;
        t.bounds.setPosition( 60, 20 );
        t.bounds.setSize(40,40);

    // 4x4px checkerboard, scaled
        var t = new xinf.ony.Image( "test4x4", this, "assets/checker.png" );
        t.autoSize = false;
        t.bounds.setPosition( 110, 20 );
        t.bounds.setSize(40,40);

    // color images
    // PNG
        var sq = new xinf.ony.Image( "png", this, "assets/test.png" );
        sq.bounds.setPosition( 60, 80 );

    // JPEG
        var sq = new xinf.ony.Image( "jpg", this, "assets/test.jpg" );
        sq.bounds.setPosition( 60, 120 );

		trace("JPEG size: "+sq.bounds );

    // TODO: image loading via http

        screenshotFrame1();
    }
}
