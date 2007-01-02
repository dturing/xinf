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
import xinf.ul.ListBox;
import xinf.ul.Popup;

import xinf.ony.Root;

import xinf.event.Event;
import xinf.event.MouseEvent;
import xinf.event.KeyboardEvent;
import xinf.event.ScrollEvent;

/**
    Improvised Dropdown element.
**/

typedef T=String

class Dropdown extends Widget {
    
    private var model:ListModel<T>;
    
    private var label:Label;
    private var button:xinf.style.StyleClassElement;
    private var menu:ListBox<String>;
    
    private var selectedIndex:Int;
    private var isOpen:Bool;
    private var popup:Popup;
    
    public function new( _model:ListModel<T> ) :Void {
        super();
        
        model = _model;
        isOpen=false;
        
        label = new Label( model.getNameAt(selectedIndex=0) );
        label.moveTo( 1, 1 );
        attach( label );
        
        button = new Pane(); //ImageButton( name+"_btn", this, "assets/dropdown/button.png" );
        button.addStyleClass("Thumb");
        attach(button);
        
        addEventListener( MouseEvent.MOUSE_DOWN, toggle );
        
        menu = new ListBox( model );
        menu.addEventListener( PickEvent.ITEM_PICKED, itemPicked );
        menu.focusable = false;
        
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        addEventListener( ScrollEvent.SCROLL_STEP, onScroll );
    }

    override public function resize( x:Float, y:Float ) :Void {
        super.resize(x,y);
        button.moveTo( size.x - size.y, 0 );
        button.resize( size.y, size.y );
    }

    private function itemPicked( e:PickEvent<T> ) :Void {
        select( e.index );
        close();
    }
    
    private function open() :Void {
        menu.assureVisible( selectedIndex );
        menu.select( selectedIndex );
        
        var p = localToGlobal( {x:5, y:size.y } );
        menu.moveTo( p.x, p.y );
        menu.resize( size.x-5, size.y*5 );
        
        popup = new Popup(this,menu,Scale);
        isOpen=true;
        addStyleClass(":open");
//        button.contained.load("assets/dropdown/open/button.png");
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
        label.text = model.getNameAt( selectedIndex );
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
