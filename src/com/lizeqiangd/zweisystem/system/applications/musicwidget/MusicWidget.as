package com.lizeqiangd.zweisystem.system.applications.musicwidget
{
	import com.greensock.TweenLite;
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation
	import com.lizeqiangd.zweisystem.events.MusicEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.MusicManager;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * 2014.5.15 制作.
	 */
	
	public class MusicWidget extends BaseWindows implements iApplication
	{
		public var btn_play:MovieClip
		public var btn_hide:MovieClip
		public var btn_stop:MovieClip
		public var tx_title:TextField
		
		private var timer_titleanime:Timer
		
		private var status_hide:int = 0
		private var status_text:int = 0
		
		public function MusicWidget()
		{
			this.setDisplayLayer = "topLayer";
			this.setApplicationName = "MusicWidget";
			this.setApplicationVersion = "1.0"
			this.setFocusAble = false
			btn_stop.alpha = 0
			btn_stop.visible = false
			tx_title.text = "初始化功能中..."
			//this.visible = false
			timer_titleanime = new Timer(1000)
			addEventListener(ApplicationEvent.OPENED, init)
		}
		
		///初始化标题栏
		public function init(e:ApplicationEvent)
		{
			//AnimationManager.fade_in(this)
			this.x = 0
			hideWidget(2)
			removeEventListener(ApplicationEvent.OPENED, init)
			
			addApplicationListener()
			title = "等待播放列表数据"
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			onResize()
		}
		
		private function addApplicationListener()
		{
			MusicManager.addEventListener(MusicEvent.MUSIC_OPEN, onMusicEventHandle)
			MusicManager.addEventListener(MusicEvent.MUSIC_LOADED, onMusicEventHandle)
			MusicManager.addEventListener(MusicEvent.MUSIC_STOP, onMusicEventHandle)
			MusicManager.addEventListener(MusicEvent.MUSIC_PLAY, onMusicEventHandle)
			MusicManager.addEventListener(MusicEvent.MUSIC_COMPLETE, onMusicEventHandle)
			StageProxy.addResizeFunction(onResize)
			timer_titleanime.addEventListener(TimerEvent.TIMER, onTitleTimerHandle)
			btn_hide.addEventListener(MouseEvent.CLICK, onMouseClick);
			btn_play.addEventListener(MouseEvent.CLICK, onMouseClick);
			btn_stop.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener()
		{
			MusicManager.removeEventListener(MusicEvent.MUSIC_OPEN, onMusicEventHandle)
			MusicManager.removeEventListener(MusicEvent.MUSIC_LOADED, onMusicEventHandle)
			MusicManager.removeEventListener(MusicEvent.MUSIC_STOP, onMusicEventHandle)
			MusicManager.removeEventListener(MusicEvent.MUSIC_PLAY, onMusicEventHandle)
			MusicManager.removeEventListener(MusicEvent.MUSIC_COMPLETE, onMusicEventHandle)
			StageProxy.removeResizeFunction(onResize)
			timer_titleanime.removeEventListener(TimerEvent.TIMER, onTitleTimerHandle)
			btn_hide.removeEventListener(MouseEvent.CLICK, onMouseClick);
			btn_play.removeEventListener(MouseEvent.CLICK, onMouseClick);
			btn_stop.removeEventListener(MouseEvent.CLICK, onMouseClick);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			switch (e.target)
			{
				case btn_hide: 
					status_hide++
					status_hide > 3 ? status_hide = 1 : null
					hideWidget(status_hide)
					break
				case btn_play: 
					if (MusicManager.getNowPlayMusic.musicUrl)
					{
						AnimationManager.fade(btn_stop, 1, 0.2)
						AnimationManager.fade(btn_play, 0, 0.2)
						MusicManager.play()
					}
					break
				case btn_stop: 
					if (MusicManager.getNowPlayMusic.musicUrl)
					{
						AnimationManager.fade(btn_stop, 0, 0.2)
						AnimationManager.fade(btn_play, 1, 0.2)
						MusicManager.pause()
					}
					break
			}
		}
		
		private function onMusicEventHandle(e:MusicEvent):void
		{
			switch (e.type)
			{
				case MusicEvent.MUSIC_OPEN: 
					title = "加载新曲目中"
					timer_titleanime.stop()
					status_text = 1
					break;
				case MusicEvent.MUSIC_LOADED: 
					timer_titleanime.start()
					title = "加载完成,播放中"
					AnimationManager.fade(btn_stop, 1, 0.2)
					AnimationManager.fade(btn_play, 0, 0.2)
					break;
				case MusicEvent.MUSIC_STOP: 
					timer_titleanime.stop()
					title = "暂停"
					status_text = 0
					break;
				case MusicEvent.MUSIC_PLAY: 
					timer_titleanime.start()
					title = "播放"
					status_text = 0
					break;
				case MusicEvent.MUSIC_COMPLETE: 
					timer_titleanime.stop()
					title = "播放结束"
					break;
			}
		}
		
		private function onTitleTimerHandle(e:TimerEvent):void
		{
			switch (status_text)
			{
				case 1: 
					title = "歌曲名称"
					break;
				case 2: 
					title = MusicManager.getNowPlayMusic.name
					break;
				case 8: 
					title = "专辑名"
					break;
				case 9: 
					title = MusicManager.getNowPlayMusic.album
					break;
				case 14: 
					title = "歌手"
					break;
				case 15: 
					title = MusicManager.getNowPlayMusic.artist
					break;
			}
			status_text++
			status_text > 17 ? status_text = 1 : null
		}
		
		private function hideWidget(status:int)
		{
			//完全隐藏
			if (status == 0)
			{
				removeApplicationListener();
				AnimationManager.fade_out(this)
			}
			//完全正常
			if (status == 1)
			{
				status_hide = status
				TweenLite.to(this, 0.8, {x: 0, overwrite: 3})
				return
			}
			//只有2个按钮
			if (status == 2)
			{
				status_hide = status
				TweenLite.to(this, 0.8, {x: -230 * BaseWindows.getNowScale, overwrite: 3})
				return
			}
			//只有1个按钮
			if (status == 3)
			{
				status_hide = status
				TweenLite.to(this, 0.5, {x: -260 * BaseWindows.getNowScale, overwrite: 3})
				return
			}
			//恢复显示
			if (status == 4)
			{
				addApplicationListener();
				onResize()
				AnimationManager.fade_in(this)
			}
		}
		
		public function set title(e:String)
		{
			this.tx_title.text = e
			TextAnimation.Changing(tx_title, e, 1, true)
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			dispose()
		}
		
		public function applicationMessage(e:Object)
		{
			switch (e.type)
			{
				case "hide": 
					hideWidget(e.value)
					break;
				case "title": 
					title = e.value + ""
					break;
			}
		}
		
		public function dispose()
		{
			removeApplicationListener();
		}
		
		private function onResize():void
		{
			hideWidget(status_hide)
			this.y = StageProxy.stageHeight - this.height+0.5
		}
	
	}

}