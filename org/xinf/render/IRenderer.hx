package org.xinf.render;

import org.xinf.geom.Point;
import org.xinf.geom.Matrix;

interface IRenderer {
    // transform
    function translate( x:Float, y:Float ) : Void;
    function matrix( m:Matrix ) : Void;
    
    // pen/fill
    function setColor( r:Float, g:Float, b:Float, a:Float ) : Void;
    
    // paint
    function polygon( vertices:Array<Point> ) : Void;
    public function curve( ctrlpoints:Array<Point> ) : Void;
    
    // manage
    function startFrame() : Void;
    function endFrame() : Void;
    
    function startPick( x:Float, y:Float ) : Void;
    function endPick() : Array<Array<Int>>;

    function pushMatrix() : Void;
    function popMatrix() : Void;
    
    function pushName( name:Int ) : Void;
    function popName() : Void;
}
