/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import opengl.GL;
import opengl.GLU;
import opengl.GLFW;

class App {
	public static var i=0;
	
	public static function wireCube( dSize:Float ) {
		var s = dSize*.5;
		GL.begin( GL.LINE_LOOP );
			GL.vertex3( s,-s, s);
			GL.vertex3( s,-s,-s);
			GL.vertex3( s, s,-s);
			GL.vertex3( s, s, s);
		GL.end();
		GL.begin( GL.LINE_LOOP );
			GL.vertex3( s, s, s);
			GL.vertex3( s, s,-s);
			GL.vertex3(-s, s,-s);
			GL.vertex3(-s, s, s);
		GL.end();
		GL.begin( GL.LINE_LOOP );
			GL.vertex3( s, s, s);
			GL.vertex3(-s, s, s);
			GL.vertex3(-s,-s, s);
			GL.vertex3( s,-s, s);
		GL.end();
		GL.begin( GL.LINE_LOOP );
			GL.vertex3(-s,-s, s);
			GL.vertex3(-s, s, s);
			GL.vertex3(-s, s,-s);
			GL.vertex3(-s,-s,-s);
		GL.end();
		GL.begin( GL.LINE_LOOP );
			GL.vertex3(-s,-s, s);
			GL.vertex3(-s,-s,-s);
			GL.vertex3( s,-s,-s);
			GL.vertex3( s,-s, s);
		GL.end();
		GL.begin( GL.LINE_LOOP );
			GL.vertex3(-s,-s,-s);
			GL.vertex3(-s, s,-s);
			GL.vertex3( s, s,-s);
			GL.vertex3( s,-s,-s);
		GL.end();
	}

	public static function solidCube( dSize:Float ) {
		var s = dSize*.5;
		GL.begin( GL.QUADS );
			GL.vertex3( s,-s, s);
			GL.vertex3( s,-s,-s);
			GL.vertex3( s, s,-s);
			GL.vertex3( s, s, s);

			GL.vertex3( s, s, s);
			GL.vertex3( s, s,-s);
			GL.vertex3(-s, s,-s);
			GL.vertex3(-s, s, s);

			GL.vertex3( s, s, s);
			GL.vertex3(-s, s, s);
			GL.vertex3(-s,-s, s);
			GL.vertex3( s,-s, s);

			GL.vertex3(-s,-s, s);
			GL.vertex3(-s, s, s);
			GL.vertex3(-s, s,-s);
			GL.vertex3(-s,-s,-s);

			GL.vertex3(-s,-s, s);
			GL.vertex3(-s,-s,-s);
			GL.vertex3( s,-s,-s);
			GL.vertex3( s,-s, s);

			GL.vertex3(-s,-s,-s);
			GL.vertex3(-s, s,-s);
			GL.vertex3( s, s,-s);
			GL.vertex3( s,-s,-s);
		GL.end();
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
		solidCube( 1. );

		GL.color3( 1., 1., 1. );
		wireCube(2.0);
		
		GL.flush();
		GLFW.swapBuffers();
	}

	public static function main() {
		var close = false;
		
		GLFW.openWindow( 320, 240, 8,8,8, 8,8,0, GLFW.WINDOW );
		
		GLFW.setWindowSizeFunction( function( w:Int, h:Int ) {
			trace("window resize: "+w+"x"+h );
		});
		GLFW.setWindowCloseFunction( function() {
			trace("window close" );
			close = true;
			return 1;
		});
		GLFW.setWindowRefreshFunction( function() {
			trace("window refresh" );
		});
		GLFW.setKeyFunction( function( a:Int, b:Int ) {
			trace("key: "+a+", "+b );
		});
		GLFW.setCharFunction( function( a:Int, b:Int ) {
			trace("char: "+a+", "+b );
		});
		GLFW.setMouseButtonFunction( function( a:Int, b:Int ) {
			trace("mouseButton: "+a+", "+b );
		});
		GLFW.setMousePosFunction( function( a:Int, b:Int ) {
			trace("mousePos: "+a+", "+b );
		});
		GLFW.setMouseWheelFunction( function( a:Int ) {
			trace("mouseWheel: "+a );
		});
		

		GL.clearColor( 0, 0, 0, 0 );
		GL.shadeModel( GL.FLAT );
		
		GL.matrixMode( GL.PROJECTION );
		GL.loadIdentity();
		GL.frustum( -1., 1., -1., 1., 1.5, 20. );
		GL.matrixMode( GL.MODELVIEW );
		
		GL.enable( GL.DEPTH_TEST );
		while(!close) {
			GLFW.pollEvents();
			display();
			neko.Sys.sleep(1./25);
		}
		GLFW.terminate();
		
	}
}
