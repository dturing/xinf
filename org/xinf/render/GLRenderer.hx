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
        glTranslatef( x, y, 0.0 );
    }

    public function matrix( m:Matrix ) : Void {
        glMultMatrixf( m._v._ptr );
    }
    
    public function setColor( r:Float, g:Float, b:Float, a:Float ) : Void {
        glColor4f( r, g, b, a );
    }
    
    public function polygon( vertices:Array<Point> ) : Void {
        glBegin( GL_POLYGON );
            for( p in vertices ) {
                glVertex2f( p.x, p.y );
            }
        glEnd();
    }
    
    
    public function startFrame() : Void {
        glPushMatrix();
    	glViewport( 0, 0, 320, 240 );
        glMatrixMode( GL_PROJECTION );
        glLoadIdentity();
        glMatrixMode( GL_MODELVIEW );
        glLoadIdentity();
        
        glEnable( GL_TEXTURE_2D );
        glPixelStorei( GL_UNPACK_ALIGNMENT, 1 );
	    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

        glEnable( GL_BLEND );
        glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
        
        glShadeModel( GL_FLAT );
//        glEnable( GL_POLYGON_SMOOTH );
        
        glClearColor( 0, 0, 0.3, 1 );
        glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
        
        
    }

    public function endFrame() : Void {
        glPopMatrix();
    }
    
    public function startPick( x:Float, y:Float ) : Void {
        var view = GL.__glCreateIntBuffer(4);
        
        glSelectBuffer( 64, selectBuffer );
        glGetIntegerv( GL_VIEWPORT, view );
        glRenderMode( GL_SELECT );
        glInitNames();
        
        glMatrixMode( GL_PROJECTION );
        glPushMatrix();
            
            glLoadIdentity();
            gluPickMatrix( x, y, 1.0, 1.0, view );
            glMatrixMode( GL_MODELVIEW );
    }
    
    public function endPick() : Array<Array<Int>> {
        
        glMatrixMode( GL_PROJECTION );
        glPopMatrix();
        
        var n_hits = glRenderMode( GL_RENDER );
        
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
        
        glMatrixMode( GL_MODELVIEW );
        
        return stacks;
    }

    public function pushMatrix() : Void {
        glPushMatrix();
    }
    
    public function popMatrix() : Void {
        glPopMatrix();
    }
     
    public function pushName( name:Int ) : Void {
        glPushName( name );
    }
    
    public function popName() : Void {
        glPopName();
    }
}
