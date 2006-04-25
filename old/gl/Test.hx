package gl;

import gl.GL;
import sdl.SDL;
import org.xinf.geom.Point;

class Test {
    static var r:Float=0;
    static var texture:Int=0;
    
    static function Render() {
        var he:Float=0;
        var hf:Float=0;
        var ve:Float=1;
        var vf:Float=1;
        var w:Float=1;
        var h:Float=1;
    
        GL._glClear( GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT );
        
        GL._glPushMatrix();
        GL._glRotatef( r++, .0, .0, 1. );
        GL._glColor4f(1.,1.,1.,.5);
        GL._glTranslatef(-.5,-.5,.0);
        
        GL._glBindTexture( GL.GL_TEXTURE_2D, texture );
        GL._glBegin( GL.GL_QUADS );
            GL._glTexCoord2f( he, vf );
            GL._glVertex3f  (  0,  0, 0 ); 
            GL._glTexCoord2f( hf, vf );
            GL._glVertex3f  (  w,  0, 0 ); 
            GL._glTexCoord2f( hf, ve );
            GL._glVertex3f  (  w,  h, 0 ); 
            GL._glTexCoord2f( he, ve );
            GL._glVertex3f  (  0,  h, 0 ); 
        GL._glEnd();
        GL._glPopMatrix();
        
        GL._glFlush();
        GL._glFinish();
    }

    static function main() {
        trace("informal neko GL binding test");
        
    /* init SDL */
    
        if( SDL._SDL_Init( SDL.SDL_INIT_VIDEO ) < 0 ) {
            throw("SDL Video Initialization failed.");
        }
                
        if( SDL._SDL_SetVideoMode( 320, 240, 32, SDL.SDL_OPENGL ) == 0 ) {
            throw("SDL SetVideoMode failed.");
        }

    /* init GL */
     	GL._glViewport( 0, 0, 320, 240 );
        GL._glMatrixMode( GL.GL_PROJECTION );
        GL._glLoadIdentity();
        GL._glMatrixMode( GL.GL_MODELVIEW );
        GL._glLoadIdentity();
        
        GL._glEnable( GL.GL_TEXTURE_2D );
        GL._glPixelStorei( GL.GL_UNPACK_ALIGNMENT, 1 );
	    GL._glTexParameteri( GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR );
	    GL._glTexParameteri( GL.GL_TEXTURE_2D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR );
        
        GL._glEnable( GL.GL_BLEND );
        GL._glBlendFunc( GL.GL_SRC_ALPHA, GL.GL_ONE_MINUS_SRC_ALPHA );
        
        GL._glShadeModel( GL.GL_FLAT );
//        GL._glEnable( GL.GL_POLYGON_SMOOTH );
        
        GL._glClearColor( 0, 0, 0.3, 1 );
       

    /* texture */
        var ptr = new org.xinf.util.IntPointer(320*240*4);
        GL.__glCreateTexture( texture, 320, 240 );
        GL.__glTexSubImage2D( texture, new Point(0,0), new Point(1,1), ptr._ptr );
        
        
    /* loop */
        for( i in 0...100 ) {
            Render();
            SDL._SDL_GL_SwapBuffers();
            neko.Sys.sleep(0.1);
        }

        
    }
}
