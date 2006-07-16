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
import xinf.ony.KeyboardEvent;
import xinf.ony.GeometryEvent;
import xinf.ony.ScrollEvent;

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
	private var isOpen:Bool;
    
    public function new( name:String, parent:xinf.ony.Element, _model:ListModel ) :Void {
        super( name, parent );
        model = _model;
		isOpen=false;
        
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
		menu.focusable = false;
        
		addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		addEventListener( ScrollEvent.SCROLL_STEP, onScroll );
    }

	private function sizeChanged( e:GeometryEvent ) :Void {
    //    button.bounds.setPosition( bounds.width - labelHeight, 0 );
    //    label.bounds.setSize( bounds.width-labelHeight, labelHeight );
        menu.bounds.setPosition( 0, label.bounds.height );
        menu.bounds.setSize( bounds.width, labelHeight*5 );
    }

	private function itemPicked( e:PickEvent ) :Void {
		select( e.index );
		close();
        //postEvent( Event.ITEM_PICKED, selectedIndex );
    }
    private function open() :Void {
		menu.assureVisible( selectedIndex );
		menu.select( selectedIndex );
        menu.visible = true;
		isOpen=true;
		addStyleClass(":open");
		button.contained.load("assets/dropdown/open/button.png");
		// FIXME: scroll to selected.
	}
    private function close() :Void {
        menu.visible = false;
		isOpen=false;
		removeStyleClass(":open");
		button.contained.load("assets/dropdown/button.png");
	}
	private function select( index:Int ) :Void {
		if( index > model.getLength()-1 ) index = model.getLength()-1;
		if( index < 0 ) index=0;
        selectedIndex = index;
        label.text = model.getItemAt( selectedIndex );
	}
	
    private function toggle<T>( e:Event<T> ) :Void {
        if( isOpen ) close();
		else open();
    }
    
	private function onKeyDown( e:KeyboardEvent ) {
		if( isOpen ) {
			if( e.key == "escape" ) {
				close();
				return;
			}
			menu.onKeyDown(e);
			return;
		}
		switch( e.key ) {
			case "up":
				select( selectedIndex-1 );
			case "down":
				select( selectedIndex+1 );
			case "space":
				toggle(e);
		}
	}
	
	private function onScroll( e:ScrollEvent ) {
		if( !isOpen ) {
			select( selectedIndex + Math.round(e.value) );
		}
	}
}
