package com.lizeqiangd.amfphp.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class AMFPHPEvent extends Event 
	{
		
		
		
		public var result:Object;
		public function AMFPHPEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AMFPHPEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AMFPHPEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}