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
                padding: { l:0, t:1, r:0, b:1 },
                border: { l:0, t:0, r:0, b:0 },
                color: new Color().fromRGBInt( 0 ),
                background: Color.rgba(0,0,0,0),
                minHeight: 20, minWidth: 50
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "Pane" ], {
                padding: { l:5, t:5, r:5, b:5 },
                border: { l:0, t:0, r:0, b:0 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xbbbbbb )
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "RootContainer" ], {
                padding: { l:15, t:15, r:15, b:15 },
                border: { l:0, t:0, r:0, b:0 },
                color: Color.BLACK,
                background: new Color().fromRGBInt( 0x666666 )
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "VScrollbar" ], {
                padding: { l:0, t:0, r:0, b:0 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xaaaaaa ),
                minWidth:20, minHeight:40
            } );
            /*
        xinf.style.StyleSheet.defaultSheet.add(
            [ "RoundRobin" ], {
                padding: { l:5, t:5, r:5, b:5 },
                border: { l:2, t:2, r:2, b:2 },
                color: new Color().fromRGBInt( 0xff0000 ),
                background: new Color().fromRGBInt( 0xffaaaa )
            } );
            */
        xinf.style.StyleSheet.defaultSheet.add(
            [ "ListBox" ], {
                padding: { l:5, t:2, r:5, b:2 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xdddddd ),
                minWidth:100, minHeight:60
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "ListItem" ], {
                padding: { l:5, t:1, r:5, b:1 },
                color: new Color().fromRGBInt( 0x555555 ),
                minHeight: 20, minWidth:100
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ ":cursor" ], {
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0x888888 )
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "TreeView" ], {
                padding: { l:2, t:1, r:2, b:1 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xdddddd ),
                minWidth:100, minHeight:60
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "TreeItem" ], {
                padding: { l:5, t:1, r:5, b:1 },
                color: new Color().fromRGBInt( 0x555555 ),
                minHeight: 20, minWidth:100
            } );
            
        xinf.style.StyleSheet.defaultSheet.add(
            [ "Thumb" ], {
                padding: { l:0, t:0, r:0, b:0 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0x666666 )
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "Dropdown" ], {
                padding: { l:5, t:2, r:5, b:2 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xdddddd ),
                minHeight: 20, minWidth: 100
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "Slider" ], {
                padding: { l:5, t:2, r:5, b:2 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xdddddd ),
                minHeight: 20, minWidth: 100
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "SliderBar" ], {
                padding: { l:0, t:0, r:0, b:0 },
                border: { l:1, t:1, r:1, b:1 },
                minWidth: 20,
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xdddddd )
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "Button" ], {
                padding: { l:5, t:2, r:5, b:2 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xdddddd ),
                minHeight: 20, minWidth: 100
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "RadioButton" ], {
                padding: { l:5, t:2, r:5, b:2 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: Color.rgba(1,1,1,0.3),
                minHeight: 20, minWidth: 100, selectorWidth: 12
            } ); 
        xinf.style.StyleSheet.defaultSheet.add(
            [ "CheckBox" ], {
                padding: { l:5, t:2, r:5, b:2 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: Color.rgba(1,1,1,0.3),
                minHeight: 20, minWidth: 100, selectorWidth: 12
            } );   
        xinf.style.StyleSheet.defaultSheet.add(
            [ ":press" ], {
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xffffff )
            } );
		xinf.style.StyleSheet.defaultSheet.add(
            [ ":select" ], {
                selectColor: new Color().fromRGBInt( 0x000000 ),
                selectBackgroundColor: new Color().fromRGBInt( 0x000000 )
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ "LineEdit" ], {
                padding: { l:5, t:2, r:5, b:2 },
                border: { l:1, t:1, r:1, b:1 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xdddddd ),
                minHeight: 20, minWidth: 100,
                selectionBackground: Color.rgba(0,0,0,.4),
                selectionForeground: Color.WHITE,
                fontFamily: "_sans",
                fontSize: 12
            } );
        xinf.style.StyleSheet.defaultSheet.add(
            [ ":focus" ], {
                border: { l:2, t:2, r:2, b:2 },
                padding: { l:4, t:1, r:4, b:1 },
                color: new Color().fromRGBInt( 0x0033ff ),
                background: new Color().fromRGBInt( 0xffffff )
            } );
    }
    
}
