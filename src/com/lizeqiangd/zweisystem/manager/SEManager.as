package com.lizeqiangd.zweisystem.manager
{
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import com.junkbyte.console.Cc;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.events.LoaderEvent;
	/**
	 * 音效管理器.目前无用.
	 */
	public class SEManager
	{
		private static var _st:SoundChannel;
		private static var _sound:Sound;
		private static var queue:LoaderMax;
		private static var inited:Boolean = false
		
		public static function init()
		{
			inited = false
			Cc.log("SEManager init:loading SE");
			queue = new LoaderMax({name: "mainQueue", onProgress: progressHandler, onComplete: completeHandler, onError: errorHandler});
			queue.append(new MP3Loader("SoundEfferts/Error1.mp3", {name: "Error1", autoPlay: false, estimatedBytes: 50000}));
			queue.append(new MP3Loader("SoundEfferts/Error2.mp3", {name: "Error2", autoPlay: false, estimatedBytes: 50000}));
			queue.append(new MP3Loader("SoundEfferts/CountDown.mp3", {name: "CountDown", autoPlay: false, estimatedBytes: 50000}));
			queue.append(new MP3Loader("SoundEfferts/DownloadContentOpen.mp3", {name: "DownloadContentOpen", autoPlay: false, estimatedBytes: 50000}));
			queue.append(new MP3Loader("SoundEfferts/Ping.mp3", {name: "Ping.", autoPlay: false, estimatedBytes: 50000}));
			queue.append(new MP3Loader("SoundEfferts/Select.mp3", {name: "Select", autoPlay: false, estimatedBytes: 50000}));
			queue.append(new MP3Loader("SoundEfferts/Warning.mp3", {name: "Warning", autoPlay: false, estimatedBytes: 50000}));
			queue.load();
		}
		
		private static function progressHandler(event:LoaderEvent):void
		{
			//trace("SEprogress: " + event.target.progress);
		}
		
		private static function completeHandler(event:LoaderEvent):void
		{
			Cc.log("SEManager loading SE complete!");
			inited = true
		}
		
		private static function errorHandler(event:LoaderEvent):void
		{
			Cc.error("SEManager: loading sounds fault!" + event.target + ": " + event.text);
			trace("error occured with " + event.target + ": " + event.text);
		}
		
		public static function play(url:String)
		{
			if (!inited)
			{
				Cc.log("SEManager:" + url + " play failed.SEManager is not inited")
				return;
			}
			_sound = new Sound(new URLRequest("SoundEfferts/" + url + ".mp3"));
			_sound.play();
		}
	}
}