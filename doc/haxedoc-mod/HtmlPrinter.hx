import haxe.rtti.Type;

class HtmlPrinter {

	static function loadTemplate() {
		var hdata = try {
			// load in current local/web directory
			neko.io.File.getContent(neko.Web.getCwd()+"template.xml");
		} catch( e : Dynamic ) try {
			// load in haxe subdirectory (TODO : make it work on linux/osx)
			var p = ~/[\/\\]/g.split(neko.Sys.executablePath());
			p.pop();
			neko.io.File.getContent(p.join("/")+"/std/tools/template.xml");
		} catch( e : Dynamic )
			default_template;
		return Xml.parse(hdata);
	}

	static var default_template = "<html><body><data/></body></html>";
	static var template = loadTemplate();
	static var index_html = neko.io.File.getContent(neko.Web.getCwd()+"package-index.xml");

	public var baseUrl : String;
	var indexUrl : String;
	var fileExtension : String;
	var curpackage : String;
	var filters : List<String>;
	var typeParams : TypeParams;

	public function new( baseUrl, fileExtension, indexUrl ) {
		this.baseUrl = baseUrl;
		this.fileExtension = fileExtension;
		this.indexUrl = indexUrl;
		filters = new List();
		typeParams = new Array();
	}

	public function output(str) {
		neko.Lib.print(str);
	}

	public function addFilter(f) {
		filters.add(f);
	}

	public function print(str, ?params : Dynamic ) {
		if( params != null )
			for( f in Reflect.fields(params) )
				str = StringTools.replace(str, "$"+f, Std.string(Reflect.field(params, f)));
		output(str);
	}

	public function process(t) {
		processHtml(t,template);
	}

	public function filtered( path : Path, isPackage : Bool ) {
		if( isPackage && path == "Remoting" )
			return true;
		if( StringTools.endsWith(path,"__") )
			return true;
		if( filters.isEmpty() )
			return false;
		for( x in filters )
			if( StringTools.startsWith(path,x) )
				return false;
		return true;
	}

	function makeUrl( url, text, css, ?fragment ) {
		var f = if( fragment==null ) "" else "#"+fragment;
		return "<a href=\"" + baseUrl + url + fileExtension + f + "\" class=\""+css+"\">"+text+"</a>";
	}

	function prefix( arr : Array<String>, path : String ) {
		var arr = arr.copy();
		for( i in 0...arr.length )
			arr[i] = path + "." + arr[i];
		return arr;
	}

	function makePathUrl( path : Path, css:String, ?f:String ) {
		var f_brackets = if( f==null || f.length==0 ) "" else "."+f+"()";
		var p = path.split(".");
		var name = p.pop();
		var local = (p.join(".") == curpackage);
		var pkg_css = " "+p.join("_")+" "+p[0];
		for( x in typeParams )
			if( x == path )
				return name;
		p.push(name);
		if( local )
			return makeUrl(p.join("/"),name+f_brackets,css+pkg_css,f);
		return makeUrl(p.join("/"),fmtpath(path)+f_brackets,css+pkg_css,f);
	}

	function fmtpath(path : String) {
		if( path.substr(0,7) == "flash9." )
			return "flash."+path.substr(7);
		return '<wbr/><span class="path">'+path.split(".").pop()+'</span>';
		/*	
		var pack = path.split(".");
		if( pack.length > 1 && pack[pack.length-2].charAt(0) == "_" ) {
			pack.splice(-2,1);
			path = pack.join(".");
		}
		return path;
		*/
	}

	public function processHtml(t,html : Xml) {
		var ht = html.nodeType;
		if( ht == Xml.Element ) {
			if( html.nodeName == "data" ) {
				processPage(t);
				return;
			}
			if( html.nodeName == "head" ) {
				processHead(t);
				return;
			}
			if( !html.iterator().hasNext() ) {
				print(html.toString());
				return;
			}
			print("<");
			print(html.nodeName);
			for( k in html.attributes() )
				print(" "+k+"=\""+html.get(k)+"\"");
			print(">");
			for( x in html )
				processHtml(t,x);
			print("</"+html.nodeName+">");
		} else if( ht == Xml.Document )
			for( x in html )
				processHtml(t,x);
		else
			print(html.toString());
	}
	
	public function processHead(t) {
		print('<head>');
			print('<title>');
					print(
					switch(t) {
						case TClassdecl(c): c.path+" | ";
						case TEnumdecl(e): e.path+" | ";
						case TTypedecl(t): t.path+" | ";
						case TPackage(_,_,_): "";
					} + "Xinf API Reference");
			print('</title>');
			print('<style type="text/css">');
				print('@import url('+baseUrl+'../xinfapi.css);');
			print('</style>');
		print('</head>');
	}
	
