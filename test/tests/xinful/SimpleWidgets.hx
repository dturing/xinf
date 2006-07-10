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

import xinf.style.StyleSheet;
import xinf.ul.Button;

class SimpleWidgets extends TestCase {
    private var display:xinf.ony.Text;

    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );
		
		setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0xababab ) );
/*
	/////////////////////////////////////////////////////////////////////////////////
	// Label
		StyleSheet.defaultSheet.add(
			[ "Label" ], {
				padding: { l:6, t:3, r:6, b:3 },
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				border: null,
				skin: null, background: null, minWidth: null, textAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Label", ":hover" ], {
				background: new xinf.ony.Color().fromRGBInt( 0xffaaaa ),
				padding: null, color: null,
				border: null,
				skin: null, minWidth: null, textAlign: null
			} );

        var t = new xinf.ul.Label( "testLabel", this );
        t.bounds.setPosition( 10, 10 );
		t.text="Test Label";
		
	/////////////////////////////////////////////////////////////////////////////////
	// Button

		StyleSheet.defaultSheet.add(
			[ "TextButton" ], {
				padding: { l:5, t:2, r:5, b:3 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5
			} );
		StyleSheet.defaultSheet.add(
			[ "TextButton", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/hover/",
				padding: null, minWidth:null, textAlign:null, 
			} );
		StyleSheet.defaultSheet.add(
			[ "TextButton", ":hover", ":press" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:5, t:3, r:5, b:2 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/press/",
				minWidth:null, textAlign:null
			} );
			
        var t = new xinf.ul.TextButton( "testButton", this );
        t.bounds.setPosition( 10, 40 );
		t.contained.text="Click Me.";
		var buttonClicks:Int=0;
		var texts = [ "Thank you", "Thank you", "Thank You", "Thanks", "Thank you very much.", "Thanks, really",
						"Danke","Merci","Gracias","Tak","Thank you","","..." ];
		var stopTexts = [ "Enough!","Ouch!","Stop it!","Aaaaaargh!","AAAAAAAAAAaaaaaaargh!","Please,","I can't stand it any more","Mommy!" ];
		t.addEventListener( xinf.ul.Button.CLICK, function(e:xinf.ony.MouseEvent) {
					var c = if( buttonClicks<texts.length ) texts[buttonClicks] 
							else stopTexts[Math.floor(Math.random()*stopTexts.length)];
					t.contained.text=c;
					buttonClicks++;
				} );
*/

	/////////////////////////////////////////////////////////////////////////////////
	// Input

		StyleSheet.defaultSheet.add(
			[ "Input" ], {
				padding: { l:3, t:3, r:2, b:3 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "input/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 100.,
				textAlign: 0
			} );
		StyleSheet.defaultSheet.add(
			[ "Input", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "input/hover/",
				padding: null, minWidth:null, textAlign:null, 
			} );
		StyleSheet.defaultSheet.add(
			[ "Input", ":focus" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:5, t:3, r:5, b:2 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "input/focus/",
				minWidth:null, textAlign:null
			} );
			
        var t = new xinf.ul.Input( "testInput", this );
        t.bounds.setPosition( 10, 80 );
        t.bounds.setSize( 100, 20 );
		t.text="I feel too long for this Widget.";
//		t.addEventListener( xinf.ul.Button.CLICK, function(e:xinf.event.Event) {
//			} );

	/////////////////////////////////////////////////////////////////////////////////
	// ImageButton
/*
		StyleSheet.defaultSheet.add(
			[ "ImageButton" ], {
				padding: { l:2, t:2, r:2, b:2 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/hover/",
				padding: null, minWidth:null, textAlign:null, 
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton", ":hover", ":press" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:2, t:3, r:2, b:1 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/press/",
				minWidth:null, textAlign:null
			} );
			
        var t = new xinf.ul.ImageButton( "testImageButton", this, "assets/test.png" );
        t.bounds.setPosition( 100, 40 );
		
	/////////////////////////////////////////////////////////////////////////////////
	// Slider
		StyleSheet.defaultSheet.add(
			[ "Label", "combo" ], {
				padding: { l:3, t:1, r:6, b:1 },
				border: { l:2, t:2, r:0, b:2 },
				skin: "slider/box/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 60.,
				textAlign: 1
			} );
		StyleSheet.defaultSheet.add(
			[ "Label", "combo", ":hover" ], {
				border: null, padding: null,
				skin: "slider/box/hover/",
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: null,
				minWidth: null,	textAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Label", "combo", ":focus" ], {
				border: null, padding: null,
				skin: "slider/box/focus/",
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				minWidth: null,	textAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton", "combo" ], {
				padding: { l:1, t:1, r:1, b:1 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "slider/button/",
				textAlign: null, minWidth: 0,
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton", "combo", ":hover" ], {
				skin: "slider/button/hover/",
				border: null, padding: null, textAlign: null, minWidth: 0,
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc )
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton", "combo", ":hover" ], {
				skin: "slider/button/hover/",
				border: null, padding: null, textAlign: null, minWidth: 0,
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc )
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton", "combo", ":press" ], {
				skin: "slider/button/press/",
				padding: { l:1, t:2, r:1, b:0 },
				border: null, textAlign: null, minWidth: 0,
				color: null,
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 )
			} );
		
        var t = new xinf.ul.Slider( "testSlider", this );
		t.bounds.setPosition( 10, 120 );
*/
		screenshotFrame1();
    }
}
