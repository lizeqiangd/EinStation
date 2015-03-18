package com.lizeqiangd.zweisystem.events
{
	import flash.events.Event;
	
	/**
	 * Active事件类
	 * @author Lizeqiangd
	 */
	public class ActiveEvent extends Event
	{
		public static const OUT:String = "active_in";
		public static const IN:String = "active_out";
		
		public function ActiveEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new ActiveEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("ActiveEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}