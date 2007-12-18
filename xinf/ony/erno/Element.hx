/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.geom.Transform;
import xinf.type.CapsStyle;
import xinf.type.JoinStyle;
import xinf.type.Paint;
import xinf.type.Visibility;
import xinf.ony.PaintProvider;

class Element extends xinf.ony.base.Element {
    
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
    
    public function new( ?traits:Dynamic ) :Void {
		super( traits );
		xid = Runtime.runtime.getNextId();
        manager.register( xid, this );
        redraw();
    }
	
	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties(to);
		to.xid = Runtime.runtime.getNextId();
        manager.register( to.xid, to );
		to.redraw();
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
    }
    
    /** draw the Object to the given [Renderer]<br/>
        You should usually neither call nor override this function,
        instead, schedule a redraw with [redraw()] and 
        override [drawContents()] to draw stuff.
        **/
    public function draw( g:Renderer ) :Void {
        g.startObject( xid );
            switch( visibility ) {
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
		#if profile
			xinf.test.Counter.count("drawContents");
		#end
        if( fill!=null ) {
			switch( fill ) {
				case URLReference(url):
					var r = ownerDocument.getTypedElementByURI( url, PaintProvider );
					if( r==null ) throw("Referenced Paint not found: "+url );
					g.setFill( r.getPaint(this) );
				case SolidColor(r,green,b,a):
					g.setFill( SolidColor(r,green,b,a*fillOpacity*opacity) );
				default:
					g.setFill( fill );
			}
		} else g.setFill( null );

		if( stroke!=null ) {
			var w = strokeWidth;
			var caps = lineCap;
			var join = lineJoin;
			var miterLimit = strokeMiterlimit;
			// TODO: dash
			var dashArray:Iterable<Float> = null;
			var dashOffset:Null<Float> = null;
			
			switch( stroke ) {
				case URLReference(url):
					var r = ownerDocument.getTypedElementByURI( url, PaintProvider );
					if( r==null ) throw("Referenced Paint not found: "+url );
					g.setStroke( r.getPaint(this), w, caps, join, miterLimit, dashArray, dashOffset );
				case SolidColor(r,green,b,a):
					g.setStroke( SolidColor(r,green,b,a*strokeOpacity*opacity), w, caps, join, miterLimit, dashArray, dashOffset );
				default:
					g.setStroke( stroke, w, caps, join, miterLimit, dashArray, dashOffset );
			}
		} else g.setStroke( 0 );
    }

    override public function redraw() :Void {
        manager.objectChanged( xid, this );
    }
    
    override public function retransform() :Void {
        manager.objectMoved( xid, this );
    }

}