/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.event.SimpleEventDispatcher;
import xinf.event.EventKind;
import xinf.event.FrameEvent;
import xinf.erno.Renderer;

/**
	DOCME: out of date!
	
    The Runtime class has static functions to request the global
    Runtime instance (a singleton) and it's associated <a href="Renderer.html">Renderer</a>.
    <p>
        The Runtime represents the runtime environment (Flash, JavaScript, Xinfinity), 
        there is only one global runtime object for a running Xinf application, 
        an instance of a class deriving from xinf.erno.Runtime. The specific runtimes
        implement some 'abstract' functions defined here in their individual ways.
    </p>
    <p>
        The Runtime singleton (Runtime.runtime) is an EventDispatcher that dispatches
        all global low-level user-interface events. In Xinfony, some of these are
        listened for and dispatched to the corresponding target object (see
        <a href="../ony/Manager.html">xinf.ony.Manager</a>). 
        For other events, you will have to register at the runtime (in particular, 
        this regards MOUSE_UP, MOUSE_MOVED, KEY_UP, KEY_DOWN and STAGE_SCALED). 
        You can register listeners either at the [Runtime.runtime] member or 
        using the static [addEventListener] function.
    </p>
    <p>
        The Runtime is initialized automatically when you instantate an
        <a href="../ony/Application.html">xinf.ony.Application</a> object, or do anything
        with Runtime.runtime. Only if you want to use Xinferno directly you
        should probably care about initialization once at the beginning of your
        application.
    </p>
**/
class Runtime extends SimpleEventDispatcher {
    
    /**
        A reference to the global Runtime singleton.
        If it is not initialized yet, requesting this will intialize
        the runtime.
    **/
    static public var runtime(getRuntime,null):Runtime;
    static private var _runtime:Runtime;
    
    /**
        A reference to the Renderer associated to the global Runtime singleton.
        If it is not initialized yet, requesting this will intialize
        the runtime.
    **/
    static public var renderer(getRenderer,null):Renderer;
    static private var _renderer:Renderer;
    
    /* global functions */
    static private function getRuntime() :Runtime {
        if( _runtime==null ) initRuntime();
        return _runtime;
    }
    
    static private function getRenderer() :Renderer {
        if( _renderer==null ) initRuntime();
        return _renderer;
    }
    
    static private function initRuntime() :Runtime {
        #if neko
            _runtime = new xinf.inity.XinfinityRuntime();
            // dynamically load renderer
            if( true ) {
			/*
                #if gldebug
                    _renderer = new xinf.inity.GLDebugRenderer();
                #else true
                  _renderer = new xinf.inity.GLRenderer();
                #end
				*/
//				_renderer = new xinf.inity.GLRenderer();
				_renderer = new xinf.inity.GLVGRenderer();
            } else {
                /* experimental. */
                var name = "xinfinity-gl0";
                try {
                    var haxeLibPath = switch( neko.Sys.systemName() ) {
                        case "Windows":
                            neko.Sys.getEnv("HAXEPATH")+"\\lib\\";
                        default:
                            neko.io.File.getContent( neko.Sys.getEnv("HOME")+"/.haxelib" );
                        }
                    
                    var libPath = haxeLibPath+"/"+name+"/";
                    var version = neko.io.File.getContent( libPath+".current" );
                    libPath += version.split(".").join(",")+"/ndll/"+neko.Sys.systemName()+"/";
                    
                    // at least for windoze: add libPath to PATH, for loading DLLs
                    //neko.Sys.putEnv("PATH",neko.Sys.getEnv("PATH")+":"+libPath );
                    
                    // (try to) load the module
                    var rClass:Dynamic;
                    var loader = neko.vm.Loader.local();
                    loader.addPath( libPath );
                    rClass = loader.loadModule(name).getExports().get("Renderer__impl");
                    
                    if( rClass==null ) throw("module does not export Renderer__impl");
                    
                    _renderer = rClass.createRenderer(320,240);
                    trace("Loaded Renderer "+name+" "+version );
                } catch(e:Dynamic) {
                    throw("unable to load Xinfinity Renderer '"+name+"': "+e );
                }
            }
        #else js
            _renderer = new xinf.erno.js.JSRenderer();
            _runtime = new xinf.erno.js.JSRuntime();
        #else flash
            _renderer = new xinf.erno.flash9.Flash9Renderer();
            _runtime = new xinf.erno.flash9.Flash9Runtime();
        #end
        
        if( runtime==null ) throw("unable to create runtime environment");

        return runtime;
    }
    
    /**
        add an event listener to the Runtime singleton. This is a convenience
        function that has the same effect as Runtime.runtime.addEventListener.
    **/
    static public function addEventListener<T>( type :EventKind<T>, h :T->Void ) :T->Void {
        return runtime.addEventListener(type,h);
    }
    
    /**
        remove an event listener from the Runtime singleton. This is a convenience
        function that has the same effect as Runtime.runtime.removeEventListener.
    **/
    static public function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool {
        return runtime.removeEventListener(type,h);
    }
    
    /**
        return a newly allocated numeric ID
        for use with <a href="Renderer.html">xinf.erno.Renderer</a>. 
        The default implementation will throw an exception.
    **/
    public function getNextId() :Int {
        throw("unimplemented");
        return -1;
    }
    
    /**
        return the runtime's default Root <a href="NativeContainer.html">NativeContainer</a>.
        The default implementation will throw an exception.
    **/
    public function getDefaultRoot() :NativeContainer {
        throw("unimplemented");
        return null;
    }
    
    /**
        start the runtime main loop if such exists. 
        From your application, you should call Runtime.runtime.run() once, at the end of your main() 
        (<a href="../ony/Application.html">xinf.ony.Application</a>.run() does this for you). 
        The function might return instantly, when the application quits,
        or never, depending on the runtime environment.
        The default implementation will throw an exception.
    **/
    public function run() :Void {
        throw("unimplemented");
    }

    /**
        signal to the Runtime that some content in the display hierarchy has changed.
        This will trigger re-rendering of the default Root object. There is no need
        to ever call this if you use Xinfony (the Manager will take care of this).
        The default implementation does nothing.
    **/
    public function changed() :Void {
    }
	
	public function setBackgroundColor( r:Float, g:Float, b:Float, ?a:Float ) :Void {
	}
    
}
