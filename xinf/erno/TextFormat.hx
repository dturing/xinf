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

package xinf.erno;

#if js
    import js.Dom;
#end

class TextFormat {

    public var family(default,setFamily):String;
    public var size(default,setSize):Float;
    public var bold(default,setBold):Bool;
    public var italic(default,setItalic):Bool;
    
    var dirty:Bool;

    // member setters
    
    function setFamily( family:String ) :String {
        this.family = family;
        dirty=true;
        trace("set family: "+family );
        return family;
    }

    function setSize( size:Float ) :Float {
        this.size = size;
        dirty=true;
        return size;
    }

    function setBold( v:Bool ) :Bool {
        this.bold = v;
        dirty=true;
        return v;
    }

    function setItalic( v:Bool ) :Bool {
        this.italic = v;
        dirty=true;
        return v;
    }
    
    
    // constructor (private, use create())
    function new( ?family:String,  ?size:Float, ?bold:Bool, ?italic:Bool ) :Void {
        if( family==null ) family="_sans"; //"_sans";
        if( size==null ) size=12.0;
        if( bold==null ) bold=false;
        if( italic==null ) italic=false;
        this.family=family; 
        this.size=size; 
        this.bold=bold; 
        this.italic=italic;
        dirty=true;
    }
    
    // API for child class use
    public function assureLoaded() :Void {
        if( dirty ) load();
    }

    // API for child classes to override
    
    public function textSize( text:String ) :{ x:Float, y:Float } {
        // children should assureLoaded() if they expect load() to be called when dirty.
        return null;
    }
    /*
    public function applyToNative( n:NativeObject ) :Void {
        // children should assureLoaded() if they expect load() to be called when dirty.
    }
    */

    public function load() :Void {
        dirty=false;
    }
    
    
    // public access members for runtime-specific renderers
    
    #if neko
    public var font:xinf.inity.font.Font;
    #else flash
    public var format:flash.text.TextFormat;
    #else js
    public function apply( to:js.HtmlDom ) :Void;
    #end
    
    // Factory
    public static function create( ?family:String, ?size:Float, ?bold:Bool, ?italic:Bool) :TextFormat {
        #if neko
            return new xinf.inity.font.XTextFormat(family,size,bold,italic);
        #else flash
            return new xinf.flash9.Flash9TextFormat(family,size,bold,italic);
        #else js
            return new xinf.js.JSTextFormat(family,size,bold,italic);
        #end
    }
    
    // default font
    static var DEFAULT;
    public static function getDefault() :TextFormat {
        if( DEFAULT==null ) DEFAULT=create();
        return DEFAULT;
    }
    
}
