/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.geom.Types;
import xinf.geom.Transform;
import xinf.geom.TransformParser;
import xinf.geom.Identity;
import xinf.geom.Matrix;
import xinf.event.Event;

import xinf.style.StyledElement;
import xinf.style.Selector;

import xinf.ony.type.Paint;
import xinf.ony.type.Length;
import xinf.ony.type.JoinStyle;
import xinf.ony.type.CapsStyle;
import xinf.ony.type.Visibility;
import xinf.ony.type.Display;
import xinf.ony.type.StringList;
import xinf.ony.type.IntList;
import xinf.ony.type.TextAnchor;

import xinf.traits.TraitDefinition;
import xinf.traits.BoundedFloatTrait;
import xinf.traits.EnumTrait;
import xinf.traits.FloatTrait;
import xinf.traits.StringTrait;
import xinf.traits.IntTrait;

import xinf.ony.traits.LengthTrait;
import xinf.ony.traits.StringListTrait;
import xinf.ony.traits.IntListTrait;
import xinf.ony.traits.StringChoiceTrait;
import xinf.ony.traits.PaintTrait;
import xinf.ony.traits.TransformTrait;

class Element extends StyledElement {

	static var TRAITS = {
		transform:		new TransformTrait(),
		display:		new EnumTrait<Display>( Display, Inline ),
		visibility:		new EnumTrait<Visibility>( Visibility, Visible ),
		
		opacity:		new BoundedFloatTrait(0,1,1),
		color:			new PaintTrait(null), // just for "currentColor"
		fill:			new PaintTrait(Paint.None),
		fill_opacity:	new BoundedFloatTrait(0,1,1),

		stroke:			new PaintTrait(Paint.None),
		stroke_width:	new LengthTrait(new Length(1)),
		stroke_opacity:	new BoundedFloatTrait(0,1,1),
		stroke_linejoin:new EnumTrait<JoinStyle>( JoinStyle, "join", MiterJoin ),
		stroke_linecap:	new EnumTrait<CapsStyle>( CapsStyle, "caps", ButtCaps ),
		stroke_miterlimit: new FloatTrait(4),
		stroke_dasharray:  new IntListTrait(),
		stroke_dashoffset: new IntTrait(),
		
		font_family:	new StringListTrait(),
		font_size:		new LengthTrait(new Length(10)),
		font_weight:	new StringChoiceTrait( ["normal","bold"] ),
		text_anchor:	new EnumTrait<TextAnchor>( TextAnchor, "", TextAnchor.Start ),
	}

    public var transform(get_transform,set_transform):Transform;
    function get_transform() :Transform { return getTrait("transform",Transform); }
    function set_transform( v:Transform ) :Transform { setTrait("transform",v); retransform(); return v; }

    public var display(get_display,set_display):Display;
    function get_display() :Display { return getStyleTrait("display",Display,false); }
    function set_display( v:Display ) :Display { return setStyleTrait("display",v); }

    public var visibility(get_visibility,set_visibility):Visibility;
    function get_visibility() :Visibility { return getStyleTrait("visibility",Visibility); }
    function set_visibility( v:Visibility ) :Visibility { return setStyleTrait("visibility",v); }

    public var opacity(get_opacity,set_opacity):Null<Float>;
    function get_opacity() :Null<Float> { return getStyleTrait("opacity",Float,false); }
    function set_opacity( v:Null<Float> ) :Null<Float> { return setStyleTrait("opacity",v); }

    public var color(get_color,set_color):Paint;
    function get_color() :Paint { return getStyleTrait("color",Paint); }
    function set_color( v:Paint ) :Paint{ return setStyleTrait("color",v); }
	
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
    function get_stroke_width() :Null<Float> { return getStyleTrait("stroke-width",Length).value; }
    function set_stroke_width( v:Float ) :Null<Float> { setStyleTrait("stroke-width",new Length(v)); return v; }

    public var strokeOpacity(get_stroke_opacity,set_stroke_opacity):Null<Float>;
    function get_stroke_opacity() :Null<Float> { return getStyleTrait("stroke-opacity",Float); }
    function set_stroke_opacity( v:Null<Float> ) :Null<Float> { return setStyleTrait("stroke-opacity",v); }

