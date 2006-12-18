
import opengl.GL;
import opengl.GLU;
import opengl.GLUT;
import opengl.Helper;

class App {
    public static var i=0;
    public static function step( n:Int ) {
        GLUT.postRedisplay();
        GLUT.setTimerFunc( Math.round(1000/25), step, i );
    }
    
    public static function display() {
        i++;
        GL.clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
        GL.loadIdentity();
        
        GLU.lookAt( .0, .0, 5.,
                    .0, .0, .0,
                    .0, 1., .0  );
        GL.scale( 1., 1., 1. );
        
        var r = i*5;
        GL.rotate( r*.9124, 1., 0., 0. );
        GL.rotate( r*.6423, 0., 1., 0. );
        GL.rotate( r*.2352, 0., 0., 1. );
        
        GL.color3( 1., 0., 0. );
        // solidCube(1.0);
        GLUT.solidCube( 1 );

        GL.color3( 1., 1., 1. );
        GLUT.wireCube(2.0);
    
        
        GL.flush();
        GLUT.swapBuffers();
    }
                        
    public static function main() {
        GLUT.initDisplayMode( GLUT.DOUBLE | GLUT.RGB | GLUT.DEPTH );
        var d = GLUT.createWindow("Hello World");
        
        GLUT.setDisplayFunc( display );
        GLUT.setTimerFunc( Math.round(1000/25), step, 0 );
        
        GLUT.setReshapeFunc( function( w:Int, h:Int ) {
                GL.viewport( 0, 0, w, h );
            } );
        GLUT.setMouseFunc( function( btn:Int, state:Int, x:Int, y:Int ) {
                trace("mouse btn "+btn+" "+state+" @ "+x+","+y );
            } );
        GLUT.setMotionFunc( function( x:Int, y:Int ) {
                trace("motion: "+x+","+y );
            } );
        GLUT.setPassiveMotionFunc( function( x:Int, y:Int ) {
                trace("passive motion: "+x+","+y );
            } );
        GLUT.setKeyboardFunc( function( key:Int, x:Int, y:Int ) {
                var k = if( key>=32 && key <= 128 ) " ('"+String.fromCharCode( key )+"')" else "";
                
                trace("key "+key+k+" @"+x+","+y );
            } );
        GLUT.setSpecialFunc( function( key:Int, x:Int, y:Int ) {
                var k = if( key>=32 && key <= 128 ) " ('"+String.fromCharCode( key )+"')" else "";
                
                trace("special key "+key+k+" @"+x+","+y );
            } );
        GLUT.setExitFunc( function() {
                trace("quit");
            } );
        
        GLUT.showWindow();
        GLUT.postRedisplay();


        GL.clearColor( 0, 0, 0, 0 );
        GL.shadeModel( GL.FLAT );
        
        GL.matrixMode( GL.PROJECTION );
        GL.loadIdentity();
        GL.frustum( -1., 1., -1., 1., 1.5, 20. );
        GL.matrixMode( GL.MODELVIEW );
        
        GL.enable( GL.DEPTH_TEST );


        GLUT.mainLoop();
    }
}
