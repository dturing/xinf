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
import xinf.ony.Application;
import xinf.ul.Label;
import xinf.ul.Button;
import xinf.ul.ListModel;
import xinf.ul.ListBox;
import xinf.ul.LineEdit;
import xinf.ul.GrayStyle;
import xinf.ul.Dropdown;
import xinf.ul.Slider;
import xinf.ul.RadioButton;
import xinf.ul.CheckBox;
import xinf.ul.Pane;

import xinf.ul.ComponentContainer;
import xinf.ul.layout.FlowLayout;

class App extends Application {
    
    public function new() :Void {
        super();
        
        GrayStyle.addToDefault();
        
        var top = new xinf.ul.RootComponent();
        top.layout = new FlowLayout( FlowLayout.HORIZONTAL, 5 );
        top.moveTo( 20, 20 );
        
        var container = new Pane();
        container.layout = new FlowLayout( FlowLayout.VERTICAL, 5 );
        top.attach(container);

            var label = new Label("Hello, World!");
            container.attach(label);

            var button:Button<String>;
            var msgs = [ "Thank you","Thank You","Thanks a lot","Thanks","","","Thanks, really.",
                        "That's enough.","Stop, please.","Stop!","Aaargh!" ];
            var msg = 0;
            button = Button.createSimple("Click me!", function(v) {
                    button.text = msgs[msg];
                    if( msg < msgs.length-1 ) msg++;
                    trace("Button Value: "+v );
                }, "Hello" );
            container.attach(button);
            
            container.attach( Button.createSimple("Me, too!", function(e) {
                    trace("clicked, yoohooo");
                } ));
            
            var edit = new LineEdit();
            edit.text = "Edit me!";
            container.attach(edit);

            var slider = new Slider();
            container.attach(slider);


        var container = new Pane();
        container.layout = new FlowLayout( FlowLayout.VERTICAL, 5 );
        top.attach(container);
        
            var model = SimpleListModel.create(
                [ "foo", "bar", "baz", "fnord", "qux", "quux", "qasi" ] );

            var listbox = new ListBox<String>( model );
            listbox.setPrefSize( {x:100.,y:100.} );
            container.attach( listbox );

            var dropdown = new Dropdown(model);
            container.attach(dropdown);


        var container = new Pane();
        container.layout = new FlowLayout( FlowLayout.VERTICAL, 5 );
        top.attach(container);

            var chx1 = CheckBox.createSimple("There was a bug", function(e){
                trace("called tick..");
            });
            container.attach(chx1);


            var rbGroup = new xinf.ul.RadioButtonGroup();
            rbGroup.maxSelections = 2;
            
            var traceRadio = function(e:xinf.ul.ValueEvent<String>){
                trace("Radio Button: "+e.value );
            }
            
            var rb1 = RadioButton.createSimple(rbGroup, "Bird", traceRadio, "tweeter");
            container.attach(rb1);
            
            var rb2 = RadioButton.createSimple(rbGroup, "Dog", traceRadio, "woofer");
            container.attach(rb2);
            
            var rb3 = RadioButton.createSimple(rbGroup, "Cod", traceRadio, "coder");
            container.attach(rb3);

        root.attach(top);
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
