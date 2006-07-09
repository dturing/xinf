/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
																			
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU		
   Lesser General Public License or the LICENSE file for more details.
*/

import xinf.geom.Point;

/**
    SDL/GL Test.
    opens a window and does some adhoc testing.
**/
class GstTest {
    var quit:Bool;
	var texture:Int;
	var list:Int;
	var sink:gst.Object;
    var textures:Array<Int>;

    /* ------------------------------------------------------
       Render Functions
       ------------------------------------------------------ */
    /*
    public function setupTexture( tw:Int, th:Int, color:Int ) :Int {
        var texture:Int;
        
        var t:Dynamic = CPtr.uint_alloc(1);
        GL.GenTextures(1,t);
        texture = CPtr.uint_get(t,0);
        
        GL.Enable( GL.TEXTURE_2D );
        GL.BindTexture( GL.TEXTURE_2D, texture );
        GL.CreateTexture( texture, tw, th );

	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
	    GL.TexParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );

        trace("setup tex #"+texture+" "+tw+"x"+th );
        var t:Dynamic = CPtr.uint_alloc(tw*th);
        for( y in 0...th ) {
            for( x in 0...tw ) {
                CPtr.uint_set(t,(y*tw)+x,0xffaaaaaa );
            }
        }
        GL.TexSubImage2D_RGBA_BYTE( texture, new Point(0,0), new Point(tw,th), t );

 //       GL.Disable( GL.TEXTURE_2D );
        
        return texture;
    }
	*/
    
    public function render() :Void {
        var w:Float = 1; //(120/128);
        var h:Float = 1; //(120/128);

        var tw:Float = sink.get("texture_width");
        var th:Float = sink.get("texture_height");
        var width:Float = sink.get("width");
        var height:Float = sink.get("height");
        
		var tx2 = ( width/tw );
		var ty2 = ( height/th );
		
		if( texture==-1 ) {
			if( sink==null ) return;
			texture = sink.get("texture");
			if( texture==-1 ) return;
		}
		if( list==-1 ) {
			list = GL.GenLists(1);
			GL.NewList( list, GL.COMPILE );
				GL.Begin( GL.QUADS );
					GL.TexCoord2f(  0,  0 );
					GL.Vertex2f  (  0,  h ); 
					
					GL.TexCoord2f( tx2, .0 );
					GL.Vertex2f  (  w, h );
					
					GL.TexCoord2f( tx2, ty2 );
					GL.Vertex2f  (  w,  0 ); 
					
					GL.TexCoord2f( .0, ty2 );
					GL.Vertex2f  ( .0,  0 ); 
				
				GL.End();
			GL.EndList();
		}

//		sink.wait_texture_available();

        GL.Clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );

		GL.Color4f( 1,1,1,1 );
        GL.BindTexture( GL.TEXTURE_2D, texture );
		GL.PushMatrix();
		GL.Translatef( -.5, -.5, 0 );

		GL.CallList( list );
		
		GL.PopMatrix();
        SDL.GL_SwapBuffers();
		
		sink.set_texture_consumed();
    }


    
    /* ------------------------------------------------------
       SDL Helper Functions
       ------------------------------------------------------ */

    public function processEvents() :Void {
        var e = SDL._NewEvent();
        while( SDL.PollEvent( e ) > 0 ) {
            var k = SDL.Event_type_get(e);
            
            switch( k ) {
                case SDL.QUIT:
                    trace("Quit");
                    quit = true;
                default:
               //     trace("Event "+k);
            }
        }
    }

    /* ------------------------------------------------------
       OpenGL Helper Functions
       ------------------------------------------------------ */
    
    public function setupGL() : Void {
    	GL.Viewport( 0, 0, 320, 240 );
        GL.MatrixMode( GL.PROJECTION );
        GL.LoadIdentity();
        GL.MatrixMode( GL.MODELVIEW );
        GL.LoadIdentity();
        
        GL.PixelStorei( GL.UNPACK_ALIGNMENT, 1 );
        GL.Enable( GL.TEXTURE_2D );

        GL.Enable( GL.BLEND );
        GL.BlendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
        
        GL.ShadeModel( GL.FLAT );

        GL.ClearColor( .2, .2, .4, 1. );
            
        GL.Clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
    }

    /* ------------------------------------------------------
       Core Functions
       ------------------------------------------------------ */

    public function new() :Void {
        if( SDL.SetVideoMode( 320, 240, 32, SDL.OPENGL | SDL.RESIZABLE | SDL.GL_DOUBLEBUFFER ) == 0 ) {
            throw("SDL SetVideoMode failed.");
        }
		texture=-1;
		list=-1;
        setupGL();
    }
    
    public function run() :Void {
        quit=false;

		
        while( !quit ) {
            processEvents();
            render();

            neko.Sys.sleep(.01);
        }

	}

    static function main() {
		
        if( SDL.Init( SDL.INIT_VIDEO ) < 0 ) {
            throw("SDL Video Initialization failed.");
        }

        var gltest = new GstTest();

        gst.Object._init();
		var pipeline = new gst.Pipeline( 
//		"gnomevfssrc location=/beta/video/aida/dance.avi ! decodebin ! ffmpegcolorspace ! fixedalpha ! texturesink name=sink");
//		"scanline ! graytorgba ! texturesink name=sink");
		"videotestsrc ! video/x-raw-rgb, width=320, height=240 ! fixedalpha alpha=255 ! texturesink name=sink");
		gltest.sink = pipeline.findChild("sink");
		gltest.sink.set_texture_consumed();
		
        gltest.run();
    }
}
