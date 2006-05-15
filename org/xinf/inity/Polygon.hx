package org.xinf.inity;

class Polygon extends Object {
    private var contours:Array<Contour>;
    private var tess:Dynamic;
    
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
