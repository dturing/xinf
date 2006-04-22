package org.xinf.render;

import org.xinf.render.IRenderer;
import org.xinf.geom.Point;
import org.xinf.geom.Matrix;
import org.xinf.util.FloatPointer;
import gl.GL;

class GLRenderer implements IRenderer {
    private static var selectBuffer = GL.__glCreateUintBuffer( 64 );

    public function new() {
    }

    public function translate( x:Float, y:Float ) : Void {
        GL._glTranslatef( x, y, 0.0 );
    }

    public function matrix( m:Matrix ) : Void {
        GL._glMultMatrixf( m._v._ptr );
    }
    
    public function setColor( r:Float, g:Float, b:Float, a:Float ) : Void {
        GL._glColor4f( r, g, b, a );
    }
    
    public function polygon( vertices:Array<Point> ) : Void {
        GL._glBegin( GL.GL_POLYGON );
            for( p in vertices ) {
                GL._glVertex2f( p.x, p.y );
            }
        GL._glEnd();
    }
    
    
    public function startFrame() : Void {
        GL._glPushMatrix();
    	GL._glViewport( 0, 0, 320, 240 );
        GL._glMatrixMode( GL.GL_PROJECTION );
        GL._glLoadIdentity();
        GL._glMatrixMode( GL.GL_MODELVIEW );
        GL._glLoadIdentity();
        
      //  GL._glEnable( GL.GL_TEXTURE_2D );
        GL._glEnable( GL.GL_BLEND );
        GL._glBlendFunc( GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA );
        
        GL._glShadeModel( GL.GL_FLAT );
        
        GL._glClearColor( 0, 0, 0.3, 1 );
        GL._glClear( GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT );
    }

    public function endFrame() : Void {
        GL._glPopMatrix();
    }
    
    public function startPick( x:Float, y:Float ) : Void {
        var view = GL.__glCreateIntBuffer(4);
        
        GL._glSelectBuffer( 64, selectBuffer );
        GL._glGetIntegerv( GL.GL_VIEWPORT, view );
        GL._glRenderMode( GL.GL_SELECT );
        GL._glInitNames();
        
        GL._glMatrixMode( GL.GL_PROJECTION );
        GL._glPushMatrix();
            
            GL._glLoadIdentity();
            GL._gluPickMatrix( x, y, 1.0, 1.0, view );
            GL._glMatrixMode( GL.GL_MODELVIEW );
    }
    
    public function endPick() : Array<Array<Int>> {
        
        GL._glMatrixMode( GL.GL_PROJECTION );
        GL._glPopMatrix();
        
        var n_hits = GL._glRenderMode( GL.GL_RENDER );
        
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
        
        GL._glMatrixMode( GL.GL_MODELVIEW );
        
        return stacks;
    }

    public function pushMatrix() : Void {
        GL._glPushMatrix();
    }
    
    public function popMatrix() : Void {
        GL._glPopMatrix();
    }
     
    public function pushName( name:Int ) : Void {
        GL._glPushName( name );
    }
    
    public function popName() : Void {
        GL._glPopName();
    }
}
