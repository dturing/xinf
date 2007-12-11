package xinf.ony;

import Xinf;
import xinf.event.EventKind;
import xinf.event.Event;

class Root {
    private static var mRoot:Document;
	
	public static var width:Float;
	public static var height:Float;
	
    public static var children(get_children,null) :Iterator<Element>;
	static function get_children() :Iterator<Element> {
		return cast mRoot.children;
	}

	private static function getRoot() :Document {
		if( mRoot==null ) {
			var r = new xinf.ony.erno.Root();
			mRoot = new Document();
			r.attach( mRoot );
			
			Root.width = Root.height = 100;
			xinf.erno.Runtime.runtime.addEventListener( GeometryEvent.STAGE_SCALED, function(e) {
				Root.width = e.x; Root.height = e.y;
			});
		}
		return mRoot;
	}
	
    public static function attach( o:Element, ?after:Element ) :Void {
		getRoot().attach( o, after );
	}
	
    public static function detach( o:Element ) :Void {
		getRoot().detach( o );
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

    public static function main() {
        xinf.erno.Runtime.runtime.run();
    }

}