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
import xinf.ul.ListModel;

class SimpleWidgets extends TestCase {
    private var display:xinf.ony.Text;

    public function new( parent:xinf.ony.Element ) :Void {
        super( parent, 1.0 );
		
		setBackgroundColor( new xinf.ony.Color().fromRGBInt( 0xababab ) );


	/////////////////////////////////////////////////////////////////////////////////
	// Button

		StyleSheet.defaultSheet.add(
			[ "TextButton" ], {
				padding: { l:6, t:3, r:6, b:4 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "TextButton", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/hover/",
				padding: null, minWidth:null, textAlign:null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "TextButton", ":hover", ":press" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:6, t:4, r:6, b:3 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/press/",
				minWidth:null, textAlign:null, verticalAlign: null
			} );
			
        var t = new xinf.ul.TextButton( "testButton", this );
        t.bounds.setPosition( 10, 10 );
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
				textAlign: 0, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Input", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "input/hover/",
				padding: null, minWidth:null, textAlign:null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Input", ":focus" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:3, t:3, r:2, b:3 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "input/focus/",
				minWidth:null, textAlign:null, verticalAlign: null
			} );
			
        var t = new xinf.ul.Input( "testInput", this );
        t.bounds.setPosition( 10, 40 );
        t.bounds.setSize( 100, 20 );
		t.text="I feel too long for this Widget.";

        var t2 = new xinf.ul.Input( "testInput2", this );
        t2.bounds.setPosition( 10, 70 );
        t2.bounds.setSize( 100, 20 );
		t2.text="Edit me!";

