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

package xinf.ul;

import xinf.erno.Color;

class GrayStyle {
	public static function addToDefault() :Void {
		xinf.style.StyleSheet.defaultSheet.add(
			[ "Label" ], {
				padding: { l:5, t:1, r:5, b:1 },
				border: { l:0, t:0, r:0, b:0 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xdddddd ),
				minWidth: 75., textAlign: .5, verticalAlign: null
			} );
		xinf.style.StyleSheet.defaultSheet.add(
			[ "Pane" ], {
				padding: { l:0, t:0, r:0, b:0 },
				border: { l:0, t:0, r:0, b:0 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xdddddd ),
				minWidth: 75., textAlign: .5, verticalAlign: null
			} );
		xinf.style.StyleSheet.defaultSheet.add(
			[ "VScrollbar" ], {
				padding: { l:0, t:0, r:0, b:0 },
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xaaaaaa ),
				minWidth: 20., textAlign: .5, verticalAlign: null
			} );

		xinf.style.StyleSheet.defaultSheet.add(
			[ "ListBox" ], {
				padding: { l:0, t:0, r:0, b:0 },
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xdddddd ),
				minWidth: 16., textAlign: .5, verticalAlign: null
			} );
		xinf.style.StyleSheet.defaultSheet.add(
			[ ":cursor" ], {
				padding: null,
				border: null,
				color: new Color().fromRGBInt( 0xeeeeee ),
				background: new Color().fromRGBInt( 0x666666 ),
				minWidth: 16., textAlign: .5, verticalAlign: null
			} );

		xinf.style.StyleSheet.defaultSheet.add(
			[ "Thumb" ], {
				padding: { l:0, t:0, r:0, b:0 },
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0x666666 ),
				minWidth: 16., textAlign: .5, verticalAlign: null
			} );

		xinf.style.StyleSheet.defaultSheet.add(
			[ "Dropdown" ], {
				padding: { l:0, t:0, r:0, b:0 },
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xdddddd ),
				minWidth: 16., textAlign: .5, verticalAlign: null
			} );
		xinf.style.StyleSheet.defaultSheet.add(
			[ "Slider" ], {
				padding: { l:0, t:0, r:0, b:0 },
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xdddddd ),
				minWidth: 16., textAlign: .5, verticalAlign: null
			} );

		xinf.style.StyleSheet.defaultSheet.add(
			[ "SliderBar" ], {
				padding: { l:0, t:0, r:0, b:0 },
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xdddddd ),
				minWidth: 16., textAlign: .5, verticalAlign: null
			} );

		xinf.style.StyleSheet.defaultSheet.add(
			[ ":focus" ], {
				padding: null,
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0xeeeeff ),
				background: null,
				minWidth: null,	textAlign: null, verticalAlign: null
			} );

		xinf.style.StyleSheet.defaultSheet.add(
			[ "VBox" ], {
				padding: { l:5, t:5, r:5, b:5 },
				border: { l:1, t:1, r:1, b:1 },
				color: Color.BLACK,
				background: null,
				minWidth: null,	textAlign: null, verticalAlign: null
			} );

		xinf.style.StyleSheet.defaultSheet.add(
			[ "TextButton" ], {
				padding: { l:2, t:2, r:2, b:2 },
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xdddddd ),
				minWidth: 75., textAlign: .5, verticalAlign: null
			} );
		xinf.style.StyleSheet.defaultSheet.add(
			[ ":press" ], {
				padding: { l:2, t:2, r:2, b:2 },
				border: { l:1, t:1, r:1, b:1 },
				color: new Color().fromRGBInt( 0 ),
				background: new Color().fromRGBInt( 0xffffff ),
				minWidth: 75., textAlign: .5, verticalAlign: null
			} );
	}
}
