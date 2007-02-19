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

package xinf.ul;

import xinf.style.Theme;

class Application extends xinf.ony.Application {
    
    /**
        Root Container Component, add your components to this.
    **/
    public var container(default,null):RootComponent;
    
    /**
        Constructor. Initializes the [root] member for you to add
        objects after calling this (super()) from your Application's 
        constructor.
    **/
    public function new() :Void {
        super();
        
        if( Theme.theme == null ) Theme.theme = new xinf.style.GrayStyle();
        trace("theme is: "+Theme.theme.info() );
        Theme.theme.addToDefault();
        
        container = new RootComponent();
        root.attach(container);
    }
}
