/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;
import xinf.xml.Node;
import xinf.ul.layout.Layout;

class Container extends Component {
    var relayoutNeeded:Bool;
    public var layout:Layout;

    var group:Group;
	var componentChildren:Array<Component>;

    public function new( ?g:Group, ?traits:Dynamic ) :Void {
		group = g;
		if( group==null ) group = new Group();
        super( group, traits );
		
		_skin.attachBackground( group );
		_skin.attachForeground( group );
		
        relayoutNeeded = true;
		componentChildren = new Array<Component>();
    }
    
    override public function appendChild( newChild:Node ) :Node {
		super.appendChild( newChild );

		if( Std.is( newChild, Component ) ) {
			var child:Component = cast(newChild);
			componentChildren.push( child );
			child.__parentSizeListener = child.addEventListener( ComponentSizeEvent.PREF_SIZE_CHANGED, onComponentResize );

			_skin.detachForeground( group );
			group.appendChild( child.getElement() );
			_skin.attachForeground( group );
			
			relayoutNeeded = true;
			relayout();
		}
		
		return newChild;
    }

	override public function removeChild( oldChild:Node ) :Node {
		super.removeChild( oldChild );

		if( Std.is( oldChild, Component ) ) {
			var child:Component = cast(oldChild);
			componentChildren.remove( child );
			child.removeEventListener( ComponentSizeEvent.PREF_SIZE_CHANGED, child.__parentSizeListener );
			group.removeChild( child.getElement() );
		}
		
		return oldChild;
    }

    function onComponentResize( e:ComponentSizeEvent ) :Void {
        if( layout==null ) {
            e.component.size = e;
        } else {
            relayoutNeeded=true;
			relayout();
        }
    }

    public function relayout() :Void {
        if( layout!=null && relayoutNeeded ) {
            var oldSize = size;
//            trace("relayout "+this);
            layout.layoutContainer( this );
            relayoutNeeded = false;
        }
    }
    
    override public function getElement() :Element {
        return group;
    }
    
    public function getComponent( index:Int ) :Component {
        return componentChildren[index];
    }
    public function getComponents() :Iterator<Component> {
        return componentChildren.iterator();
    }

}
