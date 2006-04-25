package org.xinf.render;

import org.xinf.render.IRenderer;
import org.xinf.geom.Point;
import org.xinf.geom.Matrix;
import org.xinf.util.FloatPointer;
import GL;

class GLRenderer implements IRenderer {
    private static var selectBuffer = GL.__GL.CreateUintBuffer( 64 );

    public function new() {
    }

    public function translate( x:Float, y:Float ) : Void {
        GL.Translatef( x, y, 0.0 );
    }

    public function matrix( m:Matrix ) : Void {
        GL.MultMatrixf( m._v._ptr );
    }
    
    public function setColor( r:Float, g:Float, b:Float, a:Float ) : Void {
        GL.Color4f( r, g, b, a );
    }
    
    public function polygon( vertices:Array<Point> ) : Void {
        GL.Begin( GL.POLYGON );
            for( p in vertices ) {
                GL.Vertex2f( p.x, p.y );
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
        var view = GL.__GL.CreateIntBuffer(4);
        
        GL.SelectBuffer( 64, selectBuffer );
        GL.GetIntegerv( GL.VIEWPORT, view );
        GL.RenderMode( GL.SELECT );
        GL.InitNames();
        
        GL.MatrixMode( GL.PROJECTION );
        GL.PushMatrix();
            
            GL.LoadIdentity();
            GL.uPickMatrix( x, y, 1.0, 1.0, view );
            GL.MatrixMode( GL.MODELVIEW );
    }
    
    public function endPick() : Array<Array<Int>> {
        
        GL.MatrixMode( GL.PROJECTION );
        GL.PopMatrix();
        
        var n_hits = GL.RenderMode( GL.RENDER );
        
        var stacks = new Array<Array<Int>>();
        if( n_hits > 0 ) {
            var hits = GL.__glMakeArrayUint( selectBuffer, 64 );

            var i=0; 
            var j=0;
            while( i<n_hits && j<64 ) {
                var n : Int = hits[j];
                var objs = new Array<Int>();
                j+=3;
                for( k in 0...n ) {
                    objs.push(hits[j]);
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
