package com.lizeqiangd.PlayerPlugin.baseframework.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class PlayerPluginEvent extends Event
	{
		public static const INIT:String = 'player_plugin_init';
		public static const INITED:String = 'player_plugin_inited';
		public static const START:String = 'player_plugin_start';
		public static const CLOSE:String = 'player_plugin_close';
		
		public function PlayerPluginEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		
		}
		
		public override function clone():Event
		{
			return new PlayerPluginEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("PlayerPluginEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}