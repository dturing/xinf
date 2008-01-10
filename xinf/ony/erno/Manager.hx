/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.event.FrameEvent;
import xinf.event.MouseEvent;
import xinf.event.ScrollEvent;

/**
    Xinfony creates one singleton Manager object as a static private member of Element.
    <p>
    It keeps a list (actually an IntHash) of all Elements,
    keeps track of changes to their contents or transformation
    and re-draws and re-transforms those that changed, once for each frame
    and using <a href="../erno/Runtime.html">Runtime</a>'s global renderer.
    <p></p>
    It also dispatches MouseEvent.MOUSE_DOWN and ScrollEvent.SCROLL_STEP to the
    Element whose ID is given in the Event (xinf.erno only knows about IDs, and
    has no reference to the actual object).
    </p>
    <p>
    All public functions on Manager are for use from <a href="Element.html">Element</a>,
    there should be no need to "manually" register any object.
    Use Element.redraw() to mark an object as changed.
    </p>
**/
class Manager {
    
    private var objects:IntHash<Element>;
    private var changed:IntHash<Element>;
    private var moved:IntHash<Element>;

    public function new() :Void {
        objects = new IntHash<Element>();
        changed = new IntHash<Element>();
        moved   = new IntHash<Element>();

        // redraw changed objects each frame
        Runtime.addEventListener( FrameEvent.ENTER_FRAME,
            redrawChanged );

        // dispatch some events to targets (xinferno only knows about IDs, not Elements 
        Runtime.addEventListener( MouseEvent.MOUSE_DOWN, dispatchToTarget );
        Runtime.addEventListener( MouseEvent.MOUSE_OVER, dispatchToTarget );
        Runtime.addEventListener( MouseEvent.MOUSE_OUT, dispatchToTarget );
        Runtime.addEventListener( ScrollEvent.SCROLL_STEP, dispatchToTarget );
    }

    private function dispatchToTarget( e:Dynamic ) :Void {
        if( e.targetId != null ) {
            var target = find( e.targetId );
            if( target != null ) target.postEvent( e );
        }
    }
    
    public function register( id:Int, o:Element ) :Void {
        // TODO #if debug, check if already set.
        objects.set(id,o);
    }

    public function unregister( id:Int) :Void {
        // TODO #if debug, check if set.
        objects.remove(id);
		changed.remove(id);
		moved.remove(id);
		Runtime.renderer.destroyObject(id);
    }

    public function objectChanged( id:Int, o:Element ) :Void {
        changed.set(id,o);
    }

    public function objectMoved( id:Int, o:Element ) :Void {
        moved.set(id,o);
    }

    private function redrawChanged( e:FrameEvent ) :Void {
        var somethingChanged:Bool = false;
        var g:Renderer = Runtime.renderer;
        
 		#if profile
 			xinf.test.Profile.before("transform");
 		#end

		var ch = moved;
        moved = new IntHash<Element>();
        for( id in ch.keys() ) {
            ch.get(id).reTransform( g );
            somethingChanged = true;
        }

 		#if profile
			xinf.test.Profile.after("transform");
 			xinf.test.Profile.before("draw");
 		#end

        var ch = changed;
        changed = new IntHash<Element>();
        for( id in ch.keys() ) {
            ch.get(id).draw( g );
            somethingChanged = true;
        }

 		#if profile
 			xinf.test.Profile.after("draw");
 		#end

        if( somethingChanged ) Runtime.runtime.changed();
    }
    
    public function find( id:Int ) :Element {
        return objects.get(id);
    }
    
}
