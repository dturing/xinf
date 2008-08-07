/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.inity;

import xinf.geom.Types;
import xinf.geom.Rectangle;
import xinf.geom.Matrix;
import opengl.GL;
import openvg.Path;

enum GLVGContent {
	CRectangle(l:Float,t:Float,r:Float,b:Float);
	CPath(p:Path);
}

class GLObject {
	
	// TODO: maybe we can avoid caching some of this?
	public var parent:GLObject; // needed only for (unimplemented) getGlobalTransform()
	public var children:Array<GLObject>;
	
	private var boundingBox:Rectangle; // untransformed
	public var transform:Matrix; // FIXME: make private, access only from GLRenderer
	private var transformedBBox:Rectangle;
	
	public var id:Int;
	public var inner:Int;
	
	public var contents:List<GLVGContent>; // for precise hittests
	
	public function new( id:Int ) :Void {
		this.id = id;
		this.transform = new Matrix().setIdentity();
		this.boundingBox = null;
		this.inner = GL.genLists(1);
		contents = new List<GLVGContent>();
	}

	public function destroy() :Void {
		GL.deleteLists(id,1);
		GL.deleteLists(inner,1);
	}

	public function setTransform( transform:Matrix ) :Void {
		this.transform = transform;
		transformedBBox = null;
		redoTransform();
	}

	public function redoTransform() :Void {
		GL.newList( id, GL.COMPILE );
//		GL.pushName(id);
		GL.pushMatrix();
		GL.pushAttrib(GL.TRANSFORM_BIT); // for the clipping planes FIXME: still needed?
		
			if( transform!=null )
				GL.multMatrixf( GLRenderer.matrixForGL(transform) );
				
			GL.callList( inner );
			
		GL.popAttrib();
		GL.popMatrix();
//		GL.popName();
		GL.endList();

		#if gldebug
			var e:Int = GL.getError();
			if( e > 0 ) {
				throw( "OpenGL Error: "+opengl.GLU.errorString(e) );
			}
		#end

		update();
	}

	public function localToGlobal( p:{ x:Float, y:Float } ) :{ x:Float, y:Float } {
		var q = p;
		if( parent!=null ) q = parent.localToGlobal(q);
		var q = transform.apply(q);
		return q;
	}

	public function addChild( child:GLObject ) :Void {
		if( children==null ) children = new Array<GLObject>();
		children.push(child);
		child.parent = this;
		child.update();
	}
	
	public function clear() :Void {
		children = null;
		transformedBBox = boundingBox = null;
		contents = new List<GLVGContent>();
	}
	
	public function mergeBBox( bbox:TRectangle ) :Void {
		if( boundingBox==null ) boundingBox = new Rectangle(bbox);
		else boundingBox.merge(bbox);
		transformedBBox = null;
	}
	
	public function start() :Void {
		GL.newList( inner, GL.COMPILE );
	}
	
	public function end() :Void {
		GL.endList();
		#if gldebug
			var e:Int = GL.getError();
			if( e > 0 ) {
				throw( "OpenGL Error: "+opengl.GLU.errorString(e) );
			}
		#end
		
		redoTransform();
	}	
	
	public function update() :Void {
	
		if( parent != null && boundingBox!=null ) {
			if( transformedBBox==null ) {
				if( transform!=null ) {
					transformedBBox = new Rectangle(transform.transformBBox(boundingBox));
				} else {
					transformedBBox = new Rectangle(boundingBox);
				}
			}
			parent.mergeBBox( transformedBBox );
			parent.update();
		}
	}
	
	public function hit( p:TPoint, found:List<{ o:GLObject, p:TPoint }> ) :Bool {
		if( boundingBox==null ) {
			return false;
		}
		var transformedPoint:TPoint = if( transform==null ) p else transform.applyInverse(p);
		if( boundingBox.contains(transformedPoint) ) {
			// we're hit, lets check our children
			var childHit = false;
			if( children!=null ) {
				for( child in children ) {
					if( child.hit( transformedPoint, found ) ) childHit=true;
				}
			}
			if( !childHit && (children==null || children.length==0 ) )
				found.push({ o:this, p:transformedPoint });
			return true;
		} 
		return false;
	}
	
	public function addRectangle( l:Float, t:Float, r:Float, b:Float ) {
		contents.add( CRectangle(l,t,r,b) );
		mergeBBox( {l:l,t:t,r:r,b:b} );
	}
	
	public function addPath( path:Path ) {
		contents.add( CPath(path) );
		mergeBBox( path.getPathBounds() );
	}
	
	public function hitPrecise( tp:TPoint ) :Bool {
		for( c in contents ) {
			switch( c ) {
				case CRectangle(l,t,r,b):
					if( tp.x>=l && tp.x<=r && tp.y>=t && tp.y<=b ) return true;
				case CPath(path):
					if( path.pathHit( tp.x, tp.y ) ) return true;
			}
		}
		return false;
	}
	
	public function toString() :String {
		return("#"+id);
	}
	
}

