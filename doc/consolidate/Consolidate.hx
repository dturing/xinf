
class Package {
	public var name:String;
	public var packages:Array<Package>;
	public var classes:Array<Xml>;
	
	public function new( name:String ) {
		this.name=name;
		packages = new Array<Package>();
		classes = new Array<Xml>();
	}
	
	public function write( out:neko.io.Output, indent:String ) {
		if( name=="" ) out.write(indent+"<root>\n");
		else out.write(indent+'<package path="'+name+'" name="'+name.split(".").pop()+'">\n');
		
			for( p in packages ) {
				p.write( out, indent+"  " );
			}
			for( c in classes ) {
				out.write( indent + c.toString() + "\n" );
			}
		
		if( name=="" ) out.write(indent+"</root>\n");
		else out.write(indent+'</package>\n');
	}
}

/**
	consolidates a haxedoc .xml into <package>s
*/
class Consolidate {
	var root:Package;
	var index:Hash<Package>;
	
	public function new() {
		root = new Package("");
		index = new Hash<Package>();
	}
	
	public function consolidate( filename:String ) {
		var xml = Xml.parse( neko.io.File.getContent(filename) );
		for( e in xml.firstChild().elements() ) {
			add(e);
		}
	}
	
	public function add( e:Xml ) {
		var path = e.get("path");
		if( path==null ) throw("invalid xml, no @path on "+e);
		var pkgPath = path.split("."); pkgPath.pop();
		var pkg = registerPackage( pkgPath.join(".") );
		pkg.classes.push(e);
//		trace("path "+path+", pkg "+pkg );
	}
	
	public function registerPackage( path:String ) :Package {
		if( path=="" ) return root;
		
		var pkg = index.get(path);
		if( pkg!=null ) return(pkg);
		
		pkg = new Package(path);
		index.set(path,pkg);
		
		var p = path.split(".");
		if( p.length>1 ) {
			p.pop();
			var parent = registerPackage( p.join(".") );
			parent.packages.push(pkg);
		} else {
			root.packages.push(pkg);
		}
		
		return pkg;
	}
	
	public function write( filename:String ) {
		var out = neko.io.File.write(filename,false);
		root.write(out,"");
		out.close();
	}
	
	public static function main() {
		var arg = neko.Sys.args()[0];
		if( arg == null ) throw("Need .xml argument");
		var c = new Consolidate();
		c.consolidate( arg );
		c.write( "out.xml" );
	}
}
