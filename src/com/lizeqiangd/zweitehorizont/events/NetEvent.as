package com.lizeqiangd.zweitehorizont.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class NetEvent extends Event 
	{
		public static const CONNECTED:String = "connected";
		public static const REJECTED:String = "rejected";
		public static const CLOSED:String = "closed";
		public static const FAILED:String = "failed"
		public static const STATUS:String = "status"
		public var data:*
		public function NetEvent(type:String,_data:*=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			data=_data
		} 
		
		public override function clone():Event 
		{ 
			return new NetEvent(type, bubbles, false);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NetEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}