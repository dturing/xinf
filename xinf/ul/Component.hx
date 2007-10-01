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

import xinf.ony.Element;
import xinf.geom.Types;
import xinf.event.SimpleEventDispatcher;
import xinf.style.Stylable;

class Component extends SimpleEventDispatcher, implements Stylable {
    public var __parentSizeListener:Dynamic;

    public var parent(default,null):Container;
	public var style(default,null):ComponentStyle;
    private var styleClasses :Hash<Bool>;
    
	public var prefSize(getPrefSize,null):TPoint;
    var _prefSize:TPoint;
	
	var size:TPoint;
	var element:Element;

    public function new( ?e:Element ) :Void {
		super();
        _prefSize = { x:.0, y:.0 };
		element=e;
		
        styleClasses = new Hash<Bool>();
		
//  TODO      style = StyleSheet.newDefaultStyle();
		style = new ComponentStyle(this);
		        
        // add our own class to the list of style classes
		// TODO check this-- simplify?
        var clNames:Array<String>;
        #if flash9
            clNames = Type.getClassName(Type.getClass(this)).split("::");
        #else true
            clNames = Type.getClassName(Type.getClass(this)).split(".");
        #end
        addStyleClass( clNames[ clNames.length-1 ] );
		
    }

    public function attachedTo( p:Container ) {
        parent=p;
    }

    public function detachedFrom( p:Container ) {
        parent=null;
    }
	
    public function styleChanged() :Void {
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
	public function resize( s:TPoint ) :Void {
		size = s;
	}

    public function getElement() :Element {
		return element;
    }

	// Style class functions
    public function updateClassStyle() :Void {
//        var s = StyleSheet.defaultSheet.match( this );
//        assignStyle(s);
		// TODO
		trace("should updateClassStyle "+styleClasses);
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
	
	public function toString() :String {
		return( Type.getClassName(Type.getClass(this)) );
	}

}
