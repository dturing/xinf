
import opengl.GL;
import opengl.GLU;
import opengl.GLUT;
import opengl.Helper;

class App {
	public static function main() {
		GLUT.initDisplayMode( GLUT.DOUBLE | GLUT.RGB | GLUT.DEPTH );
		var d = GLUT.createWindow("Hello World");
		var i=0;
		GLUT.setupHandlers({
				display:function() {
						i++;
						GL.clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
						GL.loadIdentity();
						
						GLU.lookAt( .0, .0, 5.,
									.0, .0, .0,
									.0, 1., .0  );
						GL.scale( 1., 1., 1. );
						
						var r = i*5;
						GL.rotate( r*.9, 1., 0., 0. );
						GL.rotate( r*.6, 0., 1., 0. );
						GL.rotate( r*.3, 0., 0., 1. );
						
						GL.color3( 1., 0., 0. );
						solidCube(1.0);

						GL.color3( 1., 1., 1. );
						wireCube(2.0);
						
						GL.flush();
						GLUT.swapBuffers();
					},
				timer:function() {
						GLUT.postRedisplay();
					}
			});
		GLUT.showWindow();


		GL.clearColor( 0, 0, 0, 0 );
		GL.shadeModel( GL.FLAT );
		
		GL.matrixMode( GL.PROJECTION );
		GL.loadIdentity();
		GL.frustum( -1., 1., -1., 1., 1.5, 20. );
		GL.matrixMode( GL.MODELVIEW );
		
		GL.enable( GL.DEPTH_TEST );


		GLUT.mainLoop();
	}
	
	public static function wireCube( size:Float ) :Void {
		var V = GL.vertex3;
		var N = GL.normal3;
	
		var s = size*.5;
		
		GL.begin( GL.LINE_LOOP ); N( 1.0, 0.0, 0.0); V( s,-s, s); V( s,-s,-s); V( s, s,-s); V( s, s, s); GL.end();
		GL.begin( GL.LINE_LOOP ); N( 0.0, 1.0, 0.0); V( s, s, s); V( s, s,-s); V(-s, s,-s); V(-s, s, s); GL.end();
		GL.begin( GL.LINE_LOOP ); N( 0.0, 0.0, 1.0); V( s, s, s); V(-s, s, s); V(-s,-s, s); V( s,-s, s); GL.end();
		GL.begin( GL.LINE_LOOP ); N(-1.0, 0.0, 0.0); V(-s,-s, s); V(-s, s, s); V(-s, s,-s); V(-s,-s,-s); GL.end();
		GL.begin( GL.LINE_LOOP ); N( 0.0,-1.0, 0.0); V(-s,-s, s); V(-s,-s,-s); V( s,-s,-s); V( s,-s, s); GL.end();
		GL.begin( GL.LINE_LOOP ); N( 0.0, 0.0,-1.0); V(-s,-s,-s); V(-s, s,-s); V( s, s,-s); V( s,-s,-s); GL.end();
	}

	public static function solidCube( size:Float ) :Void {
		var V = GL.vertex3;
		var N = GL.normal3;
	
		var s = size*.5;
		GL.begin( GL.QUADS );
			N( 1.0, 0.0, 0.0); V( s,-s, s); V( s,-s,-s); V( s, s,-s); V( s, s, s);
			N( 0.0, 1.0, 0.0); V( s, s, s); V( s, s,-s); V(-s, s,-s); V(-s, s, s);
			N( 0.0, 0.0, 1.0); V( s, s, s); V(-s, s, s); V(-s,-s, s); V( s,-s, s);
			N(-1.0, 0.0, 0.0); V(-s,-s, s); V(-s, s, s); V(-s, s,-s); V(-s,-s,-s);
			N( 0.0,-1.0, 0.0); V(-s,-s, s); V(-s,-s,-s); V( s,-s,-s); V( s,-s, s);
			N( 0.0, 0.0,-1.0); V(-s,-s,-s); V(-s, s,-s); V( s, s,-s); V( s,-s,-s);
		GL.end();
	}
}
