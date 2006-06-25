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

class Skin extends TestCase {
    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

        setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0xdddddd ) );

    // We simulate a button, doing a Skin/Label combi
        var skin = new xinf.ul.Skin( "testSkin", this );
        skin.bounds.setPosition( 10, 10 );
        
        var label = new xinf.ul.Label( "test", skin );
        label.text = "Hello, World!";
        skin.setChild( label );
        
        label.bounds.setSize( 100, 20 );
        label.setBackgroundColor( null );

        screenshotFrame1();
    }
}
