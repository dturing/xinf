/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.inity;

import xinf.event.SimpleEvent;
import xinf.event.GeometryEvent;
import xinf.event.FrameEvent;
import xinf.erno.Runtime;
import xinf.erno.Renderer;
import xinf.inity.font.Font;

import opengl.GL;
import opengl.GLU;
import opengl.GLFW;
import cptr.CPtr;

class XinfinityRuntime extends Runtime {
	
	var frame:Int;
	var width:Int;
	var height:Int;
	var somethingChanged:Bool;
	var root:GLObject;
	var time:Float;
	var interval:Float;
	var bgColor:{ r:Float, g:Float, b:Float, a:Float };
	
	var lastMeasure:Float;
	var rateAcc:Float;
	var rates:Int;
	var measuredFps:Float;

	public var preDisplayCallbacks : List<Void->Void>;
	public var postDisplayCallbacks : List<Void->Void>;
	
	private var _eventSource:GLEventSource;

	/* public API */
	
	public function new() :Void {
		super();
		
		preDisplayCallbacks = new List<Void->Void>();
		postDisplayCallbacks = new List<Void->Void>();

		lastMeasure = neko.Sys.time();
		rates=0;
		rateAcc=0;
		
		frame=0;
		width = 320;
		height = 240;
		somethingChanged = true;
		time = neko.Sys.time();
		interval = 1./25.;
		bgColor = { r:1., g:1., b:1., a:0. };
	
		_eventSource=new GLEventSource(this);
		initGL();
		root = new GLObject( getNextId() );


		addEventListener( GeometryEvent.STAGE_SCALED, resized );
		
		startFrame();
	}

	function renderRoot() :Void {
		for( cb in preDisplayCallbacks ) cb();
		Runtime.renderer.showObject( root.id );
		for( cb in postDisplayCallbacks ) cb();
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
		var close=false;

		GLFW.setWindowCloseFunction( function() {
			close = true;
			return 1;
		});

		while( !close ) {
			GLFW.pollEvents();
			step();
		}
	}

	override public function changed() :Void {
		somethingChanged = true;
	}

	override public function setBackgroundColor( r:Float, g:Float, b:Float, ?a:Float ) :Void {
		bgColor = { r:r, g:g, b:b, a:a };
		changed();
	}

	override public function setFramerate( rate:Float ) :Void {
		interval = 1./rate;
	}

	override public function getFramerate() :Float {
		return 1./interval;
	}

	override public function getMeasuredFramerate() :Float {
		return measuredFps;
	}

	public function display() :Void {
		startFrame();

		#if gldebug
			var e:Int = GL.getError();
			if( e > 0 ) {
				throw( "OpenGL Error: "+opengl.GLU.errorString(e) );
			}
		#end

		somethingChanged = false;
		
 		#if profile
 			xinf.test.Profile.before("render");
 		#end
		renderRoot();
 		#if profile
 			xinf.test.Profile.after("render");
 		#end
 
		endFrame();
		timing();
		GLFW.swapBuffers();
	}
	
	function timing() :Void {
		if( interval==-1 ) return; // as fast as possible...
	
		var now = neko.Sys.time();
		while( time<now-(interval) ) {
			time+=interval;
			#if profile
			xinf.test.Counter.count("frames dropped");
			#end
		}
		
		var d = (time-now);
		while( d>.005 ) {
			neko.Sys.sleep(d*.95);
			now = neko.Sys.time();
			d=time-now;
		}
		
		time+=interval;
	}

	public function step() :Void {
	
		// post enter_frame event
		postEvent( new FrameEvent( FrameEvent.ENTER_FRAME, frame++, time ) );
		
		if( somethingChanged ) {
			//GLUT.postRedisplay();
			display();
		} else {
			timing();
		}

		// measure framerate
		var now = neko.Sys.time();
		rates++;
		rateAcc += (now-lastMeasure);
		if( rateAcc>1. ) {
			measuredFps = (1./(rateAcc/rates));
			rates=0;
			rateAcc=0;
		}
		lastMeasure=now;

		// for debug: run gc every second
		/*
		if( frame % 24 == null ) {
			trace("gc_major");
			neko.vm.Gc.run(true);
			trace("/gc_major");
		}
		*/
		
		if( frame==1 ) changed(); // to hide the first-frame font-not-loaded bug.
		
		#if profile
//			xinf.test.Counter.count("frames");
			if( frame % 50 == 0 ) {
				neko.Lib.print("---------------------------\n");
				xinf.test.Counter.dump();
				xinf.test.Counter.reset();
				xinf.test.Profile.dump();
			}
		#end
	}

	/* internal functions */
	private function initGL() :Void {
		// init GLFW Window
		GLFW.openWindow( 320,240, 8,8,8, 8,8,8, GLFW.WINDOW );
		GLFW.setWindowTitle("Xinfinity");

		// TODO: set some kind of preferred size (style??)
	
		// init GLFW Callbacks
		var self=this;
		GLFW.setWindowSizeFunction( function( width:Int, height:Int ) {
				self.postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, width, height ) );
			});
		GLFW.setWindowRefreshFunction( function() {
				self.changed();
			});
		_eventSource.attach();
		
		// init GL parameters

		GL.enable( GL.BLEND );
		GL.blendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
		GL.shadeModel( GL.FLAT );

		openvg.VG.createContextSH( 320, 240 ); // FIXME
		openvg.VG.seti( openvg.VG.RENDERING_QUALITY, openvg.VG.RENDERING_QUALITY_BETTER );
	}

	private function startFrame() :Void {
		GL.pushMatrix();
		GL.viewport( 0, 0, Math.round(width), Math.round(height) );
		GL.matrixMode( GL.PROJECTION );
		GL.loadIdentity();
		GL.matrixMode( GL.MODELVIEW );
		GL.loadIdentity();

		if( bgColor.a==0 || bgColor.a==null ) {
			GL.clearColor( bgColor.r,bgColor.g,bgColor.b,0 );
			GL.clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT | GL.STENCIL_BUFFER_BIT );
		} else {
			// relatively cheap motion-blur-like effect (only good when scene is continuously animated)
			GL.enable(GL.BLEND);
			GL.color4( bgColor.r, bgColor.g, bgColor.b, bgColor.a );
			GL.rect( -512,-384,1024,768 ); // FIXME
			GL.disable(GL.BLEND);
		}
		
		// FIXME depends on stage scale mode
		GL.matrixMode( GL.PROJECTION );
		GL.translate( -1., 1., 0. );
		GL.scale( (2./width), (-2./height), 1. );
		GL.matrixMode( GL.MODELVIEW );

		#if gldebug
			var e:Int = GL.getError();
			if( e > 0 ) {
				throw( "OpenGL Error: "+GLU.errorString(e) );
			}
		#end
	}
	
	private function endFrame() :Void {
		GL.popMatrix();
		GL.flush();
		
		#if gldebug
			var e:Int = GL.getError();
			if( e > 0 ) {
				throw( "OpenGL Error: "+GLU.errorString(e) );
			}
		#end
	}
	
	/* ------------------------------------------------------
	   HitTest Functions 
	   ------------------------------------------------------ */
	   
	public function findIdAt( x:Float, y:Float, precise:Bool=false ) :Int {
		if( root==null ) return 0;

		var found = new List<{o:GLObject,p:{x:Float,y:Float}}>();
		root.hit( {x:x,y:y}, found );

		if( precise ) {
			for( f in found ) {
				if( f.o.hitPrecise( f.p ) ) return f.o.id;
			}
			return -1;
		}

		if( found.length>0 )
			return found.pop().o.id;
		else return -1;
	}

}
