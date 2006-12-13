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

class Runtime extends SimpleEventDispatcher {
	static private var _runtime:Runtime;
	static private var _renderer:Renderer;
	static public var runtime(getRuntime,null):Runtime;
	static public var renderer(getRenderer,null):Renderer;
	
	/* global functions */
	static public function getRuntime() :Runtime {
		if( _runtime==null ) initRuntime();
		return _runtime;
	}
	static public function getRenderer() :Renderer {
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
	
	
	static public function addEventListener<T>( type :EventKind<T>, h :T->Void ) :Void {
		runtime.addEventListener(type,h);
	}
	static public function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool {
		return runtime.removeEventListener(type,h);
	}
	static public function removeAllListeners<T>( type :EventKind<T> ) :Bool {
		return runtime.removeAllListeners(type);
	}

	/* API to override */
	public function getNextId() :Int {
		throw("unimplemented");
		return -1;
	}
	public function getDefaultRoot() :NativeContainer {
		throw("unimplemented");
		return null;
	}
	public function run() :Void {
		throw("unimplemented");
	}
	public function changed() :Void {
	}
	
}
