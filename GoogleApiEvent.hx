package ;

#if openfl
import openfl.events.Event;
#end

/**
 * ...
 * @author Kevin
 */
class GoogleApiEvent extends Event
{
	public static inline var INIT:String = "init";
	public static inline var TOKEN:String = "token";
	public static inline var ACCOUNT_NAME:String = "accountName";
	
	public var contents:String;


	public function new (type:String, contents:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
		this.contents = contents;
	}
	
}