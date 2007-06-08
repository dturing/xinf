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

import xinf.event.MouseEvent;
import xinf.erno.Color;
import xinf.ul.Application;
import xinf.ul.Label;
import xinf.ul.Button;
import xinf.ul.LineEdit;
import xinf.ul.Dropdown;
import xinf.ul.Slider;
import xinf.ul.RadioButton;
import xinf.ul.CheckBox;
import xinf.ul.Pane;
import xinf.ul.model.SimpleListModel;
import xinf.ul.list.ListView;

import xinf.ul.Container;
import xinf.ul.layout.FlowLayout;

class App extends Application {
    
    public function new() :Void {
        super();
        
        container.moveTo( 10, 10 );
        container.layout = new FlowLayout( FlowLayout.HORIZONTAL, 5 );
        
        var cont = new Pane();
        cont.layout = new FlowLayout( FlowLayout.VERTICAL, 3 );
        container.attach(cont);

            var label = new Label("Hello, World!");
            cont.attach(label);

            var button:Button<String>;
            var msgs = [ "Thank you","Softly, please.","Thank You","Thanks a lot","Thanks","","Thanks, really." ];
            var stop = [ "That's enough.","Stop, please.","Stop!","Aaargh!",
                         "Please!", "Stop it!", "I can't stand it.", "Noo!", "Please stop clicking me!!", "Stoop!!" ];
            var msg = 0;
            button = Button.createSimple("Click me!", function(v) {
                    if( msg >= msgs.length ) {
                        button.text = stop[ Std.random(stop.length)];
                    } else {
                        button.text = msgs[msg];
                        msg++;
                    }
                    trace("Button Value: "+v );
                }, "Hello" );
            cont.attach(button);
            
            cont.attach( Button.createSimple("Me, too!", function(e) {
                    trace("clicked, yoohooo");
                } ));
            
            var edit = new LineEdit();
            edit.text = "Edit me!";
            cont.attach(edit);

            var slider = new Slider();
            cont.attach(slider);


        var cont = new Pane();
        cont.layout = new FlowLayout( FlowLayout.VERTICAL, 5 );
        container.attach(cont);
        
            var model = SimpleListModel.create(
                [ "foo", "bar", "baz", "fnord", "qux", "quux", "qasi" ] );

            var listbox = new ListView<String>( model );
            listbox.setPrefSize( {x:100.,y:100.} );
            cont.attach( listbox );

            var dropdown = new Dropdown(model);
            cont.attach(dropdown);

/* disabled until fixed.

        var cont = new Pane();
        cont.layout = new FlowLayout( FlowLayout.VERTICAL, 5 );
        container.attach(cont);

            var chx1 = CheckBox.createSimple("There was a bug", function(e){
                trace("called tick..");
            });
            cont.attach(chx1);

            var rbGroup = new xinf.ul.RadioButtonGroup();
            rbGroup.maxSelections = 2;
            
            var traceRadio = function(e:xinf.ul.ValueEvent<String>){
                trace("Radio Button: "+e.value );
            }
            
            var rb1 = RadioButton.createSimple(rbGroup, "Bird", traceRadio, "tweeter");
            cont.attach(rb1);
            
            var rb2 = RadioButton.createSimple(rbGroup, "Dog", traceRadio, "woofer");
            cont.attach(rb2);
            
            var rb3 = RadioButton.createSimple(rbGroup, "Cod", traceRadio, "coder");
            cont.attach(rb3);
*/
    }
    
    public static function main() :Void {
        try {
            new App().run();
        } catch( e:Dynamic ) {
            try {
                trace("Exception: "+e+"\n"+haxe.Stack.toString(haxe.Stack.exceptionStack()) );
            } catch( f:Dynamic ) {
                trace("Exception tracing exception: "+e+" /// "+f );
            }
        }
    }
}
