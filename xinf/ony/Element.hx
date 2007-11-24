package xinf.ony;

import xinf.event.Event;
import xinf.event.EventKind;
import xinf.event.EventDispatcher;

import xinf.geom.Types;
import xinf.geom.Transform;
import xinf.geom.Matrix;

import xinf.style.Stylable;
import xinf.style.Selector;

import xinf.xml.Serializable;

class Element 
	extends __ElementImpl,
	implements Serializable, implements Stylable {

    /** textual (SVG) id **/
    public var id(default,null):String;

    /** textual name (name attribute) **/
    public var name(default,null):String;

    /** Group that contains this Element, if any. **/
    public var parent(default,null):Group;

    /** Document that ultimately contains this Element **/
    public var document(default,null):Document;

    // transform and style must be declared in ElementImpl

    public function new() :Void {
        super();
		
        transform = new Identity();
        style = new xinf.style.ElementStyle(this);
	}
	
    /** read element data from xml */
    public function fromXml( xml:Xml ) :Void {
        if( xml.exists("id") ) {
            id = xml.get("id");
        }
        if( xml.exists("name") ) {
            name = xml.get("name");
        }
        if( xml.exists("style") ) {
            style.parse( xml.get("style") );
        }
        style.fromXml( xml );
        
        if( xml.exists("transform") ) {
            transform = TransformParser.parse( xml.get("transform") );
        }
    }
	
	/** called when the document is completely loaded **/
	public function onLoad() :Void {
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
	}
	
	public function getParentStyle() :xinf.style.Style {
		if( parent!=null ) return parent.style;
		return null;
	}

	public function matchSelector( s:Selector ) :Bool {
		// TODO
		return false;
	}

    public function toString() :String {
        return( Type.getClassName( Type.getClass(this) )+"#"+id+":"+name );
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
		if( !dispatched && parent != null ) {
            parent.dispatchEvent(e);
        }
    }

    /* SVG parsing helper function-- should go somewhere else? FIXME */
    function getFloatProperty( xml:Xml, name:String, ?def:Float ) :Float {
        if( xml.exists(name) ) return Std.parseFloat(xml.get(name));
        if( def==null ) def=0;
        return def;
    }

    function getBooleanProperty( xml:Xml, name:String, ?def:Bool ) :Bool {
        if( xml.exists(name) ) {
            var v = xml.get(name);
            if( v.toLowerCase()=="true" || v=="1" ) return true;
            return false;
        }
        if( def==null ) def=false;
        return def;
    }
}
