/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

/**
	DOCME: out of date!
	
    The Keys class provides a single global function ([get]) to 
    convert a runtime-specific numeric key code to a
    xinferno-standard key string.
    <br/>
    "Well-known" Keys are:
    <ul>
        <li>backspace</li>
        <li>tab</li>
        <li>escape</li>
        <li>space</li>
        <li>page up</li>
        <li>page down</li>
        <li>left</li>
        <li>up</li>
        <li>right</li>
        <li>down</li>
    </ul>
**/
class Keys {
    static public var SPECIAL:Int;
    
    private static var keys:IntHash<String>;
    
    private static function __init__() :Void {
        keys = new IntHash<String>();
        
        #if neko
			keys.set(opengl.GLFW.KEY_BACKSPACE,"backspace");
			keys.set(opengl.GLFW.KEY_TAB,"tab");
			keys.set(opengl.GLFW.KEY_ESC,"escape");
			keys.set(opengl.GLFW.KEY_DEL,"delete");
            keys.set(opengl.GLFW.KEY_HOME,"home");
            keys.set(opengl.GLFW.KEY_END,"end");
            keys.set(opengl.GLFW.KEY_PAGEUP,"page up");
            keys.set(opengl.GLFW.KEY_PAGEDOWN,"page down");
            keys.set(opengl.GLFW.KEY_LEFT,"left");
            keys.set(opengl.GLFW.KEY_UP,"up");
            keys.set(opengl.GLFW.KEY_RIGHT,"right");
            keys.set(opengl.GLFW.KEY_DOWN,"down");
        #else true
			keys.set(8,"backspace");
			keys.set(9,"tab");
			keys.set(27,"escape");
			keys.set(32," ");
			keys.set(127,"delete");
            keys.set(33,"page up");
            keys.set(34,"page down");
            keys.set(37,"left");
            keys.set(38,"up");
            keys.set(39,"right");
            keys.set(40,"down");
        #end
		
		#if flash9
		/*
			keys.set(187,"+");
			keys.set(188,",");
			keys.set(189,"-");
			keys.set(190,".");
			*/
		#end
    }
    
    public static function get( code:Int ) :String {
		#if flash
		//if( code>=49 && code<=142 ) return String.fromCharCode(code-16);
		#end
        return( keys.get(code) );
    }
    
}
