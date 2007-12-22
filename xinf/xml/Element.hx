/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.xml;

import xinf.traits.TraitAccess;
import xinf.traits.TraitDefinition;
import xinf.traits.TraitException;
import xinf.traits.SpecialTraitValue;
import xinf.traits.StringTrait;
import xinf.style.StyleParser;

import xinf.event.EventDispatcher;
import xinf.event.Event;
import xinf.event.EventKind;

class Element extends Node,
		implements TraitAccess,
		implements EventDispatcher {

	var _traits:Dynamic;
    var listeners :Hash<List<Dynamic->Void>>;
    var filters :List<Dynamic->Bool>;

	static var TRAITS = {
		id:new StringTrait(),
		name:new StringTrait(),
	}

    /** textual (XML) id **/
    public var id(get_id,set_id):String;
    function get_id() :String { return getTrait("id",String); } // FIXME: maybe directly return id? as no inheritance? same for name
    function set_id( v:String ) :String { return setTrait("id",v); }

    /** textual name (name attribute) **/
    public var name(get_name,set_name):String;
    function get_name() :String { return getTrait("name",String); }
    function set_name( v:String ) :String { return setTrait("name",v); }

    public function new( ?traits:Dynamic ) :Void {
		super();
		_traits = Reflect.empty();
        listeners = new Hash<List<Dynamic->Void>>();
		if( traits!=null ) setTraitsFromObject(traits);
	}
	
	override public function fromXml( xml:Xml ) :Void {
		super.fromXml( xml );
		setTraitsFromXml( xml );
		if( id!=null ) {
			ownerDocument.elementsById.set(id,this);
		}
	}
		
	/**********************/
	/** Traits functions **/
	
	public function getTrait<T>( name:String, type:Dynamic ) :T {
		var v = Reflect.field(_traits,name);
		if(v!=null) {
			if( Std.is(v,type) ) {
				return v;
			}
			throw( new TraitTypeException( name, this, v, type ) );
		}
		
		var def = getTraitDefinition(name);
		if( def!=null ) {
			var d = def.getDefault();
			return d;
		}
		
		return null;
	}

	public function setTrait<T>( name:String, value:T ) :T {
		Reflect.setField(_traits,name,value);
		return value;
	}

	public function setStyleTrait<T>( name:String, value:T ) :T {
		return setTrait(name,value);
	}

	public function getStyleTrait<T>( name:String, value:T, ?inherit:Bool ) :T {
		return setTrait(name,value);
	}

	public function setTraitFromString( name:String, value:String, to:Dynamic ) :Void {
		if( value=="inherit" ) {
			Reflect.setField( to, name, Inherit.inherit );
			return;
		}
		
		var def = getTraitDefinition(name);
		// FIXME: maybe, see if it has a setter?
//		trace("set "+name+" to (string)'"+value+"' - parsed "+def.parse(value) );
		if( def!=null )
			Reflect.setField( to, name, def.parse(value) );
	}

	public function setTraitFromDynamic( name:String, value:Dynamic, to:Dynamic ) :Void {
		var def = getTraitDefinition(name);
		if( def!=null )
			Reflect.setField( to, name, def.fromDynamic(value) );
	}
	
	public function setTraitsFromObject( o:Dynamic ) {
		StyleParser.fromObject(o,this,_traits);
	}
	
	public function setTraitsFromXml( xml:Xml ) {
		for( field in xml.attributes() ) {
			try {
				// for now, strip namespace...
				var f2:String = field;
				var a = field.split(":");
				if( a.length>1 ) f2 = a[a.length-1];
				setTraitFromString( f2, xml.get(field), _traits );
			} catch( e:TraitNotFoundException ) {
//				trace("Trait not found: "+name );
			}
		}
	}
	
	function getTraitDefinition( _name:String ) :TraitDefinition {
		var name = StringTools.replace( StringTools.replace(_name,"-","_"), ":", "__" );
		var cl:Class<Dynamic> = Type.getClass( this );
		var t:TraitDefinition;
		while( t==null && cl!=null ) {
			t = getClassTrait( cl, name );
			cl = Type.getSuperClass(cl);
		}
//		if( t==null ) throw( new TraitNotFoundException(name,this) );
		return t;
	}
	
	function getClassTrait( cl, name:String ) :TraitDefinition {
		var traits:Dynamic = Reflect.field(cl,"TRAITS");
		if( traits!=null ) return Reflect.field(traits,name);
		return null;
	}
	
	/*******************************/
	/** EventDispatcher functions **/

    public function addEventListener<T>( type :EventKind<T>, h :T->Void ) :T->Void {
        var t = type.toString();
        var l = listeners.get( t.toString() );
        if( l==null ) {
            l = new List<Dynamic->Void>();
            listeners.set( t, l );
        }
        l.push( h );
        return h;
    }

    public function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool {
        var l:List<Dynamic->Void> = listeners.get( type.toString() );
        if( l!=null ) {
            return( l.remove(h) );
        }
        return false;
    }

    public function removeAllListeners<T>( type :EventKind<T> ) :Bool {
        return( listeners.remove( type.toString() ) );
    }

    public function addEventFilter( f:Dynamic->Bool ) :Void {
        if( filters==null ) filters=new List<Dynamic->Bool>();
        filters.push(f);
    }

    public function dispatchEvent<T>( e : Event<T> ) :Void {
        var l:List<Dynamic->Void> = listeners.get( e.type.toString() );
        var dispatched:Bool = false;
        
        if( filters!=null ) {
            for( f in filters ) {
                if( f(e)==false ) return;
            }
        }
        
        if( l != null ) {
            for( h in l ) {
                h(e);
                dispatched=true;
            }
        }
    }

    public function postEvent<T>( e : Event<T>, ?pos:haxe.PosInfos ) :Void {
        // FIXME if debug_events
        e.origin = pos;
        
        // for now, FIXME (maybe, put them thru a global queue)
        dispatchEvent(e);
    }

	/********************/
	/** Node functions **/

	override function acquired( newChild:Node ) :Void {
		super.acquired(newChild);
		newChild.parentElement = this;
	}
	
	override function copyProperties( to:Dynamic ) :Void {
		super.copyProperties( to );
		
		// copy traits
		to._traits = Reflect.copy(_traits);
		
		// copy my event listeners
		to.listeners = new Hash<List<Dynamic->Void>>();
		for( e in listeners.keys() ) {
			var v = listeners.get(e);
            var l = new List<Dynamic->Void>();
			for( i in v ) {
				l.add(i);
			}
            to.listeners.set( e, l );
		}
	}
	
}
