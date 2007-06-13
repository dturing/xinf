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

package xinf.ony.erno;

import xinf.erno.Runtime;

/**
    Application is a small class for you to derive from if building
    a xinf-style application. It will aquire the Runtime's default Root,
    and start running on run(). You can add objects to the "Stage" by
    using the member "root".
**/
class Application {
    
    /**
        The root of the display hierarchy. Equals the Stage on Flash,
        the html document on js, and the (main) window on xinfinity.
    **/
    public var root(default,null):Root;
    
    /**
        Constructor. Initializes the [root] member for you to add
        objects after calling this (super()) from your Application's 
        constructor.
    **/
    public function new() :Void {
        root = new Root();
    }

    /**
        Start running the main loop. You should call this from your main() after
        you've set up your application, and only react on event handlers further on.
        On some runtimes, this function immediately returns, on some it never does. You
        should not do anything after calling run() except returning from your main().
    **/
    public function run() :Void {
        Runtime.runtime.run();
    }
    
}
