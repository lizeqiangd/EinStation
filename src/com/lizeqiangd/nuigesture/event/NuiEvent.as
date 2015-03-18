package com.lizeqiangd.nuigesture.event
{
	import flash.events.Event;
	public class NuiEvent extends Event
	{
			/*
		 * Nui的事件..我有用过吗?
		 */
		public static var ACTION_CAPTURED:String = "action_captured";
		public var data:*;
		public function NuiEvent(type:String,DispatchData:* = null,bubbles:Boolean = false)
		{
			super(type,bubbles);
			data = DispatchData;
		}
	}
}