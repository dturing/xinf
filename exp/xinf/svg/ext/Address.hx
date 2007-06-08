/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.svg.ext;

class UntypedEventKind extends xinf.event.EventKind<Dynamic> {
}


enum Path {
    Origin;
    ById( id:String );
    Field( o:Path, name:String );
    FunctionCall( o:Path, name:String );
    EventHandler( o:Path, name:String );
}

class Address {
    public static function parse( address:String ) :Path {
        var p:Path = Origin;
        for( a in address.split(".") ) {
            if( a.substr(0,1)=="#" ) {
                p = ById(a.substr(1));
            } else {
                var s = a.split(":");
                if( s.length==2 ) {
                    switch( s[0] ) {
                        case "f":
                            p = FunctionCall(p,s[1]);
                        case "e":
                            p = EventHandler(p,s[1]);
                    }
                } else {
                    p = Field( p, a );
                }
            }
        }
        return p;
    }
    
    public static function get( origin:Dynamic, doc:xinf.svg.Document, path:Path ) :Dynamic {
        switch( path ) {
            case Origin:
                return( origin );
                
            case ById( id ):
                return( doc.getElementById(id) );
                
            case Field( o, name ):
                return( Reflect.field( get( origin, doc, o ), name ) );
                
            case FunctionCall( o, name ):
                var obj = get( origin, doc, o );
                var f = Reflect.field( obj, name );
                return( Reflect.callMethod( obj, f, [ ] ) );
                
            case EventHandler( o, name ):
                throw("Cannot get the value of an Event Listener: "+path );
        }
        return null;
    }
    
    public static function set<T>( origin:Dynamic, doc:xinf.svg.Document, path:Path, v:Dynamic ) :Dynamic {
        switch( path ) {
            case Origin:
                return( origin=v );
                
            case ById( id ):
                throw("cannot set element by ID");
                
            case Field( o, name ):
                return( Reflect.setField( get( origin, doc, o ), name, v ) );
                
            case FunctionCall( o, name ):
                var obj = get( origin, doc, o );
                var f = Reflect.field( obj, name );
                if( obj==null ) throw("no object "+o);
                if( f==null ) throw("no function "+o+".f:"+name);
            //   trace("call "+o+"."+name+": "+f+" -- "+v );
                return( Reflect.callMethod( obj, f, [ v ] ) );
                
            case EventHandler( o, name ):
                throw("Cannot set the value of an Event Listener: "+path );
        }
        return v;
    }
    
    public static function register( origin:Dynamic, doc:xinf.svg.Document, path:Path, field:Path, f:Dynamic->Void ) :Dynamic {
        switch( path ) {
            case EventHandler( o, name ):
                var obj:Dynamic = get(origin,doc,o);
            //    trace("register "+obj+"::"+name );
                obj.addEventListener( new UntypedEventKind(name), function( e:Dynamic ) {
                        var v = get( e, doc, field );
                        f(v);
                    } );
            
            default:
                throw("Cannot register address: "+path );

        }
    }
}