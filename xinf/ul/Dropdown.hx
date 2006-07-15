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

import xinf.event.Event;
import xinf.ul.Button;
import xinf.ul.ListModel;
import xinf.ul.ListBox;

import xinf.ony.MouseEvent;
import xinf.ony.GeometryEvent;

/**
    Improvised Dropdown element.
    
    TODO: currently, all child labels are reassigned. that could be optimized
    to reassign only the ones that need to be, and move the rest.
**/

class Dropdown extends xinf.ul.Combo<xinf.ul.Label,ImageButton> {
    private var model:ListModel;
    private static var labelHeight:Int = 20;
    
    private var label:Label;
    private var button:ImageButton;
    private var menu:ListBox;
    
    private var selectedIndex:Int;
    
    public function new( name:String, parent:xinf.ony.Element, _model:ListModel ) :Void {
        super( name, parent );
        model = _model;
        
        label = new Label( name+"_lbl", this );
        label.text = model.getItemAt(selectedIndex=0);
		setLeft( label );
        label.addEventListener( MouseEvent.MOUSE_DOWN, toggle );
        
        button = new ImageButton( name+"_btn", this, "assets/dropdown/button.png" );
        button.addEventListener( MouseEvent.MOUSE_DOWN, toggle );
		setRight( button );

        bounds.addEventListener( GeometryEvent.SIZE_CHANGED, sizeChanged );
        
        menu = new ListBox( name+"_menu", this, model );
        menu.bounds.setPosition( 0, label.bounds.height-1 );
        menu.bounds.setSize( 100, labelHeight*5 );
		menu.addEventListener( PickEvent.ITEM_PICKED, itemPicked );
        menu.visible = false;
        
    }

	private function sizeChanged( e:GeometryEvent ) :Void {
    //    button.bounds.setPosition( bounds.width - labelHeight, 0 );
    //    label.bounds.setSize( bounds.width-labelHeight, labelHeight );
        menu.bounds.setPosition( 0, label.bounds.height );
        menu.bounds.setSize( bounds.width, labelHeight*5 );
    }

	private function itemPicked( e:PickEvent ) :Void {
        selectedIndex = e.index;
        label.text = model.getItemAt( selectedIndex );
		close();
        //postEvent( Event.ITEM_PICKED, selectedIndex );
    }
    private function open() :Void {
        menu.visible = true;
		addStyleClass(":open");
		button.contained.load("assets/dropdown/open/button.png");
	}
    private function close() :Void {
        menu.visible = false;
		removeStyleClass(":open");
		button.contained.load("assets/dropdown/button.png");
	}
	
    private function toggle<T>( e:Event<T> ) :Void {
        if( hasStyleClass(":open") ) close();
		else open();
    }
    
}
