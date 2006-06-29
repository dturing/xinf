package xinf.ony;

#if neko
	signature Primitive xinf.inity.Group
#else js
    import js.Dom;
	signature Primitive js.HtmlDom
#else flash
	// not MovieClip, because it can also be a TextField-
	// FIXME - xinfony API only uses stuff that both implement? sure??
	signature Primitive flash.MovieClip
#end

