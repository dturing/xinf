package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.geom.Types;
import xinf.geom.Transform;
import xinf.geom.Matrix;
import xinf.event.Event;

import xinf.style.StyledNode;
import xinf.style.Selector;

// these should probably be moved to some basic xinf.Types:
import xinf.erno.Paint;
import xinf.erno.JoinStyle;
import xinf.erno.CapsStyle;
import xinf.ony.Visibility;
import xinf.type.StringList;

import xinf.traits.TraitDefinition;
import xinf.traits.BoundedFloatTrait;
import xinf.traits.PaintTrait;
import xinf.traits.UnitFloatTrait;
import xinf.traits.EnumTrait;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.traits.StringListTrait;
import xinf.traits.StringChoiceTrait;
// TODO import xinf.traits.TransformTrait;

class Element extends StyledNode {

	static var TRAITS = {
		xml__base:		new StringTrait(),
		opacity:		new BoundedFloatTrait(0,1,1),
		
		fill:			new PaintTrait(SolidColor(0,0,0,1)),
		fill_opacity:	new BoundedFloatTrait(0,1,1),

		stroke:			new PaintTrait(None),
		stroke_width:	new UnitFloatTrait(1),
		stroke_opacity:	new BoundedFloatTrait(0,1,1),
		stroke_linejoin:new EnumTrait<JoinStyle>( JoinStyle, "join", MiterJoin ),
		stroke_linecap:	new EnumTrait<CapsStyle>( CapsStyle, "caps", ButtCaps ),
		stroke_miterlimit: new FloatTrait(4),
		
		font_family:	new StringListTrait(),
		font_size:		new UnitFloatTrait(10.),
		font_weight:	new StringChoiceTrait( ["normal","bold"] ),
		
		visibility:		new EnumTrait<Visibility>( Visibility ),
	}
	
    public var base(get_base,set_base):String; // FIXME: maybe, as xml: is not a "normal" namespace prefix, this might actually work... - although, it's not really a style trait, but is inherited...
    function get_base() :String { 
		var p=this;
		var b:String=null;
		while( p!=null ) {
			var thisBase = p.getTrait("xml:base",String);
			if( thisBase!=null ) b = if( b!=null ) thisBase+b else thisBase; // FIXME: actually, URL.relateTo
			p = p.parent;
		}
		return b; 
	} 
    function set_base( v:String ) :String { redraw(); return setStyleTrait("xml:base",v); }
	
    public var visibility(get_visibility,set_visibility):Visibility;
    function get_visibility() :Visibility { 
        var v = getTrait("visibility",Visibility); 
		// FIXME: this crap.
        if( v==Visibility.Inherit ) {
            return getStyleTrait("visibility",Visibility);
        }
        return v;
    }
    function set_visibility( v:Visibility ) :Visibility { return setStyleTrait("visibility",v); }

    public var opacity(get_opacity,set_opacity):Null<Float>;
    function get_opacity() :Null<Float> { return getStyleTrait("opacity",Float); }
    function set_opacity( v:Null<Float> ) :Null<Float> { return setStyleTrait("opacity",v); }

    public var fill(get_fill,set_fill):Paint;
    function get_fill() :Paint { return getStyleTrait("fill",Paint); }
    function set_fill( v:Paint ) :Paint{ return setStyleTrait("fill",v); }

    public var fillOpacity(get_fill_opacity,set_fill_opacity):Null<Float>;
    function get_fill_opacity() :Null<Float> { return getStyleTrait("fill-opacity",Float); }
    function set_fill_opacity( v:Null<Float> ) :Null<Float> { return setStyleTrait("fill-opacity",v); }

    public var stroke(get_stroke,set_stroke):Paint;
    function get_stroke() :Paint { return getStyleTrait("stroke",Paint); }
    function set_stroke( v:Paint ) :Paint { return setStyleTrait("stroke",v); }

    public var strokeWidth(get_stroke_width,set_stroke_width):Null<Float>;
    function get_stroke_width() :Null<Float> { return getStyleTrait("stroke-width",Float); }
    function set_stroke_width( v:Float ) :Null<Float> { return setStyleTrait("stroke-width",v); }

    public var strokeOpacity(get_stroke_opacity,set_stroke_opacity):Null<Float>;
    function get_stroke_opacity() :Null<Float> { return getStyleTrait("stroke-opacity",Float); }
    function set_stroke_opacity( v:Null<Float> ) :Null<Float> { return setStyleTrait("stroke-opacity",v); }

    public var fontFamily(get_font_family,set_font_family):StringList;
    function get_font_family() :StringList { return getStyleTrait("font-family",StringList); }
    function set_font_family( v:StringList ) :StringList { return setStyleTrait("font-family",v); }

    public var fontSize(get_font_size,set_font_size):Float;
    function get_font_size() :Float { return getStyleTrait("font-size",Float); }
    function set_font_size( v:Float ) :Float { return setStyleTrait("font-size",v); }

    public var lineJoin(get_line_join,set_line_join):JoinStyle;
    function get_line_join() :JoinStyle { return getStyleTrait("stroke-linejoin",JoinStyle); }
    function set_line_join( v:JoinStyle ) :JoinStyle { return setStyleTrait("stroke-linejoin",v); }

    public var lineCap(get_line_cap,set_line_cap):CapsStyle;
    function get_line_cap() :CapsStyle { return getStyleTrait("stroke-linecap",CapsStyle); }
    function set_line_cap( v:CapsStyle ) :CapsStyle { return setStyleTrait("stroke-linecap",v); }

