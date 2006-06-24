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

    // PNG
        var sq = new xinf.ony.Image( "png", this, "assets/test.png" );
        sq.bounds.setPosition( 60, 80 );
        sq.bounds.setSize(180,20);

    // JPEG
        var sq = new xinf.ony.Image( "jpg", this, "assets/test.jpg" );
        sq.bounds.setPosition( 60, 120 );
        sq.bounds.setSize(180,20);

    // TODO: image loading via http

        screenshotFrame1();
    }
}
