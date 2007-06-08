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

package xinf.inity.font;

typedef Style = {
    weight:Int,
    slant:Int
}

class FontList {
    
    public var list:Hash<Hash<Style>>;
    
    public function new() :Void {
        list = new Hash<Hash<Style>>();
        xinf.support.Font.listFonts( addFont );
        //print();
    }
    
    public function addFont( familyName:Dynamic, style:Dynamic, weight:Int, slant:Int ) {
        trace("add Font "+familyName+" "+style );
        var n = new String("");
        untyped n.__s = familyName;
        
        var s = new String("");
        untyped s.__s = style;
        
        var f:Hash<Style> = list.get(n);
        if( f==null ) {
            f = new Hash<Style>();
            list.set(n,f);
        }
        
        f.set(s,{weight:weight,slant:slant});
    }
    
    public function getFont( familyName:String, styleName:String ) :Font {
        var f:Hash<Style> = list.get(familyName);
        if( f==null ) return null;
        var s:Style = f.get(styleName);
        if( s==null ) return null;
        
        return Font.getFont( familyName, s.weight, s.slant );
    }
    
}
