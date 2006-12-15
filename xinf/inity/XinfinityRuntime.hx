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

import xinf.event.SimpleEvent;
import xinf.event.GeometryEvent;
import xinf.event.FrameEvent;
import xinf.erno.Runtime;
import xinf.erno.Renderer;
import xinf.inity.font.Font;

import opengl.GL;
import opengl.GLU;
import opengl.GLUT;
import cptr.CPtr;

class XinfinityRuntime extends Runtime {
	private var frame:Int;
	private var width:Int;
	private var height:Int;
	private var somethingChanged:Bool;
	private var root:GLObject;
	
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
	
		_eventSource=new GLEventSource(this);
		
		initGL();
		root = new GLObject( getNextId() );
		
 		addEventListener( GeometryEvent.STAGE_SCALED, resized );
		
		startFrame();
	}

	function renderRoot() :Void {
		Runtime.renderer.showObject( root.id );
	}

	function resized( e:GeometryEvent ) :Void {
		width = Math.round(e.x); height=Math.round(e.y);
	}

	override public function getNextId() :Int {
		return GL.genLists(1);
	}

	override public function getDefaultRoot() :NativeContainer {
		return root;
	}

	override public function run() :Void {
		GLUT.mainLoop();
	}

	override public function changed() :Void {
		somethingChanged = true;
	}
	
	public function display() :Void {
	
		// FIXME: here??
		Font.cacheGlyphs();
		
		startFrame();
		
		renderRoot();
		somethingChanged = false;

		// TODO precise timing here
		
		endFrame();
	}

	public function step( v:Int ) :Void {
		GLUT.setTimerFunc( 40, step, 0 );
		
		// post enter_frame event
		postEvent( new FrameEvent( FrameEvent.ENTER_FRAME, frame++ ) );
		
		if( somethingChanged ) {
			GLUT.postRedisplay();
		}
	}

	/* internal functions */
	private function initGL() :Void {
		// init GLUT Window
		GLUT.initDisplayMode( GLUT.DOUBLE | GLUT.RGB ); //| GLUT.DEPTH );
		GLUT.createWindow("Xinfinity");
		
		// TODO: set some kind of preferred size (style??)
	
		// init GLUT Callbacks
		var self=this;
		GLUT.setDisplayFunc( display );
		GLUT.setTimerFunc( 40, step, 0 );
		GLUT.setReshapeFunc( function( width:Int, height:Int ) {
				self.postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, width, height ) );
			});
		_eventSource.attach();
		
		
		GLUT.showWindow();

		// init GL parameters
		GL.enable( GL.BLEND );
		GL.blendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
		GL.shadeModel( GL.FLAT );
	}

	private function startFrame() :Void {
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
		GL.flush();
		GLUT.swapBuffers();
		
		// check for OpenGL errors
		var e:Int = GL.getError();
		if( e > 0 ) {
			trace( "OpenGL error "+GLU.errorString(e) );
		}
	}
	
    /* ------------------------------------------------------
       HitTest Functions 
	   -- GL_SELECT render mode is seldom accellerated,
	      sometimes doesnt work. trying my luck with own lightweight
		 object model.
       ------------------------------------------------------ */
	   
	public function findIdAt( x:Float, y:Float ) :Int {
		var found = new Array<GLObject>();
		root.hit( {x:x,y:y}, found );
//		trace("findId("+x+","+y+"): "+found);
		if( found.length>0 )
			return found.pop().id;
		else return -1;
	}

/*
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

		renderRoot();
					
        var hits:Array<Array<Int>> = endPick();
        var os = new Array<Int>();
		trace("getObjectsUnderPoint("+x+","+y+"): "+hits );
        for( hit in hits ) {
			os.push( hit.pop() );
        }
        
        return os;
    }
 
	public function findIdAt( x:Float, y:Float ) :Int {
		return getObjectsUnderPoint( x, y ).pop();
	}
	*/
}
