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
import xinf.ony.Pane;
import xinf.ony.Element;
import xinf.ony.Color;
import xinf.ul.VScrollbar;
import xinf.ul.Label;
import xinf.ul.ListModel;
import xinf.ul.ListBox;

/**
    Improvised Dropdown element.
    
    TODO: currently, all child labels are reassigned. that could be optimized
    to reassign only the ones that need to be, and move the rest.
**/

class Dropdown extends Pane {
    private var model:ListModel;
    private static var labelHeight:Int = 20;
    
    private var label:Label;
    private var button:Pane;
    private var menu:ListBox;
    
    private var selectedIndex:Int;
    
    public function new( name:String, parent:Element, _model:ListModel ) :Void {
        super( name, parent );
        model = _model;
        
        label = new Label( name+"_label", this );
        label.text = model.getItemAt(selectedIndex=0);
        label.setBackgroundColor( new Color().fromRGBInt( 0xeeeeee ) );
        label.addEventListener( Event.MOUSE_DOWN, open );
        
        button = new Pane( name+"_pane", this );
        button.bounds.setSize( labelHeight, labelHeight );
        button.addEventListener( Event.MOUSE_DOWN, open );
        button.setBackgroundColor( new Color().fromRGBInt( 0xaaaaaa ) );
        
        bounds.addEventListener( Event.SIZE_CHANGED, sizeChanged );
        
        menu = new ListBox( name+"_menu", this, model );
        menu.addEventListener( Event.ITEM_PICKED, itemPicked );
        menu.visible = false;
        
        setBackgroundColor( new Color().fromRGBInt( 0xff0000 ) );
    }

    private function sizeChanged( e:Event ) :Void {
        button.bounds.setPosition( bounds.width - labelHeight, 0 );
        label.bounds.setSize( bounds.width-labelHeight, labelHeight );
        menu.bounds.setPosition( 0, label.bounds.height );
        menu.bounds.setSize( bounds.width, labelHeight*5 );
    }

    private function itemPicked( e:Event ) :Void {
        selectedIndex = e.data.index;
        label.text = model.getItemAt( selectedIndex );
        menu.visible = false;
    }
    
    private function open( e:Event ) :Void {
        menu.visible = true;
    }
    
}
