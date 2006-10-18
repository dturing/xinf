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

import xinf.ul.ListModel;
import xinf.ul.Button;
import xinf.ul.GrayStyle;
import xinf.event.MouseEvent;
import xinf.erno.Runtime;

class Test {
	public static function main() :Void {
		Runtime.init();
		
		var root = new xinf.ony.Root();
		GrayStyle.addToDefault();

		var container = new xinf.ul.VBox();
		container.moveTo( 10, 10 );
		root.attach(container);

		var model = new SimpleListModel();
        for( i in 0...25 ) {
            model.addItem("Item "+i);
        }
		
		var dropdown = new Dropdown(model);
		dropdown.resize( 100, 20 );
		container.attach(dropdown);
		
		/*
		var listbox = new ListBox<String>(model);
		listbox.resize( 100, 100 );
		container.attach(listbox);

		var label = new Pane(); //Label("Hello");
		label.resize( 100, 20 );
		container.attach(label);
		*/
		
		var slider = new Slider();
		slider.resize( 100, 20 );
		container.attach(slider);
		
		var button = TextButton.createSimple("Hello, World!", function(e:MouseEvent){
				trace("thanks for clicking");
			});
		button.resize( 100, 20 );
		container.attach(button);
		
		Runtime.run();
	}
}
