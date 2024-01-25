package source;

/**
 * Rename this file to API.hx to fix compile!
 */
class APIsetup
{
    public static inline var ngapi:String = "";
    public static inline var ngenc:String = "";
    static function main()
    {
        #if sys
            // if API.hx doesn't exist.. make it using this file!
            if (sys.FileSystem.exists("./source/API.hx"))
            {
                trace("API.hx already exists!");
                return;
            }
            trace("Making API.hx at /source/API.hx");
            var filecontent:String = sys.io.File.getContent("./source/APIsetup.hx");
            filecontent = StringTools.replace(filecontent, "package source", "package");
            filecontent = StringTools.replace(filecontent, "APIsetup", "API");
            sys.io.File.saveContent("./source/API.hx", filecontent);
        #end
    }
}