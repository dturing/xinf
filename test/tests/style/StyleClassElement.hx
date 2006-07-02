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

package tests.style;

import xinf.style.StyleSheet;

class StyleClassElement extends TestCase {
    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

        var sq = new xinf.style.StyleClassElement( "testStyledElement", this );
        sq.bounds.setPosition( 10, 10 );

		StyleSheet.defaultSheet.add(
			[ "test" ], {
				padding: { l:3, t:1, r:3, b:1 },
				border: { l:2, t:2, r:0, b:2 },
				skin: "slider/box/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5
			} );
		StyleSheet.defaultSheet.add(
			[ "test", ":hover" ], {
				padding: null,
				border: { l:2, t:2, r:0, b:2 },
				skin: "slider/box/hover/",
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xdddddd ),
				minWidth: 75.,
				textAlign: .5
			} );		

		// simulate a button
		var t = new xinf.ony.Text("testT", sq );
		t.text = "Hello World!";
		sq.setChild(t);

		sq.addStyleClass("test");

		sq.addEventListener( xinf.event.Event.MOUSE_DOWN, function (e:xinf.event.Event) {
			sq.addStyleClass("press");
		} );
		sq.addEventListener( xinf.event.Event.MOUSE_UP, function (e:xinf.event.Event) {
			sq.removeStyleClass("press");
		} );

		screenshotFrame1();
    }
}
