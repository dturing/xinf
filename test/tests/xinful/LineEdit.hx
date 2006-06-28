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

import xinf.ul.ListModel;

class LineEdit extends TestCase {
    private var display:xinf.ony.Text;

    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

        var t = new xinf.ul.LineEdit( "test", this );
        t.bounds.setPosition( 10, 10 );
        t.bounds.setSize( 150, 20 );
        t.text = "Edit me!";

        screenshotFrame1();
    }
}
