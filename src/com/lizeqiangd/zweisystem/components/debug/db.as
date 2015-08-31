package com.lizeqiangd.zweisystem.components.debug
{
	CONFIG::CONSOLE
	{
		import com.junkbyte.console.Cc;
	}
	import flash.display.Stage;
	
	/**
	 * debug用简易方法,其次用于封装console当不支持的时候用的.
	 * @author Lizeqiangd
	 */
	public class db
	{
		//public static var Cc:Object = {};
		
		public static function log(... args):void
		{
			trace(args);
			CONFIG::CONSOLE
			{
				Cc.log(args);
			}
		
		}
		
		public static function showConsole():void
		{
			CONFIG::CONSOLE
			{
				Cc.visible = true
			}
		}
		
		public static function hideConsole():void
		{
			CONFIG::CONSOLE
			{
				Cc.visible = false
			}
		}
		
		public static function initConsole(_stage:Stage):void
		{
			CONFIG::CONSOLE
			{
				Cc.start(_stage);
				Cc.config.tracing = true;
				Cc.remoting = true;
				Cc.width = 600;
				Cc.height = 500;
				Cc.config.commandLineAllowed = true;
				Cc.debug("*******************************************");
				Cc.debug("Console is inited.");
			}
		}
	}
}