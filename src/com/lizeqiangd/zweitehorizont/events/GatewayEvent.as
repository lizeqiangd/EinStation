package com.lizeqiangd.zweitehorizont.events 
{
	import flash.events.Event;
	
	/**
	 * 用于记录gateway本体的事件
	 * @author Lizeqiangd
	 */
	public class GatewayEvent extends Event 
	{
		public static const CONNECTED:String = 'connected';
		public static const CLOSED:String = 'closed';
		public static const CONNECTING:String = 'connecting';
		public static const ERROR:String = 'error';
		
		
		
		//public static const CONNECTED:String = 'connected';
		//public static const CONNECTED:String = 'connected';
		public function GatewayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new GatewayEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GatewayEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}