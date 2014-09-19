package googleapi.macro;
import haxe.macro.Expr;
import sys.io.File;

/**
 * ...
 * @author Kevin
 */
class Macro
{
	macro public static function getID():Expr
	{
		#if android
		var id = Sys.getEnv("GooglePlayID");
		#end
		
		#if ios
		var i = File.read("../id.txt");
		var id = i.readAll().toString();
		i.close();
		#end
		
		return macro $v{id};
	}
	
}