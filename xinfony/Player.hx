package xinfony;

class Player {
    public static function root() {
        #if flash
            return flash.Lib._root;
        #else js
            return js.Lib.window.document.getElementById("xinfony");
        #end
    }
/*    
    private static function Trace( v:Dynamic, inf:haxe.PosInfo ) {
        // once we can remote from player7 to js, log to extra div next to the embedded SWF.
        // FIXME: contribute to haXe, or wait a bit for nicolas
    }
*/    
    private static var __initialized = function() {
        #if flash
            flash.Stage.scaleMode="noscale";
//            haxe.Log.trace = Trace;
        #end
        return true;
    }();
}
