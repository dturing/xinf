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

import xinf.ony.Application;
import xinf.event.MouseEvent;
import xinf.ul.GrayStyle;
import xinf.ul.RadioButton;
import xinf.ul.CheckBox;

class App extends Application {
    
    public function new() :Void {
        super();
        
        GrayStyle.addToDefault();

        var container = new xinf.ul.VBox();
        container.moveTo( 200, 100 );
        //zb: TODO uncomment both to see current border behaviour
        //container.style.padding = {l:0, t:0, r:0, b:0};
        //container.style.border = {l:25, t:25, r:25, b:25};
        root.attach(container);

        var chx1 = CheckBox.createSimple("There was a bug", function(e){
            trace("called tick..");
        });
        container.attach(chx1);


        var rbGroup = new xinf.ul.RadioButtonGroup();
        rbGroup.maxSelections = 2;
        
        var rb1 = RadioButton.createSimple(rbGroup, "Bird", "tweeter", function(e){
            trace("radio1");
        });
        container.attach(rb1);
        
        var rb2 = RadioButton.createSimple(rbGroup, "Dog", "woofer", function(e){
            trace("radio2");
        });
        container.attach(rb2);
        
        var rb3 = RadioButton.createSimple(rbGroup, "Cod", "coder", function(e){
            trace("radio3");
        });
        container.attach(rb3);


        var rbGroup2 = new xinf.ul.RadioButtonGroup();
        rbGroup2.maxSelections = 1;
        
        var rb4 = RadioButton.createSimple(rbGroup2, "Foo", "footer", function(e){
            trace("radio4");
        });
        container.attach(rb4);
        
        var rb5 = RadioButton.createSimple(rbGroup2, "Bar", "barter", function(e){
            trace("radio5");
        });
        container.attach(rb5);
    }
    
    public static function main() :Void {
        try {
            new App().run();
        } catch( e:Dynamic ) {
            trace("Exception: "+e+"\n"+haxe.Stack.toString(haxe.Stack.exceptionStack()) );
        }
    }
}
