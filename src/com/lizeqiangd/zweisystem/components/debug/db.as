package com.lizeqiangd.zweisystem.components.debug
{
	import com.junkbyte.console.Cc;
	import flash.display.Stage;
	
	/**
	 * debug用简易方法,其次用于封装console当不支持的时候用的.
	 * @author Lizeqiangd
	 */
	public class db
	{
		public static function log(... args):void
		{
			trace(args);
			try
			{
				Cc.log(args);
			}
			catch (e:*)
			{
			}
		}
		
		public static function showConsole():void
		{
			Cc.visible = true
		}
		
		public static function hideConsole():void
		{
			Cc.visible = false
		}
		
		public static function initConsole(_stage:Stage):void
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