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

class SimpleWidgets extends TestCase {
    private var display:xinf.ony.Text;

    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );

	/////////////////////////////////////////////////////////////////////////////////
	// Label
		StyleSheet.defaultSheet.add(
			[ "Label" ], {
				padding: { l:6, t:3, r:6, b:3 },
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				skin: null, background: null, minWidth: null, textAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Label", ":hover" ], {
				background: new xinf.ony.Color().fromRGBInt( 0xaaaaaa ),
				padding: null, color: null,
				skin: null, minWidth: null, textAlign: null
			} );

        var t = new xinf.ul.Label( "testLabel", this );
        t.bounds.setPosition( 10, 10 );
		t.text="Test Label";
		

	/////////////////////////////////////////////////////////////////////////////////
	// Button

		StyleSheet.defaultSheet.add(
			[ "Button" ], {
				padding: { l:6, t:3, r:6, b:3 },
				skin: "button/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5
			} );
		StyleSheet.defaultSheet.add(
			[ "Button", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				skin: "button/hover/",
				padding: null, minWidth:null, textAlign:null, 
			} );
		StyleSheet.defaultSheet.add(
			[ "Button", ":hover", ":press" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:6, t:4, r:6, b:2 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				skin: "button/press/",
				minWidth:null, textAlign:null
			} );
			
        var t = new xinf.ul.Button( "testButton", this );
        t.bounds.setPosition( 10, 40 );
		t.text="Click Me.";
		var buttonClicks:Int=0;
		var texts = [ "", "Thank you", "Thank you", "Thank You", "Thanks", "Thank you very much.", "Thanks, really",
						"Danke","Merci","Gracias","Tak","Thank you","","..." ];
		var stopTexts = [ "Enough!","Ouch!","Stop it!","Aaaaaargh!","AAAAAAAAAAaaaaaaargh!","Please,","I can't stand it any more","Mommy!" ];
		t.addEventListener( xinf.ul.Button.CLICK, function(e:xinf.event.Event) {
					var c = if( buttonClicks<texts.length ) texts[buttonClicks] 
							else stopTexts[Math.floor(Math.random()*stopTexts.length)];
					t.text=c;
					buttonClicks++;
				} );

        screenshotFrame1();
    }
    
    public function displayEvent( e:xinf.event.Event ) {
        display.text = ""+e.type+"\n"+e.data;
    }
}
