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

package xinf.inity;

import xinf.erno.Runtime;
import xinf.event.SimpleEvent;
import xinf.event.GeometryEvent;
import xinf.erno.DrawingInstruction;
import xinf.inity.font.Font;

class XinfinityRuntime extends Runtime {
	private var frame:Int;
	private var width:Int;
	private var height:Int;
	private var somethingChanged:Bool;
	
	private var _eventSource:SDLEventSource;

    private static var selectBuffer = CPtr.uint_alloc(64);
    private static var view = CPtr.int_alloc(4);

	/* public API */
	
	public function new() :Void {
		super();
		
		frame=0;
		width = 1024;
		height = 768;
		somethingChanged = true;
	
		initSDLGL();
		_eventSource=new SDLEventSource(this);
		startFrame();

		addEventListener( GeometryEvent.STAGE_SCALED, resize );
	}
	
	function resize( e:GeometryEvent ) :Void {
		width = Math.round(e.x); height=Math.round(e.y);
        if( SDL.SetVideoMode( width, height, 32, SDL.OPENGL | SDL.RESIZABLE | SDL.GL_DOUBLEBUFFER ) == 0 ) {
            throw("SDL SetVideoMode failed.");
        }
	}

	public function createRenderer() :xinf.erno.Renderer {
		return new GLRenderer();
	}
	
	public function run() :Void {
		var pleaseQuit:Bool = false;
		
		addEventListener( SimpleEvent.QUIT, function (e:SimpleEvent) {
			pleaseQuit = true;
		} );
			
		var step = 1.0/25.0;
		var nextT = neko.Sys.time()+step;
		
		while( !pleaseQuit ) {
			// TODO: process events
			_eventSource.processEvents();
			
			Font.cacheGlyphs();
			
			// draw the root object
			if( somethingChanged ) {
				startFrame();
				Runtime.renderer.draw( DrawingInstruction.ShowObject( Runtime.renderer.getRootId() ) );
			}
			
			var t = nextT - neko.Sys.time();
			if( t>0 ) {
				neko.Sys.sleep(t);
			}
			
			if( somethingChanged ) {
				somethingChanged = false;
				endFrame();
			}
			
			nextT += step;
		}
	}

	public function changed() :Void {
		somethingChanged = true;
	}
	
	/* internal functions */
	private function initSDLGL() :Void {
		if( SDL.Init( SDL.INIT_VIDEO ) < 0 ) {
			throw("SDL Video Initialization failed.");
		}

		SDL.GL_SetAttribute ( SDL.GL_ALPHA_SIZE, 8 );
		trace("w/h: "+ width+", "+height );
		if( SDL.SetVideoMode( width, height, 32, SDL.OPENGL | SDL.RESIZABLE | SDL.GL_DOUBLEBUFFER ) == 0 ) {
			throw("SDL SetVideoMode failed.");
		}

        SDL.EnableUNICODE(1);

//		GL.PixelStorei( GL.UNPACK_ALIGNMENT, 4 );
		GL.Enable( GL.BLEND );
		GL.BlendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
		GL.ShadeModel( GL.FLAT );
	}

	private function startFrame() :Void {
		GL.PushMatrix();
		GL.Viewport( 0, 0, Math.round(width), Math.round(height) );
		GL.MatrixMode( GL.PROJECTION );
		GL.LoadIdentity();
		GL.MatrixMode( GL.MODELVIEW );
		GL.LoadIdentity();

		GL.ClearColor( .5, .5, .5, .5 );
		GL.Clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
			
		// FIXME depends on stage scale mode
		GL.Translatef( -1., 1., 0. );
		GL.Scalef( (2./width), (-2./height), 1. );
		GL.Translatef( .5, .5, 0. );
	}
	
	private function endFrame() :Void {
		GL.PopMatrix();
		// FIXME sync
		SDL.GL_SwapBuffers();

		// check for OpenGL errors
		var e:Int = GL.GetError();
		if( e > 0 ) {
			trace( "OpenGL error "+GLU.ErrorString(e) );
		}
	}
	
    /* ------------------------------------------------------
       HitTest Functions
       ------------------------------------------------------ */

    public function startPick( x:Float, y:Float ) : Void {
		GL.Viewport( 0, 0, Math.round(width), Math.round(height) );
		GL.MatrixMode( GL.PROJECTION );
		GL.LoadIdentity();
		GL.MatrixMode( GL.MODELVIEW );
		GL.LoadIdentity();

			GL.ClearColor( .5, .5, .5, .5 );
			GL.Clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
				
			// FIXME depends on stage scale mode
			GL.Translatef( -1., 1., 0. );
			GL.Scalef( (2./width), (-2./height), 1. );
			
			GL.SelectBuffer( 64, selectBuffer );
			
			GL.GetIntegerv( GL.VIEWPORT, view );
			GL.RenderMode( GL.SELECT );
			GL.InitNames();

			GL.MatrixMode( GL.PROJECTION );
			GL.PushMatrix();
				
				GL.LoadIdentity();
				GLU.PickMatrix( x, y, 1.0, 1.0, view );
				GL.MatrixMode( GL.MODELVIEW );
				
				GL.Disable( GL.BLEND );
	}
    
    public function endPick() : Array<Array<Int>> {
        GL.MatrixMode( GL.PROJECTION );
        GL.PopMatrix();
        
        var n_hits = GL.RenderMode( GL.RENDER );
        
        // process the GL SelectBuffer into a simple array of arrays of names.
        var stacks = new Array<Array<Int>>();
        if( n_hits > 0 ) {
            var i=0; 
            var j=0;
            while( i<n_hits && j<64 ) {
                var n : Int = CPtr.uint_get( selectBuffer, j);
                var objs = new Array<Int>();
                j+=3;
                for( k in 0...n ) {
                    objs.push( Math.round(CPtr.uint_get( selectBuffer, j )));
                    j++;
                }
                i++;
                stacks.push(objs);
            }
        }
        
        GL.MatrixMode( GL.MODELVIEW );
        GL.Enable( GL.BLEND );
        return stacks;
    }
    
    
    public function getObjectsUnderPoint( x:Float, y:Float ) : Array<Int> {
        startPick( x, height-y );
        
		Runtime.renderer.draw( DrawingInstruction.ShowObject( Runtime.renderer.getRootId() ) );
					
        var hits:Array<Array<Int>> = endPick();
        var os = new Array<Int>();
		
        for( hit in hits ) {
			os.push( hit.pop() );
        }
        
        return os;
    }
 
	public function findIdAt( x:Float, y:Float ) :Int {
		return getObjectsUnderPoint( x, y ).pop();
	}
}