	public function processPage(t) {
		switch(t) {
		case TPackage(p,full,list):
			processPackage(p,list);
		default:
			print( index_html );
			var head = '<a href="#" onclick="javascript:history.back(-1); return false" class="index">Back</a> | '+makeUrl(indexUrl,"Index","index");
			print(head);
			var inf = TypeApi.typeInfos(t);
			typeParams = prefix(inf.params,inf.path);
			var p = inf.path.split(".");
			p.pop();
			curpackage = p.join(".");
			switch(t) {
			case TClassdecl(c): processClass(c);
			case TEnumdecl(e): processEnum(e);
			case TTypedecl(t): processTypedef(t);
			case TPackage(_,_,_): throw "ASSERT";
			}
			print(head);
		}
	}

	function processPackage(name,list : Array<TypeTree> ) {
		print('<ul class="entry">');
		for( e in list ) {
			switch e {
			case TPackage(name,full,list):
				if( filtered(full,true) )
					continue;
				var isPrivate = name.charAt(0) == "_";
				if( !isPrivate )
					print('<li><a href="#" class="package" onclick="return toggle(\'$id\')">$name</a><div id="$id" class="package_content">', { id : full.split(".").join("_"), name : name });
				var old = curpackage;
				curpackage = full;
				processPackage(name,list);
				curpackage = old;
				if( !isPrivate )
					print("</div></li>");
			default:
				var i = TypeApi.typeInfos(e);
				if( i.isPrivate || i.path == "@Main" || filtered(i.path,false) )
					continue;
				print("<li>"+makePathUrl(i.path,"entry")+"</li>");
			}
		}
		print("</ul>");
	}

	function processInfos(t : TypeInfos) {
		if( t.module != null )
			print('<div class="importmod">import $module</div>',{ module : t.module });
		if( !t.platforms.isEmpty() ) {
			print('<div class="platforms">Available in ');
			display(t.platforms,output,", ");
			print('</div>');
		}
		if( t.doc != null ) {
			print('<div class="classdoc">');
			processDoc(t.doc);
			print('</div>');
		}
	}

	function processTraits( t ) {
		var traits = new Hash();
		switch(t) {
			case TAnonymous( a ):
				for( trait in a ) {
					traits.set(trait.name,trait.t);
				}
			default:
		}
		return traits;
	}
	
	function processClass(c : Class) {
		print('<div class="classname">');
		if( c.isExtern )
			keyword("extern");
		if( c.isPrivate )
			keyword("private");
		if( c.isInterface )
			keyword("interface");
		else
			keyword("class");
		print(curpackage+".");
		print(fmtpath(c.path)); 
		if( c.params.length != 0 ) {
			print("&lt;");
			print(c.params.join(", "));
			print("&gt;");
		}
		print('</div>');
		if( c.superClass != null ) {
			print('<div class="extends">extends ');
			processPath(c.superClass.path,c.superClass.params);
			print('</div>');
		}
		for( i in c.interfaces ) {
			print('<div class="implements">implements ');
			processPath(i.path,i.params);
			print('</div>');
		}
		if( c.dynamic != null ) {
			var d = new List();
			d.add(c.dynamic);
			print('<div class="implements">implements ');
			processPath("Dynamic",d);
			print('</div>');
		}
		processInfos(c);
		
		var traits;
		for( t in c.statics ) {
			if( t.name=="TRAITS" ) traits = processTraits( t.type );
		}
		
		print('<dl>');
		for( f in c.fields )
			processClassField(c.platforms,f,false,traits);
		for( f in c.statics )
			processClassField(c.platforms,f,true,traits);
		print('</dl>');
	}

