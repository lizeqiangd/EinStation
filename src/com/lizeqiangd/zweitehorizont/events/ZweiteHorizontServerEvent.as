package com.lizeqiangd.zweitehorizont.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class ZweiteHorizontServerEvent extends Event
	{
		public static const INITED:String = 'inited';
		
		//public static const INITED:String = 'inited';
		public function ZweiteHorizontServerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new ZweiteHorizontServerEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("ZweiteHorizontServerEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}