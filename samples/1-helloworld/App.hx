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

import xinf.erno.Color;
import xinf.ony.Application;
import xinf.ony.Text;

class App extends Application {
    private static var hello:Text;
    
    public function new() :Void {
        super();

        hello = new Text( "Hello, World!", Color.WHITE );
        root.attach( hello );
    }
    
    public static function main() :Void {
        new App().run();
    }
}