	function processClassField(platforms : Platforms,f : ClassField,stat,?traits:Hash<Type>) {
		if( !f.isPublic )
			return;
		var oldParams = typeParams;
		if( f.params != null )
			typeParams = typeParams.concat(prefix(f.params,f.name));
		print('<dt>');
		if( stat ) keyword("static");
		var isMethod = false;
		switch( f.type ) {
		case TFunction(args,ret):
			if( f.get == RNormal && (f.set == RNormal || f.set == RF9Dynamic) ) {
				isMethod = true;
				if( f.set == RF9Dynamic )
					keyword("f9dynamic");
				keyword("function");
				print('<a name="'+f.name+'"></a><span class="member">'+f.name+'</span>');
				if( f.params != null )
					print("&lt;"+f.params.join(", ")+"&gt;");
				print("( ");
				var me = this;
				display(args,function(a) {
					if( a.opt )
						me.print("?");
					if( a.name != null && a.name != "" ) {
						me.print(a.name);
						me.print(":");
					}
					me.processType(a.t);
				},", ");
				print(" ) :");
				processType(ret);
			}
		default:
		}
		if( !isMethod ) {
			keyword("var");
			print('<span class="member">'+f.name+'</span>');
			
		//	if( f.get != RNormal || f.set != RNormal )
		//		print("("+rightsStr(f.get)+","+rightsStr(f.set)+")");
			print(" :");
			processType(f.type);
		}
		if( traits!=null ) {
			var trait = traits.get(f.name);
			if( trait==null ) {
				var name_translated = ~/([A-Z])/g.replace(f.name,"_$1").toLowerCase();
				trait = traits.get(name_translated);
			}
			if( trait!=null ) {
				print(' <span class="trait">[');
				processType(trait);
				print(']</span>');
			}
		}
		if( f.set == RNo ) {
			print(" (read-only)");
		} else if( f.get == RNo ) {
			print(" (write-only)");
		}
		if( f.platforms.length != platforms.length ) {
			print('<div class="platforms">Available in ');
			display(f.platforms,output,", ");
			print('</div>');
		}
		print('</dt>');
		print('<dd>');
		processDoc(f.doc);
		print('</dd>');
		if( f.params != null )
			typeParams = oldParams;
	}

	function processEnum(e : Enum) {
		print('<div class="classname">');
		if( e.isExtern )
			keyword("extern");
		if( e.isPrivate )
			keyword("private");
		keyword("enum");
		print(curpackage+".");
		print(fmtpath(e.path));
		if( e.params.length != 0 ) {
			print("&lt;");
			print(e.params.join(", "));
			print("&gt;");
		}
		print('</div>');
		processInfos(e);
		print('<dl>');
		for( c in e.constructors ) {
			print('<dt>');
			print(c.name);
			if( c.args != null ) {
				print("( ");
				var me = this;
				display(c.args,function(a) {
					if( a.opt )
						me.print("?");
					me.print(a.name);
					me.print(":");
					me.processType(a.t);
				},", ");
				print(" )");
			}
			print("</dt>");
			print("<dd>");
			processDoc(c.doc);
			print("</dd>");
		}
		print('</dl>');
	}

	function processTypedef(t : Typedef) {
		print('<div class="classname">');
		if( t.isPrivate )
			keyword("private");
		keyword("typedef");
		print(curpackage+".");
		print(fmtpath(t.path));
		if( t.params.length != 0 ) {
			print("&lt;");
			print(t.params.join(", "));
			print("&gt;");
		}
		print('</div>');
		processInfos(t);
		if( t.platforms.length == 0 ) {
			processTypedefType(t.type,t.platforms,t.platforms);
			return;
		}
		var platforms = new List();
		for( p in t.platforms )
			platforms.add(p);
		for( p in t.types.keys() ) {
			var td = t.types.get(p);
			var support = new List();
			for( p2 in platforms )
				if( TypeApi.typeEq(td,t.types.get(p2)) ) {
					platforms.remove(p2);
					support.add(p2);
				}
			if( support.length == 0 )
				continue;
			processTypedefType(td,t.platforms,support);
		}
	}

	function processTypedefType(t,all,platforms) {
		switch( t ) {
		case TAnonymous(fields):
			print('<dl>');
			for( f in fields ) {
				processClassField(all,{
					name : f.name,
					type : f.t,
					isPublic : true,
					doc : null,
					get : RNormal,
					set : RNormal,
					params : null,
					platforms : platforms,
				},false);
			}
			print('</dl>');
		default:
			if( all.length != platforms.length ) {
				print('<div class="platforms">Defined in ');
				display(platforms,output,", ");
				print('</div>');
			}
			print('<div class="typedef">= ');
			processType(t);
			print('</div>');
		}
	}

	function processPath( path : Path, ?params : List<Type> ) {
		print(makePathUrl(path,"type"));
		if( params != null && !params.isEmpty() ) {
			print("&lt;");
			for( t in params )
				processType(t);
			print("&gt;");
		}
	}

