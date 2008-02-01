/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.geom.Transform;
import xinf.ony.type.CapsStyle;
import xinf.ony.type.JoinStyle;
import xinf.ony.type.Visibility;
import xinf.ony.type.Display;
import xinf.ony.type.Paint;
import xinf.erno.Constants;

class Element extends xinf.ony.Element {
    
    private static var _manager:Manager;
    private static var manager(getManager,null):Manager;
    
    /** Unique (to the runtime environment) ID of this object. Will be set automatically, in the constructor. 
        Note that this has nothing to do with the SVG 'id' property (which is a String, while this is numeric) **/
    public var xid(default,null):Null<Int>;

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
		xid=null;
	//	xid = Runtime.runtime.getNextId();
    //    manager.register( xid, this );
    //    redraw();
    }
	

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties(to);
	//	to.xid = Runtime.runtime.getNextId();
	//	to.redraw();
	}

	function construct() :Void {
		if( xid!=null ) throw("constructing an object that is already constructed");
	//	trace("construct "+this );
		xid = Runtime.runtime.getNextId();
        manager.register( xid, this );
		redraw();
	}
	
    function destroy() :Void {
		//if( xid==null ) throw("destroying an object that is already destroyed");
		if( xid!=null ) {
			manager.unregister(xid);
			xid=null;
		}
    }

    /** apply new transformation (position)<br/>
        This is an internal function, you should usually not care about it.
        **/
    public function reTransform( g:Renderer ) :Void {
		if( xid==null ) throw("no xid: "+this);
        var m = transform.getMatrix();
        g.setTransform( xid, m.tx, m.ty, m.a, m.b, m.c, m.d );
    }
    
    /** draw the Object to the given [Renderer]<br/>
        You should usually neither call nor override this function,
        instead, schedule a redraw with [redraw()] and 
        override [drawContents()] to draw stuff.
        **/
    public function draw( g:Renderer ) :Void {
		if( xid==null ) throw("no xid: "+this);
        g.startObject( xid );
			if( display != Display.None && visibility != Visibility.Hidden )
				drawContents(g);
        g.endObject();
        reTransform(g); // FIXME: needed?
    }
    
	function convertPaint( paint:Paint, opacity:Float ) {
        if( paint!=null ) {
			switch( paint ) {
				case URLReference(url):
					var r = ownerDocument.getTypedElementByURI( url, PaintServer );
					if( r==null ) throw("Referenced Paint not found: "+url );
					return r.getPaint(this);
				case RGBColor(r,green,b):
					return( xinf.erno.Paint.SolidColor(r,green,b,opacity) );
				case None:
					return xinf.erno.Paint.None;
			}
		} 
		return null;
	}

    /** draw the Object's 'own' contents (not it's children) to the given [Renderer]<br/>
        You can override this method, and call the [Renderer]'s methods to draw things.
        Everything you do will be in the Object's local coordinate space.
        **/
    public function drawContents( g:Renderer ) :Void {
		#if profile
			xinf.test.Counter.count("drawContents");
		#end

		g.setFill( convertPaint(fill,fillOpacity*opacity) );
		
		if( stroke!=null ) {
			var w = strokeWidth;
			var caps = strokeLinecap;
			var join = strokeLinejoin;
			var miterLimit = strokeMiterlimit;

			var _caps = switch( caps ) {
				case ButtCaps: Constants.CAPS_BUTT;
				case RoundCaps: Constants.CAPS_ROUND;
				case SquareCaps: Constants.CAPS_SQUARE;
			}
			var _join = switch( join ) {
				case MiterJoin: Constants.JOIN_MITER;
				case RoundJoin: Constants.JOIN_ROUND;
				case BevelJoin: Constants.JOIN_BEVEL;
			}
			var dashArray:Array<Int> = null;
			if( strokeDasharray != null ) {
				dashArray = strokeDasharray.list;
				if( dashArray.length % 2 == 1 &&
					( dashArray.length!=1 || dashArray[0]!=0 ) ) {
					var d2 = new Array<Int>();
					for( i in dashArray ) d2.push(i);
					for( i in dashArray ) d2.push(i);
					dashArray = d2;
				}
			}
			var paint = convertPaint( stroke, strokeOpacity*opacity );
			g.setStroke( paint, w, _caps, _join, miterLimit, dashArray, strokeDashoffset );
		} else g.setStroke( 0 );
    }

    override public function redraw() :Void {
		if( xid!=null ) manager.objectChanged( xid, this );
    }
    
    override public function retransform() :Void {
        if( xid!=null ) manager.objectMoved( xid, this );
    }

}