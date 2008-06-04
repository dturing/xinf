/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package nekobind;

import nekobind.translator.Translator;
import nekobind.type.TypeRep;
import haxe.rtti.Type;

typedef FriendClass = {
	cStruct:String,
	primitive:String
}

class Generator {
	public static var CALL_MAX_ARGS:Int = 5;
	
	var translator:Translator;
	var settings:Settings;
	
	var allGlobal:Bool;
	var prefix:String;
	var friendClasses:Hash<FriendClass>;
	var superClass:String;

	public function new() :Void {
		translator = new Translator();
		settings = new Settings();
		allGlobal = false;
		prefix = "";
		friendClasses = new Hash<FriendClass>();
	}

	function print( s:String ) {
		neko.Lib.print(s);
	}


	private static var _Void:TypeRep = new VoidType();
	private static var _Bool:TypeRep = new TypeRep("bool","Bool","int");
	private static var _Int:TypeRep = new NumericType( "int", "Int", "int" );
	private static var _Float:TypeRep = new NumericType( "float", "Float", "double" );
	private static var _String:TypeRep = new StringType();
	private static var _Dynamic:TypeRep = new DynamicType();
	
	public function getType( type:Type ) :TypeRep {
		var r:TypeRep;
		
		switch( type ) {
			case TEnum(name,p):
				switch( name ) {
					case "Void":
						r = _Void;
					case "Bool":
						r = _Bool;
					default:
						throw("unhandled Enum: "+name);
				}
			case TClass(name,p):
				switch( name ) {
					case "String":
						r = _String;
					case "Int":
						r = _Int;
					case "Float":
						r = _Float;
					default:
						var friend=friendClasses.get(name);
						if( friend!=null ) {
							r = new FriendClassType(name,friend.cStruct,friend.primitive);
						} else 
							throw("unknown class: "+name );
				}
			case TDynamic(t):
				r = _Dynamic;
			case TAnonymous(args):
				r = _Dynamic;
			default:
				throw("unhandled Type: "+type );
		}
		if( r==null ) r = new UnknownType();
		return r;
	}


	public function parseSettings( settings:Dynamic, c:String ) :Void {
		if( c!=null ) {
			for( e in Xml.parse(c).elements() ) {
				if( e.nodeName == "nekobind" ) {
					for( a in e.attributes() ) {
						Reflect.setField( settings, a, e.get(a) );
					}

					for( e2 in e.elements() ) {
						switch( e2.nodeName ) {
							case "cptr":
								var r = new CPtrType( e2.get("type"), e2.get("min-size"), e2.get("null-allowed")=="true" );
								settings.argTypes.set( e2.get("name"), r );
							default:
						}
					}
				} else if( StringTools.startsWith( e.nodeName, "nekobind:" )) {
					Reflect.setField( settings, e.nodeName.split(":").pop(), 
						StringTools.htmlUnescape(StringTools.trim( e.firstChild().nodeValue )));
				}
			}

			// clarify some settings
			if( settings.translator != null ) {
				translator = Translator.getTranslator( settings.translator );
			}
			
			if( settings.friends != null ) {
				for( f in new String(settings.friends).split(",") ) {
					var fc = StringTools.trim(f).split(":");
					if( fc.length != 2 ) throw("Friends class definitions need 'HaxeClass:CStruct>Primitive' syntax: '"+f+"' doesn't match");
					var cp = fc[1].split(">");
					if( cp.length != 2 ) throw("Friends class definitions need 'HaxeClass:CStruct>Primitive' syntax: '"+f+"' doesn't match");
					friendClasses.set( fc[0], { cStruct:cp[0], primitive:cp[1] } );
				}
			}
		}
	}

	public function resolveType( e:Type ) :TypeRep {
		return( getType(e) );
	}

	public function resolveTypes( src:List<{ name:String, opt:Bool, t:Type }>, funcSettings:Settings ) :Array<{ name:String, opt:Bool, t:Type, r:TypeRep }> {
		var dst = new Array<{ name:String, opt:Bool, t:Type, r:TypeRep }>();
		for( s in src ) {
			var r = funcSettings.argTypes.get(s.name);
			if( r==null ) r = resolveType(s.t);
				
			var t = {
				name:s.name,
				opt:s.opt,
				t:s.t,
				r:r
			};
			dst.push(t);
		}
		return( dst );
	}
	
	public function iterateArguments( 
				args:Array<{ name:String, opt:Bool, t:Type, r:TypeRep }>,
				f :String->Bool->Type->TypeRep->Bool->Void ) {
		var i=args.iterator(); var arg;
		while( (arg=i.next()) != null ) {
			f( arg.name, arg.opt, arg.t, arg.r, !i.hasNext() );
		}
	}

	public function handleFunction( f:ClassField, args:Array<{ name:String, opt:Bool, t:Type, r:TypeRep }>, ret:TypeRep, functionSettings:Settings ) {
	}

	public function handleStaticVarClass( field:ClassField, className:String ) :Void {
	}

	public function handleClass( e:TypeInfos, c:Classdef ) {
		friendClasses.set( e.path, { cStruct:settings.cStruct, primitive:settings.primitive } );
		if( c.superClass != null ) superClass = c.superClass.path.toString();

		// process fields
		for( field in c.fields ) {
			var functionSettings = new Settings();
			parseSettings( functionSettings, field.doc );
			
			switch( field.type ) {
				case TFunction(a,ret):
					handleFunction(field,resolveTypes(a,functionSettings),resolveType(ret),functionSettings);
				default:
			}
		}
		
		// process statics
		for( field in c.statics ) {
			var functionSettings = new Settings();
			parseSettings( functionSettings, field.doc );
			functionSettings.isStatic=true;
			
			switch( field.type ) {
				case TFunction(a,ret):
					handleFunction(field,resolveTypes(a,functionSettings),resolveType(ret),functionSettings);
				case TClass(name,params):
					handleStaticVarClass( field, name );
				default:
			}
		}
	}
}