	function processType( t : Type ) {
		switch( t ) {
		case TUnknown:
			print("Unknown");
		case TEnum(path,params):
			processPath(path,params);
		case TClass(path,params):
			processPath(path,params);
		case TTypedef(path,params):
			processPath(path,params);
		case TFunction(args,ret):
			if( args.isEmpty() ) {
				processPath("Void");
				print(" -> ");
			}
			for( a in args ) {
				if( a.opt )
					print("?");
				if( a.name != null && a.name != "" )
					print(a.name+" : ");
				processTypeFun(a.t,true);
				print(" -> ");
			}
			processTypeFun(ret,false);
		case TAnonymous(fields):
			print("{ ");
			var me = this;
			display(fields,function(f) {
				me.print(f.name+" : ");
				me.processType(f.t);
			},", ");
			print("}");
		case TDynamic(t):
			if( t == null )
				processPath("Dynamic");
			else {
				var l = new List();
				l.add(t);
				processPath("Dynamic",l);
			}
		}
	}

	function processTypeFun( t : Type, isArg ) {
		var parent =  switch( t ) { case TFunction(_,_): true; case TEnum(n,_): isArg && n == "Void"; default : false; };
		if( parent )
			print("(");
		processType(t);
		if( parent )
			print(")");
	}

	function rightsStr(r) {
		return switch(r) {
		case RNormal: "default";
		case RNo: "null";
		case RMethod(m): m;
		case RDynamic: "dynamic";
		case RF9Dynamic: "f9dynamic";
		}
	}

	function keyword(w) {
		print('<span class="kwd">'+w+' </span>');
	}

	function processDoc(doc : String) {
		if( doc == null )
			return;

		// unixify line endings
		doc = doc.split("\r\n").join("\n").split("\r").join("\n");

		// trim stars
		doc = ~/^([ \t]*)\*+/gm.replace(doc, "$1");
		doc = ~/\**[ \t]*$/gm.replace(doc, "");

		// "see also" references (to w3c specs)
		var ref_begin='<span class="extref">See also: ';
		var ref_end='</span>';
		doc = ~/\$SVG ([^ #]+)(#?[^ ]*) (.*)\$/g.replace( doc, 
			ref_begin+'<a class="svg" href="file:///mnt/data/doc/SVGMobile12/$1.html$2">$3</a>'+ref_end );
		doc = ~/\$CSS ([^ #]+)(#?[^ ]*) (.*)\$/g.replace( doc, 
			ref_begin+'<a class="css" href="file:///mnt/data/doc/CSS/$1.html$2">$3</a>'+ref_end );
			
		// wiki and class references
		doc = ~/\$wiki ([^ ]+)(.*)\$/g.replace( doc, 
			ref_begin+'<a class="wiki" href="http://xinf.org/trac/wiki/$1">$2</a>' );

		var link = ~/\$([A-Za-z0-9\.]+)(::(.*))?\$/g;
		while( link.match(doc) ) {
			doc = link.matchedLeft();
			
			var f = link.matched(3);
			doc += makePathUrl(link.matched(1),"doc",f);
			doc += link.matchedRight();
		}
		

		// process [] blocks
		var rx = ~/\[/;
		var tmp = new StringBuf();
		var codes = new List();
		while (rx.match(doc)) {
			tmp.add( rx.matchedLeft() );

			var code = rx.matchedRight();
			var brackets = 1;
			var i = 0;
			while( i < code.length && brackets > 0 ) {
				switch( code.charCodeAt(i++) ) {
				case 91: brackets++;
				case 93: brackets--;
				}
			}
			doc = code.substr(i);
			code = code.substr(0, i-1);
			code = ~/&/g.replace(code, "&amp;");
			code = ~/</g.replace(code, "&lt;");
			code = ~/>/g.replace(code, "&gt;");
			var tag = "##__code__"+codes.length+"##";
			if( code.indexOf('\n') != -1 ) {
				tmp.add("<pre>");
				tmp.add(tag);
				tmp.add("</pre>");
				codes.add(code.split("\t").join("    "));
			} else {
				tmp.add("<code>");
				tmp.add(tag);
				tmp.add("</code>");
				codes.add(code);
			}
		}
		tmp.add(doc);

		// separate into paragraphs
		var parts = ~/\n[ \t]*\n/g.split(tmp.toString());
		if( parts.length == 1 )
			doc = parts[0];
		else
			doc = Lambda.map(parts,function(x) { return "<p>"+StringTools.trim(x)+"</p>"; }).join("\n");

		// put back code parts
		var i = 0;
		for( c in codes )
			doc = doc.split("##__code__"+(i++)+"##").join(c);
		print(doc);
	}

	function display<T>( l : List<T>, f : T -> Void, sep : String ) {
		var first = true;
		for( x in l ) {
			if( first )
				first = false;
			else
				print(sep);
			f(x);
		}
	}

}
