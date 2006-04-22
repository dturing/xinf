package org.xinf.display;

import org.xinf.render.IRenderer;
import org.xinf.geom.Point;
import org.xinf.geom.Matrix;

import org.xinf.display.primitive.Primitive;
import org.xinf.display.primitive.Polygon;
import org.xinf.display.primitive.FillColor;

class Graphics {
    private var cmds:Array<Primitive>;
    private var polygon:Polygon;

    public function new() {
        cmds = new Array<Primitive>();
        polygon = null;
    }
    
    public function clear() {
        cmds = new Array<Primitive>();
        polygon = null;
    }
    
    public function beginFill( color:Int, alpha:Float ) : Void {
        var c = new FillColor();
        c.setFromInt( color, alpha );
        _add( c );
        
        polygon = new Polygon(0,0);
    }
    
    public function endFill() : Void {
        if( polygon.length > 0 ) _add( polygon );
        polygon = null;
    }
    
    public function lineTo( x:Float, y:Float ) : Void {
        _assert_poly();
        polygon.addCoordinates( x, y );
    }
    
    public function moveTo( x:Float, y:Float ) : Void {
        if( polygon != null ) {
            endFill();
        }
        polygon = new Polygon(x,y);
    }
    
    public function drawRect( x:Float, y:Float, width:Float, height:Float ) : Void {
        moveTo( x, y );
        lineTo( width, 0 );
        lineTo( width, height );
        lineTo( 0, height );
        lineTo( 0, 0 );
    }
    
    private function _add( p:Primitive ) {
        cmds.push(p);
    }

    private function _assert_poly() {
        if( polygon == null ) throw("invalid render command (no beginFill?)");
    }

    public function _render( r:IRenderer ) {
        for( p in cmds ) {
            p._render(r);
        }
    }
}
