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

class Circle extends Object, implements xinf.ony.Circle  {

    public var cx(default,set_cx):Float;
    public var cy(default,set_cy):Float;
    public var r(default,set_r):Float;
    
    private function set_cx(v:Float) {
        cx=v; scheduleRedraw(); return cx;
    }
    private function set_cy(v:Float) {
        cy=v; scheduleRedraw(); return cy;
    }
    private function set_r(v:Float) {
        r=v; scheduleRedraw(); return r;
    }

    public function new() :Void {
        super();
        cx=cy=r=0;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        cx = getFloatProperty(xml,"cx");
        cy = getFloatProperty(xml,"cy");
        r = getFloatProperty(xml,"r");
    }

    override public function drawContents( g:Renderer ) :Void {
        if( r!=0 ) {
            super.drawContents(g);
            g.ellipse( cx, cy, r, r );
        }
    }
    
}
