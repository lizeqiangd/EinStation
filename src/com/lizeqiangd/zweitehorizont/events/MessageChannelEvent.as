package com.lizeqiangd.zweitehorizont.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author lizeqiangd
	 */
	public class MessageChannelEvent extends Event
	{
		
		public static const MESSAGE_UPDATE:String = "MESSAGE_UPDATE"
		public static const USER_UPDATE:String = "USER_UPDATE"
		public static const CHANNEL_CLOSE:String = "CHANNEL_CLOSE"
		public static const GET_CHANNELS:String = "GET_CHANNELS"
		
		public static const CLOSE_CHANNEL:String = "CLOSE_CHANNEL"
		public static const JOIN_CHANNEL:String = "JOIN_CHANNEL"
		public static const LEAVE_CHANNEL:String = "LEAVE_CHANNEL"
		public static const CREATE_CHANNEL:String = "CREATE_CHANNEL"
		
		public static const SEND_MESSAGE:String = "SEND_MESSAGE"
		
		public var data:*
		
		public function MessageChannelEvent(type:String, _data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			data = _data
			super(type, bubbles, cancelable);
		
		}
		
		public override function clone():Event
		{
			return new MessageChannelEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("MessageChannelEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}