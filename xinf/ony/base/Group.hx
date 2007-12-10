package xinf.ony.base;
import xinf.ony.base.Implementation;

class Group extends ElementImpl {

    public var children(get_children,null) :Iterator<ElementImpl>;
    private var mChildren(default,null):Array<ElementImpl>;    
    function get_children() :Iterator<ElementImpl> {
        return mChildren.iterator();
    }


    /** Container constructor<br/>
        A simple Container will not display anything by itself,
        but can be used as a container object to group other Objects.
    **/
    public function new( ?traits:Dynamic ) {
        super( traits );
        mChildren = new Array<ElementImpl>();
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( document==null ) throw("Document not set.");
        for( node in xml.elements() ) {
            document.unmarshal( node, this );
        }
    }

	override public function onLoad() :Void {
		for( child in mChildren ) {
			child.onLoad();
		}
		super.onLoad();
	}

    /** attach (add) a child Object<br/>
        Add 'child' to this object's list of mChildren, inserts
        the child into the display hierarchy, similar to addElementImpl in Flash 
        or appendElementImpl in JavaScript/DOM.
        The new child will be added at the end of the list, so it will appear
        in front of all current mChildren.
    **/
    public function attach( child:ElementImpl, ?after:ElementImpl ) :Void {
        if( after!=null ) {
            // find 'after'
            var pos=-1;
            var i=0;
            for( child in mChildren ) {
                if( child==after ) pos=i;
                i++;
            }
            if( pos==-1 )
                mChildren.push( child );
            else 
                mChildren.insert( pos+1, child );
        } else {
            mChildren.push( child );
        }
        
        child.attachedTo( this );
   
        redraw();
    }

    /** detach (remove) a child Object<br/>
        Removes 'child' from this object's list of mChildren. **/
    public function detach( child:ElementImpl ) :Void {
        mChildren.remove( child );
        child.detachedFrom( this );
    }

	public function getElementByName( name:String ) :ElementImpl {
		for( child in children ) {
			if( child.name == name ) return child;
		}
		throw( "no child with name '"+name+"'" );
	}
	
	public function getTypedElementByName<T>( name:String, cl:Class<T> ) :T {
		var r = getElementByName( name );
		if( !Std.is( r, cl ) ) throw("ElementImpl '"+name+"' is not of class "+Type.getClassName(cl)+" (but instead "+Type.getClassName(Type.getClass(r))+")" );
        return cast(r);
	}
	
}
