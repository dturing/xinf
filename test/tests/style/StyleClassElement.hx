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
//		sq.autoSize = false;
        sq.bounds.setPosition( 10, 10 );
//        sq.bounds.setSize( 90, 20 );

		// setup test stylesheet
		StyleSheet.defaultSheet.add(
			[ "button" ], {
				padding: { l:6, t:3, r:6, b:3 },
				skin: "button/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5
			} );
		StyleSheet.defaultSheet.add(
			[ "button", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				skin: "button/hover/",
				padding: null, minWidth:null, textAlign:null, 
			} );
		StyleSheet.defaultSheet.add(
			[ "button", ":hover", "press" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:6, t:4, r:6, b:2 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				skin: "button/press/",
				minWidth:null, textAlign:null
			} );

		// simulate a button
		var t = new xinf.ony.Text("testT", sq );
		t.text = "Hello World!";
		sq.setChild(t);

		sq.addStyleClass("button");

		sq.addEventListener( xinf.event.Event.MOUSE_DOWN, function (e:xinf.event.Event) {
			sq.addStyleClass("press");
		} );
		sq.addEventListener( xinf.event.Event.MOUSE_UP, function (e:xinf.event.Event) {
			sq.removeStyleClass("press");
		} );

		screenshotFrame1();
    }
}
