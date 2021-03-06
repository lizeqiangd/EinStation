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
		public static const DATA:String = 'data';
		
		public var payload:Object
		
		public function ZweiteHorizontServerEvent(type:String, _data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			payload = _data
			super(type, bubbles, cancelable);
		}
			
		public function get data():Object {
			return payload
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