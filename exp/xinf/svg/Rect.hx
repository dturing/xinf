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

package xinf.svg;

import xinf.erno.Renderer;

/**
    SVG Rectangle element.
**/

class Rect extends Element {
    public var x:Float;
    public var y:Float;
    public var w:Float;
    public var h:Float;

    public function new() :Void {
        super();
        x=y=w=h=0.;
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        x = getFloatProperty(xml,"x");
        y = getFloatProperty(xml,"y");
        w = getFloatProperty(xml,"width");
        h = getFloatProperty(xml,"height");
		moveTo( x, y );
		resize( w, h );
    }

    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        g.rect( x,y,w,h );
    }
    
}
