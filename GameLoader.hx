import pixi.loaders.Loader;

class GameLoader {
    static inline var basePath = "";
    var loader:Loader;
    
	public function new(then) {
        loader = new Loader();
        loader.add(basePath + "fonts/font-export.fnt");
        
        //Process info on load
        loader.use(function(res, next) {
            next();
        });
        
        loader.load(then);
    }
    
    public function update() {
        trace(loader.progress + "% loaded");
    }
}