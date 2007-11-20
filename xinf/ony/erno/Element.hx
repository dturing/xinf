package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.style.StyleParser;
import xinf.style.Selector;
import xinf.geom.Transform;

class Element {
    
    private static var _manager:Manager;
    private static var manager(getManager,null):Manager;
    
    /** Unique (to the runtime environment) ID of this object. Will be set automatically, in the constructor. 
        Note that this has nothing to do with the SVG 'id' property (which is a String, while this is numeric) **/
    public var xid(default,null):Int;

	private static function getManager() :Manager {
        if( _manager == null ) {
            _manager = new Manager();
        }
        return _manager;
    }

    public static function findById(id:Int) :Element {
        return( manager.find(id) );
    }

    function set_transform( t:Transform ) :Transform {
        scheduleTransform();
        return super.set_transform(t);
    }
    
    public function new() :Void {
		xid = Runtime.runtime.getNextId();
        manager.register( xid, this );
        scheduleRedraw();
    }
    
    /** Object destructor<br/>
        You must call this function if you want to get rid of this object and free
        all associated memory. (Yes, is garbage-collected, but we need some
        trigger to free all associated objects in the runtime. This is it.)
        
        Could this be done on deattach? we dont need it registered any more...
    **/
    public function destroy() :Void {
        // how about deleting our associated Sprite/Div/GLObject?
        // also: detach from parent
        manager.unregister(xid);
    }

    /** apply new transformation (position)<br/>
        This is an internal function, you should usually not care about it.
        **/
    public function reTransform( g:Renderer ) :Void {
        var m = transform.getMatrix();
        g.setTransform( xid, m.tx, m.ty, m.a, m.b, m.c, m.d );
        // TODO g.setTranslation( xid, position.x, position.y );
    }
    
    /** draw the Object to the given [Renderer]<br/>
        You should usually neither call nor override this function,
        instead, schedule a redraw with [scheduleRedraw()] and 
        override [drawContents()] to draw stuff.
        **/
    public function draw( g:Renderer ) :Void {
        g.startObject( xid );
            switch( style.visibility ) {
                case Hidden:
                    // nada
                default:
                    drawContents(g);
            }
        g.endObject();
        reTransform(g);
    }
    
    /** draw the Object's 'own' contents (not it's children) to the given [Renderer]<br/>
        You can override this method, and call the [Renderer]'s methods to draw things.
        Everything you do will be in the Object's local coordinate space.
        **/
    public function drawContents( g:Renderer ) :Void {
		var opacity = style.opacity;
		if( opacity==null ) opacity=1.;
		
		var fillOpacity = style.fillOpacity;
		if( fillOpacity==null ) fillOpacity=1.;
		
        var fill = style.fill;
		if( fill!=null ) g.setFill( fill.r, fill.g, fill.b, (fillOpacity*opacity) );
        else g.setFill( 0,1,1,1 );

        var stroke = style.stroke;
        var w = style.strokeWidth;
        if( w==null ) w=1.;
        if( stroke!=null ) {
            #if neko
            // naah. FIXME
            //    w = localToGlobal( {x:w,y:0.} ).x;
            #end
            g.setStroke( stroke.r,stroke.g,stroke.b,stroke.a,w );
        } else {
            // maybe: if fill is also null, black!
            g.setStroke( 0,0,0,0,w );
        }
    }

    /** schedule this Object for redrawing<br/>
        The Object will (on JavaScript: <i>should</i>) be redrawn before the next frame is shown to the user.
        Call this function whenever your Object needs to redraw itself because it's (immediate) content changed
        - there's no need to call it if anything changes about it's children. 
    **/
    public function scheduleRedraw() :Void {
        manager.objectChanged( xid, this );
    }
    
    /**    schedule this Object for redefining it's transformation<br/>
        You should usually not need to call this yourself, the Object will be automatically scheduled
        when you modify it's transformation.
    **/
    public function scheduleTransform() :Void {
        manager.objectMoved( xid, this );
    }

    override public function styleChanged() :Void {
        scheduleRedraw();
    }

}