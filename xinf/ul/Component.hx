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

import Xinf;
import xinf.event.SimpleEventDispatcher;
import xinf.style.Style;
import xinf.style.Stylable;
import xinf.style.StyleSheet;
import xinf.style.Selector;
import xinf.style.Border;
import xinf.style.StringList;
import xinf.event.SimpleEvent;
import xinf.ul.skin.Skin;

class Component extends SimpleEventDispatcher, implements Stylable {
	public static var styleSheet:StyleSheet<ComponentStyle> 
		= new StyleSheet<ComponentStyle>(
			function( s:Style ) { return new ComponentStyleWrapper(s); },
	[
		{ selector:Any, style:new ComponentStyle({
				padding: new Border(6,3,6,3),
				border: new Border(1,1,1,1),
				horizontal_align: 0.,
				vertical_align: .5,
				font_family: new StringList(["sans"]),
				font_size: 12,
				text_color: Color.BLACK,
				min_width: 100,
			}) },
		{ selector:StyleClass("Label"), style:new ComponentStyle({
				padding: new Border(2,2,2,2),
				border: new Border(0,0,0,0),
				horizontal_align: 0.,
				vertical_align: .5,
				font_family: new StringList(["sans"]),
				font_size: 12,
				text_color: Color.BLACK,
			}) },
		{ selector:StyleClass("Button"), style:new ComponentStyle({
				padding: new Border(6,3,6,3),
				border: new Border(1,1,1,1),
				min_width: 100,
				min_height: 10,
				horizontal_align: .5,
				vertical_align: .5,
			}) },
		{ selector:StyleClass(":focus"), style:new ComponentStyle({
				skin: "focus",
				padding: new Border(5,2,5,2),
				border: new Border(2,2,2,2),
			}) },
		{ selector:StyleClass(":press"), style:new ComponentStyle({
				skin: "press",
			}) },
		{ selector:StyleClass("ListView"), style:new ComponentStyle({
				padding: new Border( 3,1,0,1 ),
			}) },
	]);

    public var __parentSizeListener:Dynamic;

    public var parent(default,null):Container;
	public var style(default,null):ComponentStyle;
    var styleClasses :Hash<Bool>;
	var skin:Skin;
    
	public var prefSize(getPrefSize,null):TPoint;
    var _prefSize:TPoint;
	
	public var size(default,set_size):TPoint;
	public var position(default,set_position):TPoint; // TODO!
	var element:Element;

    public function new( ?e:Element ) :Void {
		super();
        _prefSize = { x:.0, y:.0 };
		element=e;
		if( element==null ) {
			element = new Group();
		}
		
		skin = new xinf.ul.skin.SimpleSkin();
		
        styleClasses = new Hash<Bool>();
		
		style = new ComponentStyle(this);
		        
        // add our own class to the list of style classes
        var clNames:Array<String> = Type.getClassName(Type.getClass(this)).split(".");
        addStyleClass( clNames[ clNames.length-1 ] );
		
    }

    public function attachedTo( p:Container ) {
        parent=p;
    }

    public function detachedFrom( p:Container ) {
        parent=null;
    }
	
    public function styleChanged() :Void {
		skin.setTo( style.skin );
    }
	
	public function getParentStyle() :xinf.style.Style {
		if( parent!=null ) return parent.style;
		return null;
	}

    public function getPrefSize() :TPoint {
        return( _prefSize );
    }
    
    public function setPrefSize( n:TPoint ) :TPoint {
        var s = n; //addPadding(n);
        if( _prefSize==null || s.x!=_prefSize.x || s.y!=_prefSize.y ) {
            _prefSize = s;
            postEvent( new ComponentSizeEvent( ComponentSizeEvent.PREF_SIZE_CHANGED, _prefSize.x, _prefSize.y, this ) );
        }
        return( _prefSize );
    }
	
	// perform the actual resizing, called by the layout manager
	public function set_size( s:TPoint ) :TPoint {
		size = s;
		skin.resize( s );
		return s;
	}
	
	public function set_position( p:TPoint ) :TPoint {
		position = p;
		if( element!=null ) {
			element.transform = new Translate(p.x,p.y);
		}
		return( p );
	}

    public function getElement() :Element {
		return element;
    }

	// Style class functions
    public function updateClassStyle() :Void {
		style = styleSheet.match(this);
		//trace("Style: "+style );
		styleChanged();
    }
    
    public function addStyleClass( name:String ) :Void {
        styleClasses.set( name, true );
        updateClassStyle();
    }
    
    public function removeStyleClass( name:String ) :Void {
        styleClasses.remove( name );
        updateClassStyle();
    }
    
    public function hasStyleClass( name:String ) :Bool {
        return styleClasses.get(name);
    }

    public function getStyleClasses() :Iterator<String> {
        return styleClasses.keys();
    }
	
	public function matchSelector( s:Selector ) :Bool {
		switch( s ) {
		
			case Any:
				return true;
				
			case StyleClass(name):
				return hasStyleClass( name );
				
			case Parent(sel):
				return parent.matchSelector(sel);
				
			case Ancestor(sel):
				var p = this;
				while( p.parent != null ) {
					p = p.parent;
					if( p.matchSelector(sel) ) return true;
				}
				return false;
				
			case AnyOf(a):
				for( sel in a ) {
					if( matchSelector(sel) ) return true;
				}
				return false;
				
			case AllOf(a):
				for( sel in a ) {
					if( !matchSelector(sel) ) return false;
				}
				return true;
				
			default:
				return false;
				
		}
	}
	
	public function toString() :String {
		return( Type.getClassName(Type.getClass(this)) );
	}

}
