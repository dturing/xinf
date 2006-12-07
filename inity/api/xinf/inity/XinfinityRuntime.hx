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
// FONT import xinf.inity.font.Font;

import opengl.GL;
import opengl.GLU;
import opengl.Display;
import cptr.CPtr;

class XinfinityRuntime extends Runtime {
	private var frame:Int;
	private var width:Int;
	private var height:Int;
	private var somethingChanged:Bool;
	
	private var display:Display;
	private var _eventSource:GLEventSource;

    private static var selectBuffer = CPtr.uint_alloc(64);
    private static var view = CPtr.int_alloc(4);

	/* public API */
	
	public function new() :Void {
		super();
		
		frame=0;
		width = 320;
		height = 240;
		somethingChanged = true;
	
		initGL();
		_eventSource=new GLEventSource(this);
 		addEventListener( GeometryEvent.STAGE_SCALED, resized );
		
		startFrame();

	}
	
	function resized( e:GeometryEvent ) :Void {
		width = Math.round(e.x); height=Math.round(e.y);
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
			
			// FONT Font.cacheGlyphs();
			
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
	private function initGL() :Void {
		display = Display.open(0,0,width,height);
		display.makeCurrent();
	
		// SDL.GL_SetAttribute ( SDL.GL_ALPHA_SIZE, 8 );
		
		GL.enable( GL.BLEND );
		GL.blendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
		GL.shadeModel( GL.FLAT );
		
		//root.resize(width,height);
		postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, width, height ) );
	}

	private function startFrame() :Void {
		display.makeCurrent();
		
		GL.pushMatrix();
		GL.viewport( 0, 0, Math.round(width), Math.round(height) );
		GL.matrixMode( GL.PROJECTION );
		GL.loadIdentity();
		GL.matrixMode( GL.MODELVIEW );
		GL.loadIdentity();

		GL.clearColor( .5, .5, .5, .5 );
		GL.clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
			
		// FIXME depends on stage scale mode
		GL.translate( -1., 1., 0. );
		GL.scale( (2./width), (-2./height), 1. );
		GL.translate( .5, .5, 0. );
	}
	
	private function endFrame() :Void {
		GL.popMatrix();
		
		display.swap();
		
		// check for OpenGL errors
		var e:Int = GL.getError();
		if( e > 0 ) {
			trace( "OpenGL error "+GLU.errorString(e) );
		}
	}
	
    /* ------------------------------------------------------
       HitTest Functions
       ------------------------------------------------------ */

    public function startPick( x:Float, y:Float ) : Void {
		GL.viewport( 0, 0, Math.round(width), Math.round(height) );
		GL.matrixMode( GL.PROJECTION );
		GL.loadIdentity();
		GL.matrixMode( GL.MODELVIEW );
		GL.loadIdentity();

			GL.clearColor( .5, .5, .5, .5 );
			GL.clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
				
			// FIXME depends on stage scale mode
			GL.translate( -1., 1., 0. );
			GL.scale( (2./width), (-2./height), 1. );
			
			GL.selectBuffer( 64, selectBuffer );
			
			var v:Array<Int> = opengl.Helper.getInts( GL.VIEWPORT, 2 );
			CPtr.int_set( view, 0, v[0] );
			CPtr.int_set( view, 1, v[1] );
			
			GL.renderMode( GL.SELECT );
			GL.initNames();

			GL.matrixMode( GL.PROJECTION );
			GL.pushMatrix();
				
				GL.loadIdentity();
				GLU.pickMatrix( x, y, 1.0, 1.0, view );
				GL.matrixMode( GL.MODELVIEW );
				
				GL.disable( GL.BLEND );
	}
    
    public function endPick() : Array<Array<Int>> {
        GL.matrixMode( GL.PROJECTION );
        GL.popMatrix();
        
        var n_hits = GL.renderMode( GL.RENDER );
        
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
        
        GL.matrixMode( GL.MODELVIEW );
        GL.enable( GL.BLEND );
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
