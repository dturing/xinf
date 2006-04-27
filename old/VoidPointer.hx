package org.xinf.util;

class VoidPointer {
    public static var NULL = neko.Lib.load("cptr","cptr_void_null",0)();
    public static var _cast = neko.Lib.load("cptr","cptr_void_cast",1);
}
