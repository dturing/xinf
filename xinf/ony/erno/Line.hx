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

package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Color;


class Line extends Object, implements xinf.ony.Line  {

    public var x1(default,set_x1):Float;
    public var y1(default,set_y1):Float;
    public var x2(default,set_x2):Float;
    public var y2(default,set_y2):Float;

    private function set_x1(v:Float) {
        x1=v; scheduleRedraw(); return x1;
    }
    private function set_y1(v:Float) {
        y1=v; scheduleRedraw(); return y1;
    }
    private function set_x2(v:Float) {
        x2=v; scheduleRedraw(); return x2;
    }
    private function set_y2(v:Float) {
        y2=v; scheduleRedraw(); return y2;
    }
    

    public function new() :Void {
        super();
        x1=y1=x2=y2=0;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x1 = getFloatProperty(xml,"x1");
        y1 = getFloatProperty(xml,"y1");
        x2 = getFloatProperty(xml,"x2");
        y2 = getFloatProperty(xml,"y2");
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        g.startShape();
            g.startPath( x1, y1 );
            g.lineTo( x2, y2 );
            g.endPath();
        g.endShape();
    }
    
}
