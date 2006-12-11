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
	static public var runtime:Runtime;
	
	public static function init() :Void {
		runtime = Runtime.initRuntime();
	}
	
	static public var renderer:Renderer;
	
	/* global functions */
	static public function initRuntime() :Runtime {
		#if neko
			runtime = new xinf.inity.XinfinityRuntime();
		#else js
			runtime = new xinf.js.JSRuntime();
		#else flash
			runtime = new xinf.flash9.Flash9Runtime();
		#end
		
		if( runtime==null ) throw("unable to create runtime environment");
		
		renderer = runtime.createRenderer();
		
		return runtime;
	}
	
	static public function run() :Void {
		if( runtime == null ) throw("initialize runtime first");
		runtime.run();
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
	public function createRenderer() :Renderer {
		throw("unimplemented"); return null;
	}
	public function run() :Void {
		throw("unimplemented");
	}
	public function changed() :Void {
	}
	
}
