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

class XTextFormat extends xinf.erno.TextFormat {

    public function new( ?family:String,  ?size:Float, ?bold:Bool, ?italic:Bool ) :Void {
        super( family, size, bold, italic );
    }

    public function textSize( text:String ) :{ x:Float, y:Float } {
        assureLoaded();
        return font.textSize( text, size );
    }

    public function load() :Void {
        super.load();
        try {
            font = Font.getFont( family ); // FIXME: bold, italic?
        } catch(e:Dynamic) {
            font = Font.getFont("_sans");
        }
    }
    
}
