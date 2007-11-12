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

package xinf.ul.widget;

import Xinf;

import xinf.ul.Popup;
import xinf.ul.model.ListModel;
import xinf.ul.list.ListView;
import xinf.ul.list.PickEvent;
import xinf.event.Event;
import xinf.ul.layout.Helper;

/**
    Improvised Dropdown element.
**/

typedef T=String

class Dropdown extends Widget {
    
    private var model:ListModel<T>;
    
    private var textElement:Text;
    private var button:Rectangle;
    private var menu:ListView<String>;
    
    private var selectedIndex:Int;
    private var isOpen:Bool;
    private var popup:Popup;
    
    public function new( _model:ListModel<T> ) :Void {
        textElement = new Text();
		
        super();
        
        model = _model;
        isOpen=false;
        
		textElement.text = model.getItemAt(selectedIndex=0);
        group.attach( textElement );
        
        button = new Rectangle();
        group.attach(button);
        
        group.addEventListener( MouseEvent.MOUSE_DOWN, toggle );
        
        menu = new ListView( model );
        menu.addEventListener( untyped PickEvent.ITEM_PICKED, itemPicked );
        menu.focusable = false;
        
        addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
        addEventListener( ScrollEvent.SCROLL_STEP, onScroll );
		
		styleChanged();
    }

	override public function set_size( s:TPoint ) :TPoint {
		textElement.y = Helper.topOffsetAligned( this, s.y, .5 );
		textElement.x = Helper.leftOffsetAligned( this, s.x, style.horizontalAlign );
		
		button.x = s.x-s.y;
		button.width = button.height = s.y;
		
		return super.set_size(s);
	}

    override public function styleChanged() {
		super.styleChanged();
		
		textElement.style.fontSize = style.fontSize;
		textElement.style.fontFamily = style.fontFamily;
		textElement.style.fill = style.textColor;
		textElement.styleChanged();
		
		// TODO: fontWeight
		if( textElement.text!=null ) {
			var s = Helper.addPadding( style.getTextFormat().textSize(textElement.text), style );
			s.x += s.y; // add button.width==height
			setPrefSize( s );
		}
    }

    private function itemPicked( e:PickEvent<T> ) :Void {
        select( e.index );
        close();
    }
    
    private function open() :Void {
        addStyleClass(":open");

        var p = group.localToGlobal( {x:5., y:size.y-(style.border.b) } );
        menu.position = p;
        menu.size = { x:size.x-5., y:size.y*5. };
        
        menu.assureVisible( selectedIndex );
        menu.setCursor( selectedIndex );

        popup = new Popup(this,menu,Scale);
        isOpen=true;
    }
    
    private function close() :Void {
        if( popup!=null ) popup.close();
        isOpen=false;
        removeStyleClass(":open");
    }
    
    public function select( index:Int ) :Void {
        if( index > model.getLength()-1 ) index = model.getLength()-1;
        if( index < 0 ) index=0;
        selectedIndex = index;
        textElement.text = ""+model.getItemAt( selectedIndex );
		styleChanged();
        postEvent( new PickEvent<T>( untyped PickEvent.ITEM_PICKED, model.getItemAt(index), index ) );
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
    
    override public function blur() :Void {
        super.blur();
        close();
    }
}
