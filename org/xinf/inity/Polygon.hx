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

package org.xinf.inity;

class Polygon extends Object {
    private var contours:Array<Contour>;
    private var tess:Dynamic;
    
    public var length( get_length, null ):Float;
    public function get_length() : Float {
        return contours.length;
    }

    public function new() {
        super();
        contours = new Array<Contour>();
    }

    public function addContour( c:Contour ) {
        contours.push(c);
    }
    

    public function tessBeginPolygon() : Void {
        tess = GLU.SimpleTesselator();
        GL.LineWidth( 2 );
        GLU.TessBeginPolygon( tess, CPtr.void_null );
    }

    public function tessEndPolygon() : Void {
        GLU.TessEndPolygon( tess );
        tess = null;
    }
    
    
    private function _renderGraphics() :Void {
        tessBeginPolygon();
        for( contour in contours ) {
            contour.render( tess );
        }
        
        tessEndPolygon();
    }
    
    private function _render() :Void {
        _renderGraphics();
        super._render();
    }

    private function _renderSimple() :Void {
        _renderGraphics();
        super._renderSimple();
    }
}
