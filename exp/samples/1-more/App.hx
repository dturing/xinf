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
import xinf.ul.RoundRobin;
import xinf.ul.Label;
import xinf.ul.Pane;
import xinf.ul.ListModel;
import xinf.ul.Widget;
import xinf.ul.ListBox;

import xinf.ul.TreeModel;
import xinf.ul.TreeView;
import xinf.ul.Container;
import xinf.ul.layout.FlowLayout;

class App extends Application {
    
    public function new() :Void {
        super();
        
        GrayStyle.addToDefault();

        var container = new Pane();
        container.layout = new FlowLayout( FlowLayout.HORIZONTAL, 5 );
        root.attach(container);

        var model = new SimpleListModel<String>();
        for( i in 0...100 ) {
            model.addItem("Item #"+i);
        }
        
        var list = new ListBox( model );
        list.resize( 100, 100 );
        container.attach(list);
        
        
        var foo = new SimpleNode( "Fruit" );
        foo.addSimple("Apple");
        foo.addSimple("Cherry");
        
        var exotic = new SimpleNode( "Exotic" );
        exotic.addSimple("Mango");
        exotic.addSimple("Banana");
        exotic.addSimple("Kiwi");
        exotic.addSimple("Ananas");

        foo.addChild( exotic );
        
        var bar = new SimpleNode( "Vegetable" );
        bar.addSimple("Tomato");
        bar.addSimple("Potato");
        bar.addSimple("Radish");

        var meat = new SimpleNode( "Meat" );
        meat.addSimple("Beef");
        meat.addSimple("Pork");
        meat.addSimple("Chicken");
        meat.addSimple("Fish");

        var baz = new SimpleNode( "Nut" );
        baz.addSimple("Cashew");
        baz.addSimple("Pecan");
        baz.addSimple("Almond");
        baz.addSimple("Peanut");
        baz.addSimple("Walnut");

        var tree = new SimpleNode( "Root" );
        tree.addChild(foo);
        tree.addChild(bar);
        tree.addChild(meat);
        tree.addChild(baz);
        
        var v = new TreeView( tree );
        v.resize( 100, 100 );
        container.attach( v );
    }
    
    public static function main() :Void {
        try {
            new App().run();
        } catch( e:Dynamic ) {
            trace("Exception: "+e+"\n"+haxe.Stack.toString(haxe.Stack.exceptionStack()) );
        }
    }
}
