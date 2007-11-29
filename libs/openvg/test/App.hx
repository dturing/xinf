
import openvg.VG;
import opengl.GL;
import opengl.GLU;
import opengl.GLUT;
import cptr.CPtr;

class App {
    public static var i=0;
    public static function step( n:Int ) {
        GLUT.postRedisplay();
		GLUT.setTimerFunc( Math.round(1000/25), step, i );
    }

	public static var testPath:Int;
	public static var gllist:Int;
	public static var testStroke:Int;
	public static var testFill:Int;

	public static function createStar() {
		var segs = CPtr.uchar_alloc( 11 );
		CPtr.uchar_from_array( segs, untyped [
			VG.MOVE_TO, VG.LINE_TO_REL, VG.LINE_TO_REL, VG.LINE_TO_REL,
			VG.LINE_TO_REL, VG.LINE_TO_REL, VG.LINE_TO_REL, VG.LINE_TO_REL,
			VG.LINE_TO_REL, VG.LINE_TO_REL, VG.CLOSE_PATH 
			].__a );
		var data = CPtr.float_alloc( 20 );
		CPtr.float_from_array( data, untyped [
				0.,50., 15.,-40., 45.,0., -35.,-20.,
				15.,-40., -40.,30., -40.,-30., 15.,40.,
				-35.,20., 45.,0.
			].__a );
		var cstroke = CPtr.float_alloc( 4 );
		CPtr.float_from_array( cstroke, untyped [ 0.,0.,1., .6 ].__a );
		var cfill = CPtr.float_alloc( 4 );
		CPtr.float_from_array( cfill, untyped [ 1.,0.,0., .6 ].__a );
		
		testPath = VG.createPath( 0 /* VG.PATH_FORMAT_STANDARD */, VG.PATH_DATATYPE_F,
			1,0,0,0, VG.PATH_CAPABILITY_ALL );
			
		VG.appendPathData(testPath, 11, segs, data);
			trace("path: "+testPath );
			
		testStroke = VG.createPaint();
		VG.setParameterfv( testStroke, VG.PAINT_COLOR, 4, cstroke );
		VG.setPaint( testStroke, VG.STROKE_PATH );
		
		testFill = VG.createPaint();
		VG.setParameterfv( testFill, VG.PAINT_COLOR, 4, cfill );
		VG.setPaint( testFill, VG.FILL_PATH );
		
		gllist = GL.genLists(1);
		VG.setf( VG.STROKE_LINE_WIDTH, 10. );
		VG.setf( VG.STROKE_JOIN_STYLE, VG.JOIN_ROUND );
		
        GL.newList( gllist, GL.COMPILE );
		//VG.translate( 100, 100 );
		//VG.scale( 3, 3 );
		VG.drawPath( testPath, VG.FILL_PATH );
		VG.drawPath( testPath, VG.STROKE_PATH );
		GL.endList();

	}
	
    public static function display() {
        i++;
		
		var cc = CPtr.float_alloc( 4 );
		CPtr.float_from_array( cc, untyped [ 0.,0.,0., 1. ].__a );
		VG.setfv( VG.CLEAR_COLOR, 4, cc );
		VG.clear( 0, 0, 500, 500 );
		VG.loadIdentity();
		
		trace(i);

		GL.pushMatrix();
		GL.translate( 100,100,0 );
		GL.scale( 3, 3, 3 );
		
		GL.pushMatrix();
		GL.rotate( i, 0, 0, 1);
		GL.callList(gllist);
		GL.popMatrix();

		
		GL.pushMatrix();
		GL.translate( i, 0, 0);
		GL.callList(gllist);
		GL.popMatrix();

		GL.popMatrix();

		/*
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
    
        */
        GL.flush();
        GLUT.swapBuffers();
		
		trace("VG Err: "+VG.getError() );
    }
                        
    public static function main() {
	//trace(""+GLUT.RGBA+" "+GLUT.DOUBLE+" "+GLUT.ALPHA+" "+GLUT.STENCIL+" "+GLUT.MULTISAMPLE );
        GLUT.initDisplayMode( GLUT.RGBA | GLUT.DOUBLE | GLUT.ALPHA | GLUT.STENCIL | GLUT.MULTISAMPLE );
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
        GLUT.setEntryFunc( function( state:Int ) {
                trace("entry: "+state );
            } );
        
// FIXME: setting this consumes CPU when window invisible...		
        GLUT.setVisibilityFunc( function( state:Int ) {
                trace("window visibility: "+state );
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

  VG.createContextSH();
		createStar();
		
		GL.matrixMode( GL.PROJECTION );
		GL.loadIdentity();
		GLU.ortho2D( 0., 1024., 0., 768. );
		GL.matrixMode( GL.MODELVIEW );
		GL.loadIdentity();
		

/*
        GL.clearColor( 0, 0, 0, 0 );
        GL.shadeModel( GL.FLAT );
        
        GL.matrixMode( GL.PROJECTION );
        GL.loadIdentity();
        GL.frustum( -1., 1., -1., 1., 1.5, 20. );
        GL.matrixMode( GL.MODELVIEW );
        
        GL.enable( GL.DEPTH_TEST );

*/
        GLUT.mainLoop();
    }
}
