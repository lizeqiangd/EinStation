package com.lizeqiangd.nuigesture.event
{
	import flash.events.Event;
	
	public class GestureEvent extends Event
	{
		/*
		 * NuiGesture的手势动作事件
		 */
		public static var GESTURE:String = "gesture";
		public var data:*;
		
		public function GestureEvent(type:String, DispatchData:* = null, bubbles:Boolean = false)
		{
			super(type, bubbles);
			data = DispatchData;
		}
	}
}