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

import xinf.event.MouseEvent;
import xinf.erno.Color;
import xinf.ony.Application;
import xinf.ul.Button;
import xinf.ul.ListModel;

class Test extends Application {
	public function new() :Void {
		super();
		
		GrayStyle.addToDefault();
		
		var container = new xinf.ul.VBox();
		container.moveTo( 100, 100 );
		root.attach(container);

		var model = new SimpleListModel();
        for( i in 0...25 ) {
            model.addItem("Item "+i);
        }
		
		var dropdown = new Dropdown(model);
		dropdown.resize( 100, 20 );
		container.attach(dropdown);
				
		var slider = new Slider();
		slider.resize( 100, 20 );
		container.attach(slider);
		
		var button = TextButton.createSimple("Hello, World!", function(e:MouseEvent){
				trace("thanks for clicking");
			});
		button.resize( 100, 20 );
		container.attach(button);
	}
	
	public static function main() :Void {
		try {
			new Test().run();
		} catch( e:Dynamic ) {
			trace("Exception: "+e );
		}
	}
}
