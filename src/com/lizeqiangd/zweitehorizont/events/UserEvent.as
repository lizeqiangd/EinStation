package com.lizeqiangd.zweitehorizont.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class UserEvent extends Event
	{
		public static const USERLIST_UPDATE:String = "userlist_update"
		public static const USER_UPDATE:String = "user_update"
		public static const USER_ONLINE:String = "user_online"
		public static const USER_OFFLINE:String = "user_offline"
		
		public static const USER_EVENT:String="user_event"
		
		public var data:*
		
		public function UserEvent(type:String, _data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			data = _data		
		}
		
		public override function clone():Event
		{
			return new UserEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("UserEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}