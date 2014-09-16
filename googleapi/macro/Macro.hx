package googleapi.macro;
import haxe.macro.Expr;

/**
 * ...
 * @author Kevin
 */
class Macro
{
	macro public static function getID():Expr
	{
		var id = Sys.getEnv("GooglePlayID");
		return macro $v{id};
	}
}