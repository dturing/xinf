/* 
   xinf is not flash.
   Copyr (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.style;

import xinf.ony.Object;
import xinf.style.Style;
import xinf.style.StyleClassElement;

class StyleSelector {
    
    public function matches( e:Object ) :Bool {
        return true;
    }
    
}

class ClassNameSelector extends StyleSelector {
    
    var classes:Array<String>;

    public function new( c:Array<String> ) :Void {
        classes = c;
    }
    
    override public function matches( _e:Object ) :Bool {
        if( !Std.is(_e,StyleClassElement) ) return false;
        var e:StyleClassElement = cast( _e, StyleClassElement );
        for( c in classes ) {
            if( !e.hasStyleClass(c) ) return false;
        }
        return true;
    }
    
}

class AncestorSelector extends StyleSelector {
    
    private var selector:StyleSelector;

    public function new( s:StyleSelector ) :Void {
        selector=s;
    }

    override public function matches( e:Object ) :Bool {
        var p = e.parent;
        while( p != null ) {
            if( selector.matches(p) ) {
                return true;
            }
            p = p.parent;
        }
        return false;
    }
    
}

class ParentSelector extends StyleSelector {
    
    private var selector:StyleSelector;

    public function new( s:StyleSelector ) :Void {
        selector=s;
    }

    override public function matches( e:Object ) :Bool {
        return( e.parent != null && selector.matches(e.parent) );
    }
    
}

class CombinedSelector extends StyleSelector {
    
    private var selectors:Array<StyleSelector>;

    public function new( s:Array<StyleSelector> ) :Void {
        selectors = s;
    }
    
    override public function matches( e:Object ) :Bool {
        for( s in selectors ) {
            if( !s.matches( e ) ) return false;
        }
        return true;
    }
    
}

typedef StyleRule = {
    var selector:StyleSelector;
    var style:Style;
}

class StyleSheet {
    
    public static var defaultStyle:Style;
    public static var defaultSheet:StyleSheet;
    
    public static function __init__() :Void {
        defaultStyle = newDefaultStyle();
        defaultSheet = new StyleSheet();
    }
    
    private var byClassName :Hash<List<StyleRule>>;
    
    public function new() :Void {
        byClassName = new Hash<List<StyleRule>>();
    }
    
    public function add( classNames:Array<String>, ?otherSelector:StyleSelector, style:Dynamic ) {
        var selector:StyleSelector = new ClassNameSelector(classNames);
        if( otherSelector != null ) {
            selector = new CombinedSelector( [ selector, otherSelector ] );
        }
        var rule = {
            selector:selector,
            style:Style.createFromObject(style)
        };
        var l = byClassName.get(classNames[0]);
        if( l==null ) {
            l = new List<StyleRule>();
            byClassName.set( classNames[0], l );
        }
        l.push( rule );
    }
    
    private function findStyles( e:StyleClassElement ) :Iterator<Style> {
        var styles = new Array<Style>();
        var i=0;
        var classNames = e.getStyleClasses();
        for( className in classNames ) {
            var s = byClassName.get( className );
            if( s!=null ) {
                for( rule in s ) {
                    if( rule.selector.matches(e) ) styles.push( rule.style );
                }
            }
        }
        return styles.iterator();
    }
    
    public function match( e:StyleClassElement ) :Style {
        return aggregateStyles( findStyles( e ) );
    }

    public static function aggregateStyles( styles:Iterator<Style> ) :Style {
        var r = newDefaultStyle();
        if( styles == null ) return r;
        for( style in styles ) {
            r.setFrom(style);
        }
        return r;
    }
    
    public static function newDefaultStyle():Style {
        return Style.createFromObject( {
            padding: { l:0, t:0, r:0, b:0 },
            border: { l:0, t:0, r:0, b:0 },
        } );
    }
    
}
