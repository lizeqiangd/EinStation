package com.lizeqiangd.zweisystem.events
{
	import flash.events.Event;
	
	/**
	 * 音乐类事件,控制音乐播放状态用的事件.
	 * open ioerror complete progress
	 * sampleData
	 * @author lizeqiangd
	 */
	public class MusicEvent extends Event
	{
		///当新音乐文件输入进去的时候调度
		public static var MUSIC_OPEN:String = "music_open";
		
		///当音乐播放结束的时候调度的事件.
		public static var MUSIC_COMPLETE:String = "music_complete";
		
		///当音乐加载失败的时候调度
		public static var MUSIC_ERROR:String = "music_error";
		
		///也就是音乐加载成功,不代表播放完成.
		public static var MUSIC_LOADED:String = "music_loaded";
		
		///音乐暂停(停止),其实是一回事
		public static var MUSIC_STOP:String = "music_stop";
		
		///音乐正在缓存
		public static var MUSIC_BUFFING:String = "music_buffing";
		
		///音乐播放.
		public static var MUSIC_PLAY:String = "music_play";
		
		///当音量发生变化
		public static var VOLUME_CHANGED:String = "volume_changed";
		
		///当用户开启静音模式
		public static var MUTED:String = "muted";
		
		///当进度位置切换.
		public static var POSITION_CHANGED:String = "position_changed";
		
		///当有数据流入的时候调度.
		public static var PROGRESS:String = "progress"
		
		///当用户释放进度条
		//public static var DRAG_START:String = "";
		
		///当用户开始拖动进度条
		//public static var DRAG_STOP:String = "";
		
		///下一首
		//public static var NEXT:String = "";
		
		///上一首
		//public static var PREV:String = "";
		public var data:*;
		
		public function MusicEvent(type:String, DispatchData:* = null, bubbles:Boolean = false)
		{
			super(type, bubbles);
			data = DispatchData;
		}
		
		public override function clone():Event
		{
			return new MusicEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("MusicEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	
	}

}