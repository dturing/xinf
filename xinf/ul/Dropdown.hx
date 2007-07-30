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


import xinf.ony.Root;

import xinf.event.Event;
import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.ScrollEvent;

import xinf.ul.Popup;
import xinf.ul.model.ListModel;
import xinf.ul.list.ListView;
import xinf.ul.list.PickEvent;
import xinf.ul.layout.BorderLayout;

/**
    Improvised Dropdown element.
**/

typedef T=String

class Dropdown extends Widget {
    
    private var model:ListModel<T>;
    
    private var label:Label;
    private var button:Component;
    private var menu:ListView<String>;
    
    private var selectedIndex:Int;
    private var isOpen:Bool;
    private var popup:Popup;
    
    public function new( _model:ListModel<T> ) :Void {
        super();
        
        var layout = new BorderLayout();
        this.layout = layout;
        
        model = _model;
        isOpen=false;
        
        label = new Label( ""+model.getItemAt(selectedIndex=0) );
        attach( label );
        layout.setConstraint( label, Center );
        
        button = new Pane(); //ImageButton( name+"_btn", this, "assets/dropdown/button.png" );
        attach(button);
        layout.setConstraint( button, East );
        
        addEventListener( MouseEvent.MOUSE_DOWN, toggle );
        
        menu = new ListView( model );
        menu.addEventListener( PickEvent.ITEM_PICKED, itemPicked );
        menu.focusable = false;
        
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        addEventListener( ScrollEvent.SCROLL_STEP, onScroll );
    }

    private function itemPicked( e:PickEvent<T> ) :Void {
        select( e.index );
        close();
    }
    
    private function open() :Void {
        addStyleClass(":open");

        var p = localToGlobal( {x:5., y:size.y-(style.border.b) } );
        menu.moveTo( p.x, p.y );
        menu.resize( size.x-5, size.y*5 );
        
        menu.assureVisible( selectedIndex );
        menu.setCursor( selectedIndex );

        popup = new Popup(this,menu,Scale);
        isOpen=true;
    }
    
    private function close() :Void {
        if( popup!=null ) popup.close();
        isOpen=false;
        removeStyleClass(":open");
//        button.contained.load("assets/dropdown/button.png");
    }
    
    public function select( index:Int ) :Void {
        if( index > model.getLength()-1 ) index = model.getLength()-1;
        if( index < 0 ) index=0;
        selectedIndex = index;
        label.text = ""+model.getItemAt( selectedIndex );
        postEvent( new PickEvent<T>( PickEvent.ITEM_PICKED, model.getItemAt(index), index ) );
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
    
    public function blur() :Void {
        super.blur();
        close();
    }
}
