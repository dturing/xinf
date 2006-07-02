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

class SimpleWidgets extends TestCase {
    private var display:xinf.ony.Text;

    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

		xinf.style.StyleSheet.defaultSheet.add(
			[ "Label" ], {
				padding: { l:6, t:3, r:6, b:3 },
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				skin: null, background: null, minWidth: null, textAlign: null
			} );
		xinf.style.StyleSheet.defaultSheet.add(
			[ "Label", ":hover" ], {
				background: new xinf.ony.Color().fromRGBInt( 0xaaaaaa ),
				padding: null, color: null,
				skin: null, minWidth: null, textAlign: null
			} );

    // Label
        var t = new xinf.ul.Label( "test", this );
        t.bounds.setPosition( 10, 10 );
		t.text="Test Label";

        screenshotFrame1();
    }
    
    public function displayEvent( e:xinf.event.Event ) {
        display.text = ""+e.type+"\n"+e.data;
    }
}
