package org.xinf.ony.impl;

class Primitives {

    // static functions to generate various runtime-specific primitives
    public static function createRoot() :IPrimitive {
        #if neko
            return new org.xinf.ony.impl.x.XRoot();
        #else flash
            throw("primitive not implemented");
            return null;
        #else js
            throw("primitive not implemented");
            return null;
        #end
    }

    public static function createPane() :IPrimitive {
        #if neko
            return new org.xinf.ony.impl.x.XPane();
        #else flash
            throw("primitive not implemented");
            return null;
//            return new org.xinf.ony.impl.flash.FlashPane();
        #else js
            throw("primitive not implemented");
            return null;
//            return new org.xinf.ony.impl.js.JSPane();
        #end
    }

    public static function createImage() :IPrimitive {
        #if neko
            return new org.xinf.ony.impl.x.XImage();
        #else flash
            throw("primitive not implemented");
            return null;
//            return new org.xinf.ony.impl.flash.FlashImage();
        #else js
            throw("primitive not implemented");
            return null;
//            return new org.xinf.ony.impl.js.JSImage();
        #end
    }

    public static function createText() :ITextPrimitive {
        #if neko
            return new org.xinf.ony.impl.x.XText();
        #else flash
            throw("primitive not implemented");
            return null;
//            return new org.xinf.ony.impl.flash.FlashText();
        #else js
            throw("primitive not implemented");
            return null;
//            return new org.xinf.ony.impl.js.JSText();
        #end
    }
}
