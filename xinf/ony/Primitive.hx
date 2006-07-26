package xinf.ony;

#if neko
	typedef Primitive = xinf.inity.Group
#else js
    import js.Dom;
	typedef Primitive = js.HtmlDom
#else flash
	// not MovieClip, because it can also be a TextField-
	// FIXME - xinfony API only uses stuff that both implement? sure??
	typedef Primitive = flash.MovieClip
#end

