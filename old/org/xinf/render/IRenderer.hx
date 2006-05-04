package org.xinf.render;

import org.xinf.geom.Point;
import org.xinf.geom.Matrix;
import org.xinf.display.DisplayObject;

interface IRenderer {
    public function resize( w:Int, h:Int ):Void;

    // display list caching
    public function genList():Int;
    public function newList( id:Int ):Void;
    public function endList():Void;
    public function callList( id:Int ):Void;
    public function _objectChanged( obj:DisplayObject ) :Void;
    public function cacheChangedObjects() :Void;

    // transform
    function translate( x:Float, y:Float ) : Void;
    function scale( x:Float, y:Float ) : Void;
    function matrix( m:Matrix ) : Void;
    
    // pen/fill
    function setColor( r:Float, g:Float, b:Float, a:Float ) : Void;
    
    // tesselation
    public function tessBeginPolygon() : Void;
    public function tessBeginContour() : Void;
    public function tessVertex( x:Float, y:Float ) : Void;
    public function tessCubicCurve( ctrl:Array<Float>, data:Dynamic, n:Int ) : Void;
    public function tessQuadraticCurve( ctrl:Array<Float>, data:Dynamic, n:Int ) : Void;
    public function tessEndContour() : Void;
    public function tessEndPolygon() : Void;
     
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
