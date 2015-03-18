package com.lizeqiangd.zweisystem.events
{
	import flash.events.Event;
	/**
	 * Animation事件, 用于表示动画的流程.
	 * @author:Lizeqiangd
	 */
	public class VideoEvent extends Event
	{
		///开始播放视频.
		public static var PLAY_START:String = "play_start";
		
		///播放视频完成
		public static var PLAY_COMPLETE:String = "play_complete";
		
		
		public var data:*;
		
		public function VideoEvent(type:String, DispatchData:* = null, bubbles:Boolean = false)
		{
			super(type, bubbles);
			data = DispatchData;
		}
	}
}