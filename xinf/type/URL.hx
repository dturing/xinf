/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.type;

class URL {
    public var protocol:String;
    public var host:String;
    public var port:Int;
    public var path:String;
	public var filename:String;
    // fragments (#foo) and GET parameters (?foo=bar) are just part of the path (for now)
    
    public function new( s:String ) :Void {
        parse(s);
    }
    
    private function parse( s:String ) :Void {
        var r:EReg = ~/([a-z]+):\/\/([a-zA-Z0-9-\.]*)(:([0-9]+))?(.*)/;
        if( r.match( s ) ) {
            protocol = r.matched(1);
            host = r.matched(2);
            port = Std.parseInt(r.matched(4));
            if( port==0 ) {
                switch(protocol) {
                    case "http": port=80;
                    case "https": port=443;
                    case "ftp": port=21;
                    default: port=0;
                }
            }
            path = r.matched(5);
			if( protocol=="file" ) {
				if( path!="" ) path=host+"/"+path; 
				else path=host;
				host=""; 
			}
        } else {
            protocol="file";
            host=null;
            port=0;
            path=s;
        }
        if( path.charAt(path.length-1)!="/" ) {
            var p = path.split("/");
            filename = p.pop();
            path = p.join("/");
			if( p.length>0 ) path+="/";
        } else {
			filename="";
		}
    }
    
    public function getRelativeURL( rel:String ) :URL {
        var url = new URL( this.pathString()+rel );
        return url;
    }
    
    public function fetch( onData:String->Void, ?onError:String->Void ) {
        try {
        
        #if neko
            if( protocol=="file" ) {
                var data = neko.io.File.getContent( if( host!=null ) host+path+filename else path+filename );
                onData( data );
                return;
            }
        #end
        
            var request = new haxe.Http(toString());
            request.onError = onError;
            request.onData = onData;
            request.request(false);
            
        } catch( e:Dynamic ) {
            var msg = "Could not load document '"+this+"': "+e;
            if( onError!=null ) onError(msg);
            else throw(msg);
        }
    }
    
    public function pathString() :String {
        var h = "";
        if( host!=null ) {
            h = host;
        }
        if( port!=0 ) {
            h = h+":"+port;
        }
        return( protocol+"://"+h+path );
    }

	public function toString() :String {
		return( pathString()+filename );
    }
}
