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

package xinf.erno;

import xinf.event.SimpleEventDispatcher;
import xinf.event.EventKind;
import xinf.event.FrameEvent;
import xinf.erno.Renderer;

/**
    The Runtime class has static functions to request the global
    Runtime instance (a singleton) and it's associated <a href="Renderer">Renderer</a>.
    <p>
        The Runtime represents the runtime environment (Flash, JavaScript, Xinfinity), 
        i.e., there is only one global runtime object for a running Xinf application, 
        an instance of a class deriving from xinf.ony.Runtime. The specific runtimes
        should not implement any specific functionality, instead implement some
        functions defined here.
    </p>
    <p>
        The Runtime singleton (Runtime.runtime) is an EventDispatcher that dispatches
        all global low-level user-interface events. In Xinfony, some of these are
        listened for and dispatched to the corresponding target object (see the
        <a href="../ony/Manager">Manager</a> class). For other events, you will
        have to register at the runtime (in particular, this regards MOUSE_UP,
        MOUSE_MOVED, KEY_UP, KEY_DOWN and STAGE_SCALED). You can register
        listeners either at the [Runtime.runtime] member or using the static
        addEventListener function.
    </p>
    <p>
        The Runtime is initialized automatically when you instantate an
        <a href="../ony/Application">xinf.ony.Application</a> object, or do anything
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
            _renderer = new xinf.inity.GLRenderer();
            _runtime = new xinf.inity.XinfinityRuntime();
        #else js
            _renderer = new xinf.js.JSRenderer();
            _runtime = new xinf.js.JSRuntime();
        #else flash
            _renderer = new xinf.flash9.Flash9Renderer();
            _runtime = new xinf.flash9.Flash9Runtime();
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
        to be overridden by deriving classes to return a newly allocated numeric ID
        for use with <a href="Renderer">xinf.erno.Renderer</a>. The default
        implementation will throw an exception.
    **/
    public function getNextId() :Int {
        throw("unimplemented");
        return -1;
    }
    
    /**
        to be overridden by deriving classes to return the runtime's default
        Root <a href="NativeContainer">NativeContainer</a>.
        The default implementation will throw an exception.
    **/
    public function getDefaultRoot() :NativeContainer {
        throw("unimplemented");
        return null;
    }
    
    /**
        to be overridden by deriving classes to start the runtime main loop
        if such exists. From your application, you should call Runtime.runtime.run()
        once, at the end of your main() (<a href="../ony/Application">xinf.ony.Application</a>.run()
        does this for you). The function might return instantly, when the application quits,
        or never, depending on the runtime environment.
    **/
    public function run() :Void {
        throw("unimplemented");
    }

    /**
        signal to the Runtime that some content in the display hierarchy has changed.
        This will trigger re-rendering of the default Root object. There is no need
        to ever call this if you use Xinfony (the Manager will take care of this).
    **/
    public function changed() :Void {
    }
    
}
