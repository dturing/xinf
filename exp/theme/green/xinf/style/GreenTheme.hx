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

package xinf.style;

import xinf.erno.Color;
import xinf.style.StyleSheet;

class GreenTheme extends Theme {
    
    public static function __init__() :Void {
        Theme.theme = new GreenTheme();
    }

    override public function info() {
        return {
            name: "Green",
            description: "xinf's default look - a green image-based theme",
            copyright: "(LGPL) 2006-7, Daniel Fischer",
            url: "http://xinf.org/trac/wiki/GreenTheme",
        };
    }

    public function addToDefault() :Void {
        var pfx="skin/";
        #if flash9
            pfx = "library://"+pfx;
        #end
        var BevelOut = new ImageBorder( pfx+"BevelOut", 5 );
        var BevelOutFocus = new ImageBorder( pfx+"BevelOutFocus", 5 );
        var BevelIn = new ImageBorder( pfx+"BevelIn", 5 );
        var BevelInFocus = new ImageBorder( pfx+"BevelInFocus", 5 );
    
        var Field = new ScaledImageFill( pfx+"FieldBg", 3 );
        var BevelInBg = new ScaledImageFill( pfx+"BevelInBg", 3 );
        var BevelOutBg = new ScaledImageFill( pfx+"BevelOutBg", 3 );
    
        StyleSheet.defaultSheet.add(
            [ "Label" ], {
                border: { l:0, t:0, r:0, b:0 },
                padding: { l:3, t:2, r:3, b:2 },
                minHeight: 20, minWidth: 50,
                fontFamily: "_sans", fontSize: 12.,
                color: new Color().fromRGBInt( 0 ),
            } );

        StyleSheet.defaultSheet.add(
            [ "Pane" ], {
                padding: { l:3, t:3, r:3, b:3 },
                border: { l:5, t:5, r:5, b:5 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xbbbbbb ),
                minHeight: 25, minWidth: 100,
                fontFamily: "_sans", fontSize: 12.,
                selectColor: new Color().fromRGBInt( 0x73d216 ),
                selectBackground: new Color().fromRGBInt( 0x73d216 ),
                skin: new Skin( BevelIn, Field ),
            } );
            
        StyleSheet.defaultSheet.add(
            [ "RootContainer" ], {
                padding: { l:25, t:25, r:25, b:25 },
                border: { l:0, t:0, r:0, b:0 },
                color: Color.BLACK,
                background: Color.RED,
                skin: new Skin( BevelIn, Field ),
            } );

        StyleSheet.defaultSheet.add(
            [ "ListBox" ], {
                border: { l:5, t:5, r:5, b:5 },
                padding: { l:-2, t:-2, r:-2, b:-2 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xdddddd ),
                minWidth:100, minHeight:60,
                skin: new Skin( BevelIn, Field ),
            } );
        StyleSheet.defaultSheet.add(
            [ "ListItem" ], {
                padding: { l:5, t:2, r:5, b:0 },
                color: new Color().fromRGBInt( 0x555555 ),
                minHeight: 20, minWidth:100
            } );
        StyleSheet.defaultSheet.add(
            [ ":cursor" ], {
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0x73d216 )
            } );

        StyleSheet.defaultSheet.add(
            [ "LineEdit" ], {
                padding: { l:3, t:0, r:3, b:0 },
                border: { l:5, t:5, r:5, b:5 },
                color: new Color().fromRGBInt( 0 ),
                background: new Color().fromRGBInt( 0xbbbbbb ),
                minHeight: 25, minWidth: 100,
                fontFamily: "_sans", fontSize: 12.,
                skin: new Skin( BevelIn, Field ),
            } );


        StyleSheet.defaultSheet.add(
            [ ":focus" ], {
                border: { l:5, t:5, r:5, b:5 },
                skin: new Skin( BevelInFocus, Field ),
            } );
            
        StyleSheet.defaultSheet.add(
            [ "Button" ], {
                border: { l:5, t:5, r:5, b:5 },
                padding: { l:2, t:2, r:2, b:2 },
                minWidth: 75,
                skin: new Skin( BevelOut, BevelOutBg ),
            } );
        StyleSheet.defaultSheet.add(
            [ "Button", ":focus" ], {
                skin: new Skin( BevelOutFocus, BevelOutBg ),
            } );
        StyleSheet.defaultSheet.add(
            [ "Button", ":press" ], {
                padding: { l:2, t:3, r:2, b:1 },
                skin: new Skin( BevelOutFocus, BevelInBg ),
            } );
		StyleSheet.defaultSheet.add(
            [ ":select" ], {
            } );
            
            
		StyleSheet.defaultSheet.add(
            [ "Dropdown" ], {
                padding: { l:0, t:-5, r:-5, b:-5 },
            } );
        StyleSheet.defaultSheet.add(
            [ "Pane" ],
            new ParentSelector( new ClassNameSelector(["Dropdown"]) ), 
            {
                border: { l:5, t:5, r:5, b:5 },
                padding: { l:2, t:2, r:2, b:2 },
                minHeight: 25, minWidth: 25,
                skin: new Skin( BevelOut, BevelOutBg ),
            } );
        StyleSheet.defaultSheet.add(
            [ "Label" ],
            new ParentSelector( new ClassNameSelector(["Dropdown"]) ), 
            {
                padding: { l:5, t:5, r:5, b:5 },
            } );
    }
    
}
