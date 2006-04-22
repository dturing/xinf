package org.xinf.display;

import org.xinf.geom.Point;
import org.xinf.render.IRenderer;
import org.xinf.event.Event;

class DisplayObjectContainer extends InteractiveObject {

    private var children : Array<DisplayObject>;

    public property numChildren(countChildren,null):Int;
    private function countChildren() : Int {
        return children.length;
    }
    
    private function new() {
        super();
        children = new Array<DisplayObject>();
    }
    
    public function addChild( child:DisplayObject ) : DisplayObject {
        children.push(child);
        child.root = this.root;
        child.parent = this;
        child.stage = this.stage;
        return child;
    }
    
    public function addChildAt( child:DisplayObject, index:Int ) : DisplayObject {
        children.insert(index,child);
        return child;
    }
    
    public function contains( child:DisplayObject ) : Bool {
        for( c in children ) {
            if( c == child ) return true;
        }
        return false;
    }
    
    public function getChildAt( index:Int ) : DisplayObject {
        return children[index];
    }
    
    public function getChildByName( name:String ) : DisplayObject {
        for( c in children ) {
            if( c.name == name ) return c;
        }
        return null;
    }
    
    public function getChildIndex( child:DisplayObject ) : Int {
        var i=0;
        for( c in children ) {
            if( c.name == name ) return i;
            i++;
        }
        return -1;
    }
    
    public function removeChild( child:DisplayObject ) : DisplayObject {
        children.remove( child );
        return child;
    }
    
    public function removeChildAt( index:Int ) : DisplayObject {
        var child = children[index];
        children.splice( index, 1 );
        return child;
    }
    
    public function setChildIndex( child:DisplayObject, index:Int ) : Void {
        var child = removeChild( child );
        addChildAt( child, index );
    }
    
    private function _render( r:IRenderer ) {
        super._render(r);
        
        r.pushMatrix();
        r.matrix( transform.matrix );
    
        for( i in children.indexes() ) {
            r.pushName(i);
            children[i]._render(r);
            r.popName();
        }
        
        r.popMatrix();
    }

    private function asContainer() : DisplayObjectContainer {
        return this;
    }
    
    public function getObjectsUnderPoint( pt:Point ) : Array<DisplayObject> {
        if( stage == null || stage.renderer == null )
            throw("No Stage or Stage has no Renderer.");
            
        var r:IRenderer = stage.renderer;
        
        r.startPick( pt.x, pt.y );
        this._render( r );
        var hits:Array<Array<Int>> = r.endPick();
        
        var a:Array<DisplayObject> = new Array<DisplayObject>();
        for( hit in hits ) {
            var object:DisplayObject = this;
            var container:DisplayObjectContainer;
            for( id in hit ) {
                container = object.asContainer();
                if( container == null ) throw("no container to find #"+id);
                object = container.getChildAt(id);
                if( object == null ) throw("hit child not found");
            }
            a.push(object);
        }
        
        return a;
    }
    
    public function dispatchEvent( e:Event ) : Bool {
        if( !super.dispatchEvent(e) ) return false;
        if( !e.propagate ) return true;
        
        for( child in children ) {
            if( !child.dispatchEvent(e) ) return false;
        }
        return true;
    }
}

