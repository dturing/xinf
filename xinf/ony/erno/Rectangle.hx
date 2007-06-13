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

/**
    Rectangle is a simple Xinfony Object that represents a (guess!)
    Rectangle. It will probably go away.
**/
class Rectangle extends Object, implements xinf.ony.Rectangle  {

    public var x(default,set_x):Float;
    public var y(default,set_y):Float;
    public var width(default,set_width):Float;
    public var height(default,set_height):Float;

    private function set_x(v:Float) {
        x=v; scheduleRedraw(); return x;
    }
    private function set_y(v:Float) {
        y=v; scheduleRedraw(); return y;
    }
    private function set_width(v:Float) {
        width=v; scheduleRedraw(); return width;
    }
    private function set_height(v:Float) {
        height=v; scheduleRedraw(); return height;
    }
    

    public function new() :Void {
        super();
        x=y=width=height=0;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x = getFloatProperty(xml,"x");
        y = getFloatProperty(xml,"y");
        width = getFloatProperty(xml,"width");
        height = getFloatProperty(xml,"height");
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        g.rect( x, y, width, height );
    }
    
}
