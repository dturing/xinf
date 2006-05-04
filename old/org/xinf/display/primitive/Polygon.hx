package org.xinf.display.primitive;

class Polygon extends Primitive {
    private var contours:Array<Contour>;
    
    public property length( get_length, null ):Float;
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
    
    public function _render( r:org.xinf.render.IRenderer ) {
        r.tessBeginPolygon();
        
        for( contour in contours ) {
            contour._render( r );
        }
        
        r.tessEndPolygon();
    }
}
