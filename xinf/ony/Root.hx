/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

import Xinf;
import xinf.event.EventKind;
import xinf.event.Event;
import xinf.xml.Node;

class Root {
    private static var mRoot:Svg;
	
	public static var width:Float = 0.;
	public static var height:Float = 0.;
	
	public static function getDocument() :Document {
		return getRootSvg().ownerDocument;
	}
	
	public static function getRootSvg() :Svg {
		if( mRoot==null ) {
			mRoot = new Svg();
			untyped mRoot.ownerDocument = new Document(); // FIXME
			untyped mRoot.ownerDocument.set_base("");
			
			#if xinfony_null
			#else true
				var r = new xinf.ony.erno.Root();
				untyped r.construct();
				r.appendChild( mRoot );
				
				// FIXME: this is crap.
				Root.width = Root.height = 100;
				xinf.erno.Runtime.runtime.addEventListener( GeometryEvent.STAGE_SCALED, function(e) {
					Root.width = e.x; Root.height = e.y;
					mRoot.width = e.x; mRoot.height = e.y;
				});
			#end
		}
		return mRoot;
	}
	
    public static function appendChild( o:Node ) :Void {
		getRootSvg().appendChild( o );
	}
	
    public static function removeChild( o:Node ) :Void {
		getRootSvg().removeChild( o );
	}

    public static function addEventListener<T>( type :EventKind<T>, h :T->Void ) :T->Void {
        return xinf.erno.Runtime.runtime.addEventListener(type,h);
    }
    
    public static function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool {
        return xinf.erno.Runtime.runtime.removeEventListener(type,h);
    }
	
    public static function postEvent<T>( e : Event<T>, ?pos:haxe.PosInfos ) :Void {
	    return xinf.erno.Runtime.runtime.postEvent(e,pos);
    }

	public static function setBackgroundColor( r:Float, g:Float, b:Float, ?a:Float ) :Void {
		xinf.erno.Runtime.runtime.setBackgroundColor(r,g,b,a);
	}

    public static function main() {
        xinf.erno.Runtime.runtime.run();
    }

}