    public var strokeLinejoin(get_line_join,set_line_join):JoinStyle;
    function get_line_join() :JoinStyle { return getStyleTrait("stroke-linejoin",JoinStyle); }
    function set_line_join( v:JoinStyle ) :JoinStyle { return setStyleTrait("stroke-linejoin",v); }

    public var strokeLinecap(get_line_cap,set_line_cap):CapsStyle;
    function get_line_cap() :CapsStyle { return getStyleTrait("stroke-linecap",CapsStyle); }
    function set_line_cap( v:CapsStyle ) :CapsStyle { return setStyleTrait("stroke-linecap",v); }

    public var strokeMiterlimit(get_stroke_miterlimit,set_stroke_miterlimit):Null<Float>;
    function get_stroke_miterlimit() :Null<Float> { return getStyleTrait("stroke-miterlimit",Float); }
    function set_stroke_miterlimit( v:Null<Float> ) :Null<Float> { return setStyleTrait("stroke-miterlimit",v); }

    public var strokeDasharray(get_stroke_dasharray,set_stroke_dasharray):IntList;
    function get_stroke_dasharray() :IntList { return getStyleTrait("stroke-dasharray",IntList); }
    function set_stroke_dasharray( v:IntList ) :IntList { return setStyleTrait("stroke-dasharray",v); }

    public var strokeDashoffset(get_stroke_dashoffset,set_stroke_dashoffset):Null<Int>;
    function get_stroke_dashoffset() :Null<Int> { return getStyleTrait("stroke-dashoffset",Int); }
    function set_stroke_dashoffset( v:Null<Int> ) :Null<Int> { return setStyleTrait("stroke-dashoffset",v); }

	public var fontFamily(get_font_family,set_font_family):StringList;
    function get_font_family() :StringList { return getStyleTrait("font-family",StringList); }
    function set_font_family( v:StringList ) :StringList { return setStyleTrait("font-family",v); }

    public var fontSize(get_font_size,set_font_size):Float;
    function get_font_size() :Float { return getStyleTrait("font-size",Length).value; }
    function set_font_size( v:Float ) :Float { return setStyleTrait("font-size",new Length(v)).value; }

	// TODO fontWeight, Slant, smallCaps

    public var textAnchor(get_text_anchor,set_text_anchor):TextAnchor;
    function get_text_anchor() :TextAnchor { return getStyleTrait("text-anchor",TextAnchor); }
    function set_text_anchor( v:TextAnchor ) :TextAnchor { return setStyleTrait("text-anchor",v); }

    override function set_id( v:String ) :String { 
		if( ownerDocument!=null ) {
			ownerDocument.elementsById.remove(id);
			ownerDocument.elementsById.set(v,this);
		}
		return super.set_id(v); 
	}

	/** the Element's transformation **/
	/*
	// FIXME: TransformTrait?
    public var transform(default,set_transform):Transform;
	function set_transform( t:Transform ) :Transform {
		transform=t;
		retransform();
		return t;
	}
*/
    public function new( ?traits:Dynamic ) :Void {
        super( traits );
		styleClasses = new Hash<Bool>();
	}

	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties( to );
		to.transform=transform; // FIXME: should dup.
		to.ownerDocument=ownerDocument; // FIXME: maybe not?
	}
	
	/** the bounding box of the element **/
	public function getBoundingBox() : TRectangle {
		trace("getBoundingBox unimplemented for "+this);
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
	
    override public function styleChanged( ?attribute:String ) :Void {
		super.styleChanged(attribute);
		redraw();
	}
			
    /** convert the given point from global to local coordinates **/
    public function globalToLocal( p:TPoint ) :TPoint {
        var q = { x:p.x, y:p.y };
		var parent = getTypedParent( Element );
        if( parent!=null ) q = parent.globalToLocal(q);
        return( transform.applyInverse(q) );
    }
    
    /** convert the given point from local to global coordinates **/
    public function localToGlobal( p:TPoint ) :TPoint {
        var q = { x:p.x, y:p.y };
		var p = getTypedParent( Element );
        if( p!=null ) q = p.localToGlobal(q);
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
		if( parentElement != null && !e.preventBubble && e.type.bubble==true ) {
            parentElement.dispatchEvent(e);
        }
    }

    override public function toString() :String {
		var s = "";
 		if( id!=null ) s += "#"+id;
 		if( name!=null ) s += "(\""+name+"\")";
		return( Type.getClassName( Type.getClass(this) )+s );
    }

}