	/////////////////////////////////////////////////////////////////////////////////
	// ImageButton
/*
		StyleSheet.defaultSheet.add(
			[ "ImageButton" ], {
				padding: { l:3, t:3, r:3, b:3 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 75.,
				textAlign: .5, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/hover/",
				padding: null, minWidth:null, textAlign:null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton", ":hover", ":press" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:3, t:4, r:3, b:2 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "button/press/",
				minWidth:null, textAlign:null, verticalAlign: null
			} );
			
        var t = new xinf.ul.ImageButton( "testImageButton", this, "assets/test.png" );
        t.bounds.setPosition( 100, 40 );
*/        
	/////////////////////////////////////////////////////////////////////////////////
	// Slider
		StyleSheet.defaultSheet.add(
			[ "Label" ],
			new ParentSelector( new ClassNameSelector( ["Slider"] ) ), 
			{
				padding: { l:3, t:3, r:6, b:3 },
				border: { l:2, t:2, r:0, b:2 },
				skin: "slider/box/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 60.,
				textAlign: 1, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Label" ],
			new ParentSelector( new ClassNameSelector( ["Slider",":hover"] ) ), 
			{
				border: null, padding: null,
				skin: "slider/box/hover/",
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: null,
				minWidth: null,	textAlign: null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Label" ],
			new ParentSelector( new ClassNameSelector( ["Slider",":focus"] ) ), 
			{
				border: null, padding: null,
				skin: "slider/box/focus/",
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				minWidth: null,	textAlign: null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton" ],
			new ParentSelector( new ClassNameSelector( ["Slider"] ) ), 
			{
				padding: { l:2, t:2, r:2, b:2 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "slider/button/",
				textAlign: null, verticalAlign: .5, minWidth: 0,
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton" ],
			new ParentSelector( new ClassNameSelector( ["Slider",":hover"] ) ), 
			{
				skin: "slider/button/hover/",
				border: null, padding: null, textAlign: null, verticalAlign: null, minWidth: 0,
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc )
			} );
		
        var t = new xinf.ul.Slider( "testSlider", this );
		t.bounds.setPosition( 10, 100 );

	/////////////////////////////////////////////////////////////////////////////////
	// VScrollbar
		StyleSheet.defaultSheet.add(
			[ "VScrollbar" ], {
				padding: { l:0, t:0, r:0, b:0 },
				color: new xinf.ony.Color().fromRGBInt( 0 ),
				background: new xinf.ony.Color().fromRGBInt( 0xc5c5c5 ),
				border: { l:1, t:0, r:0, b:0 },
				skin: "vscrollbar/",
				minWidth: null, textAlign: null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton" ],
			new ParentSelector( new ClassNameSelector( ["VScrollbar"] ) ), 
			{
				padding: { l:4, t:5, r:3, b:5 },
				border: { l:2, t:2, r:1, b:2 },
				skin: "vscrollbar/thumb/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 0,
				textAlign: .5, verticalAlign: .5
			} );


	/////////////////////////////////////////////////////////////////////////////////
	// ListBox
		StyleSheet.defaultSheet.add(
			[ "ListBox" ], {
				padding: { l:4, t:2, r:4, b:2 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "listbox/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 100.,
				textAlign: 0, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ListBox", ":hover" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "listbox/hover/",
				padding: null, minWidth:null, textAlign:null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ListBox", ":focus" ], {
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:3, t:3, r:2, b:3 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "listbox/focus/",
				minWidth:null, textAlign:null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Label" ],
			new AncestorSelector( new ClassNameSelector( ["ListBox"] ) ), 
			{
				padding: { l:3, t:2, r:3, b:2 },
				border: { l:1, t:1, r:1, b:1 },
				skin: null,
				color: new xinf.ony.Color().fromRGBInt( 0 ),
				background: null, minWidth: null, textAlign: 0, verticalAlign: .5
			} );
		StyleSheet.defaultSheet.add(
			[ "Label", ":hover" ],
			new AncestorSelector( new ClassNameSelector( ["ListBox"] ) ), 
			{
				padding: { l:3, t:2, r:3, b:2 },
				border: { l:1, t:1, r:1, b:1 },
				skin: null,
				color: new xinf.ony.Color().fromRGBInt( 0 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: null,	textAlign: 0, verticalAlign: .5
			} );

		var model = new SimpleListModel();
        for( i in 0...20 ) {
            model.addItem("Item "+i);
        }

        var t = new xinf.ul.ListBox( "testListbox", this, model );
        t.bounds.setPosition( 150, 10 );
        t.bounds.setSize( 100, 80 );

	/////////////////////////////////////////////////////////////////////////////////
	// Dropdown
		StyleSheet.defaultSheet.add(
			[ "Label" ],
			new ParentSelector( new ClassNameSelector( ["Dropdown"] ) ), 
			{
				padding: { l:3, t:3, r:6, b:3 },
				border: { l:2, t:2, r:0, b:2 },
				skin: "slider/box/",
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
				minWidth: 60.,
				textAlign: 0, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Label" ],
			new ParentSelector( new ClassNameSelector( ["Dropdown",":hover"] ) ), 
			{
				border: null, padding: null,
				skin: "slider/box/hover/",
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: null,
				minWidth: null,	textAlign: null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "Label" ],
			new ParentSelector( new ClassNameSelector( ["Dropdown",":open"] ) ), 
			{
				border: null, padding: null,
				skin: "slider/box/focus/",
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				minWidth: null,	textAlign: null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton" ],
			new ParentSelector( new ClassNameSelector( ["Dropdown"] ) ), 
			{
				padding: { l:6, t:6, r:6, b:6 },
				border: { l:2, t:2, r:2, b:2 },
				skin: "slider/button/",
				textAlign: null, verticalAlign: .5, minWidth: 0,
				color: new xinf.ony.Color().fromRGBInt( 0x333333 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc ),
			} );
		StyleSheet.defaultSheet.add(
			[ "ImageButton" ],
			new ParentSelector( new ClassNameSelector( ["Dropdown",":hover"] ) ), 
			{
				skin: "slider/button/hover/",
				border: null, padding: null, textAlign: null, verticalAlign: null, minWidth: 0,
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xcccccc )
			} );
		StyleSheet.defaultSheet.add(
			[ "ListBox" ],
			new ParentSelector( new ClassNameSelector( ["Dropdown"] ) ),
			{
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:2, r:2, b:2 },
				skin: "listbox/hover/",
				padding: null, minWidth:null, textAlign:null, verticalAlign: null
			} );
		StyleSheet.defaultSheet.add(
			[ "ListBox", ":focus" ],
			new ParentSelector( new ClassNameSelector( ["Dropdown"] ) ),
			{
				color: new xinf.ony.Color().fromRGBInt( 0x000000 ),
				padding: { l:3, t:1, r:2, b:3 },
				background: new xinf.ony.Color().fromRGBInt( 0xf2f2f2 ),
				border: { l:2, t:0, r:2, b:2 },
				skin: "listbox/focus/",
				minWidth:null, textAlign:null, verticalAlign: null
			} );
		
        var t = new xinf.ul.Dropdown( "testDropdown", this, model );
		t.bounds.setPosition( 10, 130 );

		screenshotFrame1();
    }
}
