package org.xinf.display;

import org.xinf.render.IRenderer;
import org.xinf.geom.Point;
import org.xinf.geom.Matrix;

import org.xinf.display.primitive.Primitive;
import org.xinf.display.primitive.Polygon;
import org.xinf.display.primitive.Contour;
import org.xinf.display.primitive.FillColor;

class Graphics {
    private var cmds:Array<Primitive>;
    private var contour:Contour;
    private var polygon:Polygon;

    public function new() {
        cmds = new Array<Primitive>();
        polygon = null;
        contour = null;
    }
    
    public function clear() {
        // TODO: changed
        cmds = new Array<Primitive>();
        polygon = null;
        contour = null;
    }
    
    public function beginFill( color:Int, alpha:Float ) : Void {
        var c = new FillColor();
        c.setFromInt( color, alpha );
        _add( c );
        
        polygon = new Polygon();
        contour = new Contour(0,0);
    }
    
    public function endFill() : Void {
        if( contour.length > 0 ) polygon.addContour( contour );
        contour = null;
        if( polygon.length > 0 ) _add(polygon);
        polygon = null;
    }
    
    public function lineTo( x:Float, y:Float ) : Void {
        contour.addCoordinates( x, y );
    }
    
    public function moveTo( x:Float, y:Float ) : Void {
        if( contour != null ) {
            if( contour.length > 0 ) polygon.addContour( contour );
            contour = null;
        }
        contour = new Contour(x,y);
    }

    public function cubicTo( c1:Point, c2:Point, p1:Point ) : Void {
        contour.addCubic( c1, c2, p1 );
    }

    public function quadraticTo( c:Point, p1:Point ) : Void {
        contour.addQuadratic( c, p1 );
    }
    
    public function drawRect( x:Float, y:Float, width:Float, height:Float ) : Void {
        moveTo( x, y );
        lineTo( width, 0 );
        lineTo( width, height );
        lineTo( 0, height );
        lineTo( 0, 0 );
    }
    
    private function _add( c:Primitive ) {
        // TODO: changed
        cmds.push(c);
    }
    public function _render( r:IRenderer ) {
        for( p in cmds ) {
            p._render(r);
        }
    }
}
