package org.xinf.render;

import org.xinf.render.IRenderer;
import org.xinf.geom.Point;
import org.xinf.geom.Matrix;
import org.xinf.util.CPtr;
import GL;
import GLU;

class GLRenderer implements IRenderer {
    private static var selectBuffer = CPtr.uint_alloc(64);
    private static var view = CPtr.int_alloc(4);
    
    private var tess:Dynamic;
    private var highestID:Int;

    public function new() {
        tess = null;
        highestID = 0;
    }
    
    public function genList() :Int {
        return GL.GenLists(1);
    }
    public function newList( id:Int ) :Void {
        GL.NewList( id, GL.COMPILE );
    }
    public function endList() :Void {
        GL.EndList();
    }
    public function callList( id:Int ) :Void {
        GL.CallList( id );
    }

    public function translate( x:Float, y:Float ) : Void {
        GL.Translatef( x, y, 0.0 );
    }

    public function matrix( m:Matrix ) : Void {
        GL.MultMatrixf( m._v );
    }
    
    public function setColor( r:Float, g:Float, b:Float, a:Float ) : Void {
        GL.Color4f( r, g, b, a );
    }
    
    
    public function tessBeginPolygon() : Void {
        tess = GLU._SimpleTesselator();
        GL.LineWidth( 2 );
        GLU.TessBeginPolygon( tess, CPtr.void_null );
    }
    
    public function tessBeginContour() : Void{
        GLU.TessBeginContour( tess );
    }

    public function tessVertex( x:Float, y:Float ) : Void {
        var _vertex = CPtr.double_alloc(3);
        CPtr.double_set(_vertex,0,x);
        CPtr.double_set(_vertex,1,y);
        CPtr.double_set(_vertex,2,.0);
        GLU.TessVertex( tess, _vertex, CPtr.void_cast(_vertex) );
    }
    
    public function tessCubicCurve( ctrl:Array<Float>, data:Dynamic, n:Int ) : Void {
        GLU._TessCubicCurve( tess, untyped ctrl.__a, data, n );
    }

    public function tessQuadraticCurve( ctrl:Array<Float>, data:Dynamic, n:Int ) : Void {
        GLU._TessQuadraticCurve( tess, untyped ctrl.__a, data, n );
    }
    
    public function tessEndContour() : Void {
        GLU.TessEndContour( tess );
    }
    
    public function tessEndPolygon() : Void {
        GLU.TessEndPolygon( tess );
        tess = null;
    }
    
    public function startFrame() : Void {
        GL.PushMatrix();
    	GL.Viewport( 0, 0, 300, 300 );
        GL.MatrixMode( GL.PROJECTION );
        GL.LoadIdentity();
        GL.MatrixMode( GL.MODELVIEW );
        GL.LoadIdentity();
        
        GL.PixelStorei( GL.UNPACK_ALIGNMENT, 1 );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );

        GL.Enable( GL.BLEND );
        GL.BlendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
        
        GL.ShadeModel( GL.FLAT );
        
        GL.ClearColor( 0, 0, 0.3, 1 );
        GL.Clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
    }

    public function endFrame() : Void {
        GL.PopMatrix();
    }
    
    public function startPick( x:Float, y:Float ) : Void {
        GL.SelectBuffer( 64, selectBuffer );
        
        GL.GetIntegerv( GL.VIEWPORT, view );
        GL.RenderMode( GL.SELECT );
        GL.InitNames();
        
        GL.MatrixMode( GL.PROJECTION );
        GL.PushMatrix();
            
            GL.LoadIdentity();
            GLU.PickMatrix( x, y, 1.0, 1.0, view );
            GL.MatrixMode( GL.MODELVIEW );
    }
    
    public function endPick() : Array<Array<Int>> {
        
        GL.MatrixMode( GL.PROJECTION );
        GL.PopMatrix();
        
        var n_hits = GL.RenderMode( GL.RENDER );
        
        var stacks = new Array<Array<Int>>();
        if( n_hits > 0 ) {
            var i=0; 
            var j=0;
            while( i<n_hits && j<64 ) {
                var n : Int = CPtr.uint_get( selectBuffer, j);
                var objs = new Array<Int>();
                j+=3;
                for( k in 0...n ) {
                    objs.push( CPtr.uint_get( selectBuffer, j ));
                    j++;
                }
                i++;
                stacks.push(objs);
            }
        }
        
        GL.MatrixMode( GL.MODELVIEW );
        
        return stacks.reverse();
    }

    public function pushMatrix() : Void {
        GL.PushMatrix();
    }
    
    public function popMatrix() : Void {
        GL.PopMatrix();
    }
     
    public function pushName( name:Int ) : Void {
        GL.PushName( name );
    }
    
    public function popName() : Void {
        GL.PopName();
    }
}
