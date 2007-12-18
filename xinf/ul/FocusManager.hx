/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;
import xinf.event.Event;
import xinf.ul.widget.Widget;

/**
    Keyboard Focus manager singleton
**/
class FocusManager {
    
    private static var widgets:Array<Widget>;
    private static var currentFocus:Int;
    
    private static var timer:Dynamic;
    private static var counter:Int;
    private static var repeat:KeyboardEvent;
    
    public static function setup() :Void {
        if( widgets==null ) {
            widgets = new Array<Widget>();
            currentFocus=-1;
            Root.addEventListener( KeyboardEvent.KEY_DOWN, handleKeyboardEvent );
            Root.addEventListener( KeyboardEvent.KEY_UP, handleKeyboardEvent );
        }
    }
    
    public static function register( w:Widget, ?index:Int ) :Void {
        setup();
        if( index != null ) {
            widgets.insert( index, w );
        } else {
            widgets.push(w);
            index=widgets.length-1;
        }
        if( currentFocus==-1 ) next();
    }

    public static function unregister( w:Widget ) :Bool {
        setup();
        return widgets.remove(w);
    }

    public static function next() :Void {
        if( widgets==null ) return;
        if( currentFocus >= 0 ) widgets[currentFocus].blur();
        currentFocus++;
        if( currentFocus >= widgets.length ) currentFocus=0;
        if( currentFocus >= 0 ) {
            if( !widgets[currentFocus].focus() ) next();
        }
    }

    public static function previous() :Void {
        if( widgets==null ) return;
        if( currentFocus >= 0 ) widgets[currentFocus].blur();
        currentFocus--;
        if( currentFocus < 0 ) currentFocus=widgets.length-1;
        if( currentFocus >= 0 ) {
            if( !widgets[currentFocus].focus() ) previous();
        }
    }
    
    public static function isFocussed( widget:Widget ) :Bool {
        return( widgets[currentFocus] == widget );
    }
    
    public static function setFocus( widget:Widget ) :Void {
        for( i in 0...widgets.length ) {
            if( widgets[i] == widget ) {
                if( i != currentFocus ) {
                    if( currentFocus >= 0 ) widgets[currentFocus].blur();
                    currentFocus=i;
                    widget.focus();
                }
                return;
            }
        }
    }
    
    public static function handleKeyboardEvent( e:KeyboardEvent ) :Void {
        #if flash9
        #else true
        /* key repeat */
        if( e.type == KeyboardEvent.KEY_DOWN ) {
            repeat = e;
            if( timer == null ) {
                counter = 0;
                timer = function( e:FrameEvent ) {
                    counter++;
                    if( counter > 8 && counter%2 == 0 ) {
                        handleKeyboardEvent( repeat );
                    }
                }
                Root.addEventListener( FrameEvent.ENTER_FRAME, timer );
            }
        } else if( e.type == KeyboardEvent.KEY_UP ) {
            Root.removeEventListener( FrameEvent.ENTER_FRAME, timer );
            timer = null;
        }
        #end
        
        if( widgets==null ) return;
        
        if( e.type == KeyboardEvent.KEY_DOWN && e.key == "tab" ) {
            if( e.shiftMod ) previous();
            else next();
            return;
        }
        if( currentFocus >= 0 ) {
            widgets[currentFocus].dispatchEvent(e);
        }
    }
    
}