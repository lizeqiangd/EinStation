package com.lizeqiangd.zweitehorizont.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class ObjectEvent extends Event 
	{
		public static const OBJECT_POOL_UPDATE:String = "object_pool_update"
		public static const OBJECT_LOCATION_UPDATE:String = "object_loaction_update"
		public static const OBJECT_UPDATE:String = "object_update"
		public static const OBJECT_REMOVED:String = "object_removed"
		
		public var data:*
		
		public function ObjectEvent(type:String, _data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			data = _data		
		}
		
		
		public override function clone():Event 
		{ 
			return new ObjectEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ObjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}