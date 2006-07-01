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
import xinf.style.ImageBorder;

class StyleClassElement extends TestCase {
    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

        var sq = new xinf.style.StyleClassElement( "testStyledElement", this );
		sq.autoSize = false;
        sq.bounds.setPosition( 10, 10 );
        sq.bounds.setSize( 90, 20 );

		// setup test stylesheet
		StyleSheet.defaultSheet.add(
			[ "button" ], {
				padding: { l:6, t:3, r:6, b:3 },
				border: {
					l: 	new ImageBorderStyle( 2, "assets/button/button_l.png" ),
					t: 	new ImageBorderStyle( 2, "assets/button/button_t.png" ),
					r: 	new ImageBorderStyle( 2, "assets/button/button_r.png" ),
					b:  new ImageBorderStyle( 2, "assets/button/button_b.png" ),
					tl: new ImageBorderStyle( 2, "assets/button/button_tl.png" ),
					tr: new ImageBorderStyle( 2, "assets/button/button_tr.png" ),
					bl:	new ImageBorderStyle( 2, "assets/button/button_bl.png" ),
					br: new ImageBorderStyle( 2, "assets/button/button_br.png" )
				},
				color: new xinf.ony.Color().fromRGBInt( 0xaa0000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5
			} );
		StyleSheet.defaultSheet.add(
			[ "button", "hover" ], {
				background: new xinf.ony.Color().fromRGBInt( 0xeeeeee ),
				padding: null, color: null, minWidth:null, textAlign:null, border:null
			} );
		StyleSheet.defaultSheet.add(
			[ "button", "hover", "press" ], {
				background: new xinf.ony.Color().fromRGBInt( 0xffaaaa ),
				padding: null, color: null, minWidth:null, textAlign:null, border:null
			} );

		// simulate a button
		var t = new xinf.ony.Text("testT", sq );
		t.text = "Hello World!";
		sq.setChild(t);

		sq.addStyleClass("button");

		sq.addEventListener( xinf.event.Event.MOUSE_OVER, function (e:xinf.event.Event) {
			sq.addStyleClass("hover");
		} );
		sq.addEventListener( xinf.event.Event.MOUSE_OUT, function (e:xinf.event.Event) {
			sq.removeStyleClass("hover");
		} );
		sq.addEventListener( xinf.event.Event.MOUSE_DOWN, function (e:xinf.event.Event) {
			sq.addStyleClass("press");
		} );
		sq.addEventListener( xinf.event.Event.MOUSE_UP, function (e:xinf.event.Event) {
			sq.removeStyleClass("press");
		} );

		screenshotFrame1();
    }
}
