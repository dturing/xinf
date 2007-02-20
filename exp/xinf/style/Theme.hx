package xinf.style;

class Theme {
    public static var theme:Theme;
    
    public function new() :Void {
    }
    
    public function info() :{ name:String, description:String, copyright:String, url:String } {
        return { name:"[no Theme]", 
            description:"No Theme is loaded.",
            copyright:null, url:null };
    }
    
    public function addToDefault() :Void {
    }
}
