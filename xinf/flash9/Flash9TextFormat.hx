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

package xinf.flash9;

class Flash9TextFormat extends xinf.erno.TextFormat {
    var measure:flash.text.TextField;


    public function new( ?family:String,  ?size:Float, ?bold:Bool, ?italic:Bool ) :Void {
        super( family, size, bold, italic );
        
        var tf = new flash.text.TextField();
        tf.selectable = false;
        tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
        measure = tf;
    }
    
    override public function textSize( text:String ) :{ x:Float, y:Float } {
        assureLoaded();
        measure.defaultTextFormat = format;
        measure.text = text;
        return {x:measure.width,y:measure.height};
    }

    override public function load() :Void {
        format = new flash.text.TextFormat();
        format.font = family;
		if( format.font=="" ) format.font="_sans"; // FIXME
        format.size = size;
		if( format.size<=0 ) format.size=12; // FIXME
        format.leftMargin = 0;
    }
}
