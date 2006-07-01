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
				padding: { l:6, t:2, r:6, b:4 },
				border: {
					l: 	new ImageBorderStyle( 2, "assets/button/l.png" ),
					t: 	new ImageBorderStyle( 2, "assets/button/t.png" ),
					r: 	new ImageBorderStyle( 2, "assets/button/r.png" ),
					b:  new ImageBorderStyle( 2, "assets/button/b.png" ),
					tl: new ImageBorderStyle( 2, "assets/button/tl.png" ),
					tr: new ImageBorderStyle( 2, "assets/button/tr.png" ),
					bl:	new ImageBorderStyle( 2, "assets/button/bl.png" ),
					br: new ImageBorderStyle( 2, "assets/button/br.png" )
				},
				color: new xinf.ony.Color().fromRGBInt( 0xaa0000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5
			} );
		StyleSheet.defaultSheet.add(
			[ "button", "hover" ], {
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				border: {
					l: 	new ImageBorderStyle( 2, "assets/button/hover/l.png" ),
					t: 	new ImageBorderStyle( 2, "assets/button/hover/t.png" ),
					r: 	new ImageBorderStyle( 2, "assets/button/hover/r.png" ),
					b:  new ImageBorderStyle( 2, "assets/button/hover/b.png" ),
					tl: new ImageBorderStyle( 2, "assets/button/hover/tl.png" ),
					tr: new ImageBorderStyle( 2, "assets/button/hover/tr.png" ),
					bl:	new ImageBorderStyle( 2, "assets/button/hover/bl.png" ),
					br: new ImageBorderStyle( 2, "assets/button/hover/br.png" )
				},
				padding: null, color: null, minWidth:null, textAlign:null, 
			} );
		StyleSheet.defaultSheet.add(
			[ "button", "hover", "press" ], {
				padding: { l:7, t:3, r:5, b:3 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: {
					l: 	new ImageBorderStyle( 2, "assets/button/press/l.png" ),
					t: 	new ImageBorderStyle( 2, "assets/button/press/t.png" ),
					r: 	new ImageBorderStyle( 2, "assets/button/press/r.png" ),
					b:  new ImageBorderStyle( 2, "assets/button/press/b.png" ),
					tl: new ImageBorderStyle( 2, "assets/button/press/tl.png" ),
					tr: new ImageBorderStyle( 2, "assets/button/press/tr.png" ),
					bl:	new ImageBorderStyle( 2, "assets/button/press/bl.png" ),
					br: new ImageBorderStyle( 2, "assets/button/press/br.png" )
				},
				color: null, minWidth:null, textAlign:null
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
