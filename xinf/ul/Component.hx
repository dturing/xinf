/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ul;

import Xinferno;

class Component {
    public var __parentSizeListener:Dynamic;

    public var prefSize(getPrefSize,null):{x:Float,y:Float};
    var _prefSize:{x:Float,y:Float};

    public function new() :Void {
        _prefSize = { x:.0, y:.0 };
        super();
    }

    public function getPrefSize() :{x:Float,y:Float} {
        return( _prefSize );
    }
    
    public function setPrefSize( n:{x:Float,y:Float} ) :{x:Float,y:Float} {
        var s = n; //addPadding(n);
        if( _prefSize==null || s.x!=_prefSize.x || s.y!=_prefSize.y ) {
            _prefSize = s;
            postEvent( new ComponentSizeEvent( ComponentSizeEvent.PREF_SIZE_CHANGED, _prefSize.x, _prefSize.y, this ) );
        }
        return( _prefSize );
    }

    public function getElement() :Element {
        throw("unimplemented getElement");
    }

}
