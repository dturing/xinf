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

    public function new() {
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
    
    public function polygon( vertices:Array<Point> ) : Void {
        var t = GLU._SimpleTesselator();
        GLU.TessBeginPolygon( t, CPtr.void_null );
        GLU.TessBeginContour( t );
        
        for( vertex in vertices ) {
            var v = CPtr.double_alloc(3);
            CPtr.double_set(v,0,vertex.x);
            CPtr.double_set(v,1,vertex.y);
            CPtr.double_set(v,2,.0);
            GLU.TessVertex( t, v, CPtr.void_cast(v) );
        }
        GLU.TessEndContour( t );
        GLU.TessEndPolygon( t );      
    }
    
    public function curve( ctrlpoints:Array<Point> ) : Void {
        var cps = CPtr.double_alloc( ctrlpoints.length*3 );
        var n:Int = 0;
        for( p in ctrlpoints ) {
            CPtr.double_set( cps, n++, p.x );
            CPtr.double_set( cps, n++, p.y );
            CPtr.double_set( cps, n++, .0 );
        }
        
        GL.Map1d_01( GL.MAP1_VERTEX_3, 3, 4, cps );
        GL.Enable( GL.MAP1_VERTEX_3 );
        
        GL.LineWidth( 5 );
        GL.Begin( GL.LINE_STRIP );

        var v:Float = 0.0;
        var s:Float = 1.0/50.0;
        for( i in 0...51 ) {
            GL.EvalCoord1f( v );
            v+=s;
        }
        GL.End();
    }
    
    public function startFrame() : Void {
        GL.PushMatrix();
    	GL.Viewport( 0, 0, 320, 240 );
        GL.MatrixMode( GL.PROJECTION );
        GL.LoadIdentity();
        GL.MatrixMode( GL.MODELVIEW );
        GL.LoadIdentity();
        
        GL.Enable( GL.TEXTURE_2D );
        GL.PixelStorei( GL.UNPACK_ALIGNMENT, 1 );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );

        GL.Enable( GL.BLEND );
        GL.BlendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
        
        GL.ShadeModel( GL.FLAT );
//        GL.Enable( GL.POLYGON_SMOOTH );
        
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
                j+=3; // TODO why?
                for( k in 0...n ) {
                    objs.push( CPtr.uint_get( selectBuffer, j ));
                    j++;
                }
                i++;
                stacks.push(objs);
            }
        }
        
        GL.MatrixMode( GL.MODELVIEW );
        
        return stacks;
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
