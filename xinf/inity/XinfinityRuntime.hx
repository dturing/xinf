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
import opengl.GLUT;
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
		time = neko.Sys.time();
		interval = 1/25;
		bgColor = { r:1., g:1., b:1., a:0. };
    
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
        //    GLUT.postRedisplay();
    }

	override public function setBackgroundColor( r:Float, g:Float, b:Float, ?a:Float ) :Void {
		bgColor = { r:r, g:g, b:b, a:a };
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
		
        GLUT.swapBuffers();
    }
	
	function timing() :Void {
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

    public function step_timer( v:Int ) :Void {
        GLUT.setTimerFunc( Math.round(interval*900), step, 0 );
		step();
	}
	
    public function step() :Void {
    
        // post enter_frame event
        postEvent( new FrameEvent( FrameEvent.ENTER_FRAME, frame++ ) );
        
        if( somethingChanged ) {
            //GLUT.postRedisplay();
			display();
		} else {
			timing();
		}

		// for debug: run gc every second
		/*
		if( frame % 24 == null ) {
			trace("gc_major");
			neko.vm.Gc.run(true);
			trace("/gc_major");
		}
		*/
		
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
        // init GLUT Window
        GLUT.initDisplayMode( GLUT.RGBA | GLUT.DOUBLE | GLUT.STENCIL );
		GLUT.createWindow("Xinfinity");
        
        // TODO: set some kind of preferred size (style??)
    
        // init GLUT Callbacks
        var self=this;
        GLUT.setDisplayFunc( display );
   //    GLUT.setTimerFunc( 0, step_timer, 0 );
		GLUT.setIdleFunc( step );
        GLUT.setReshapeFunc( function( width:Int, height:Int ) {
                self.postEvent( new GeometryEvent( GeometryEvent.STAGE_SCALED, width, height ) );
            });
		/* consumes CPU when window invisible (GLUT problem? see opengl test)
        GLUT.setVisibilityFunc( function( state:Int ) {
                if( state>0 ) self.changed();
            });
		*/
        GLUT.setEntryFunc( function( state:Int ) {
                self.changed();
                GLUT.postRedisplay();
            });
        _eventSource.attach();
        
        
        GLUT.showWindow();

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
        GL.translate( -1., 1., 0. );
        GL.scale( (2./width), (-2./height), 1. );
      //  GL.translate( .5, .5, 0. );
      
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
       
    public function findIdAt( x:Float, y:Float ) :Int {
        var found = new Array<GLObject>();
        root.hit( {x:x,y:y}, found );
//        trace("findId("+x+","+y+"): "+found);
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

            // FIXME depends on stage scale mode
            GL.translate( -1., 1., 0. );
            GL.scale( (2./width), (-2./height), 1. );

            GL.selectBuffer( 64, selectBuffer );
            
            var v:Array<Int> = opengl.Helper.getInts( GL.VIEWPORT, 4 );
            CPtr.int_set( view, 0, v[0] );
            CPtr.int_set( view, 1, v[1] );
            CPtr.int_set( view, 2, v[2] );
            CPtr.int_set( view, 3, v[3] );
            
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