    public var strokeMiterlimit(get_stroke_miterlimit,set_stroke_miterlimit):Null<Float>;
    function get_stroke_miterlimit() :Null<Float> { return getStyleTrait("stroke-miterlimit",Float); }
    function set_stroke_miterlimit( v:Null<Float> ) :Null<Float> { return setStyleTrait("stroke-miterlimit",v); }

	// TODO fontWeight


    override function set_id( v:String ) :String { 
		if( document!=null ) {
			document.elementsById.remove(id);
			document.elementsById.set(v,untyped this); // FIXME gnaa
		}
		return super.set_id(v); 
	}

    /** Group that contains this Element, if any. **/
    public var parent(default,null):Group;

    /** Document that ultimately contains this Element **/
    public var document(default,null):Document;		// FIXME: update elementsById

	/** the Element's transformation **/
	// FIXME: TransformTrait?
    public var transform(default,set_transform):Transform;
	function set_transform( t:Transform ) :Transform {
		transform=t;
		retransform();
		return t;
	}

    public function new( ?traits:Dynamic ) :Void {
        super( traits );
		
        transform = new Identity();
		styleClasses = new Hash<Bool>();
	}

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties( to );
		to.transform=transform; // FIXME: should dup.
		to.document=document;
	}

    /** read element data from xml */
    override public function fromXml( xml:Xml ) :Void {
		super.fromXml( xml );
		
        if( xml.exists("transform") ) {
            transform = TransformParser.parse( xml.get("transform") );
        }
    }
	
	/** the bounding box of the element **/
	public function getBoundingBox() : TRectangle {
		throw("unimplemented");
		return { l:0., t:0., r:0., b:0. };
	}

    /**    
		schedule this Object for redefining it's transformation<br/>
        You should usually not need to call this yourself, 
		the Object will be automatically scheduled
        when you modify it's transformation.
    **/
	public function retransform() :Void {
	}

    /** schedule this Object for redrawing<br/>
        The Object will (on JavaScript: <i>should</i>) be redrawn before the next frame is shown to the user.
        Call this function whenever your Object needs to redraw itself because it's (immediate) content changed
        - there's no need to call it if anything changes about it's children. 
    **/
	public function redraw() :Void {
	}

    /** do something when attached to a parent Group **/
    public function attachedTo( p:Group ) :Void {
        parent=p;
        document=parent.document;
        styleChanged(); // FIXME not neccessarily...
    }

    /** do something when detached from a parent Group **/
    function detachedFrom( p:Group ) :Void {
        parent=null;
        document=null;
    }

    override public function styleChanged() :Void {
		super.styleChanged();
		redraw();
	}
	
	override public function getStyleParent() :StyledNode {
		return parent;
	}
	
	override public function matchSelector( s:Selector ) :Bool {
		switch(s) {
		
			case Parent(sel):
				if( parent==null ) return false;
				return parent.matchSelector(sel);
				
			case Ancestor(sel):
				var p = this;
				while( p.parent != null ) {
					p = p.parent;
					if( p.matchSelector(sel) ) return true;
				}
				return false;

			case GrandAncestor(sel):
				if( parent==null ) return false;
				var p = parent;
				while( p.parent != null ) {
					p = p.parent;
					if( p.matchSelector(sel) ) return true;
				}
				return false;

			case Preceding(sel):
				if( parent==null ) return false;
				// FIXME: maybe implement children as a doubly-linked list?
				var p:Element = null;
				for( c in parent.children ) {
					if( c==this ) {
						if( p==null ) return false;
						return( p.matchSelector(sel) );
					}
					p=c;
				}
				return false;

			default:
				return super.matchSelector(s);
		}
	}
		
    override public function updateClassStyle() :Void {
		if( document!=null && document.styleSheet!=null ) {
			_matchedStyle = document.styleSheet.match(this);
			styleChanged();
		}
    }

    /** convert the given point from global to local coordinates **/
    public function globalToLocal( p:TPoint ) :TPoint {
        var q = { x:p.x, y:p.y };
        if( parent!=null ) q = parent.globalToLocal(q);
        return( transform.applyInverse(q) );
    }
    
    /** convert the given point from local to global coordinates **/
    public function localToGlobal( p:TPoint ) :TPoint {
        var q = { x:p.x, y:p.y };
        if( parent!=null ) q = parent.localToGlobal(q);
        return( transform.apply(q) );
    }

    /** dispatch the given Event<br/>
        tries to dispatch the given Event to any registered listeners.
        If no handler is found, 'bubble' the Event - i.e., pass it up to our parent.
    **/
    override public function dispatchEvent<T>( e : Event<T> ) :Void {
        var l:List<Dynamic->Void> = listeners.get( e.type.toString() );
        var dispatched:Bool = false;
        if( l != null ) {
            for( h in l ) {
                h(e);
                dispatched=true;
            }
        }
 		// old logic is to bubble only if not handled:  if( !dispatched && 
		if( parent != null && !e.preventBubble && e.type.bubble==true ) {
            parent.dispatchEvent(e);
        }
    }

    public function toString() :String {
		var s = "";
 		if( id!=null ) s += "#"+id;
 		if( name!=null ) s += "(\""+name+"\")";
		return( Type.getClassName( Type.getClass(this) )+s );
    }

}
