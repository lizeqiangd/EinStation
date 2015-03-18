package com.lizeqiangd.lovelive.applications.MainController
{
	
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.events.VideoEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general;
	import com.lizeqiangd.zweisystem.interfaces.checkbox.cb_content;
	import com.lizeqiangd.zweisystem.manager.HostManager;
	import com.lizeqiangd.zweisystem.net.AMFPHP;
	import com.lizeqiangd.zweisystem.system.applications.background.BackgroundManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.applications.title.TitleManager;
	import com.lizeqiangd.zweisystem.system.config.ESAmfphp;
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * @author lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website $(DefaultSite)
	 */
	
	public class MainController extends BaseWindows implements iApplication
	{
		public var tx_count:TextField
		public var btn_niconiconi:btn_general
		public var cb_loop:cb_content
		
		private var uploadCountsTimer:Timer
		
		private var count:uint = 0
		private var nowPlayCounts:int = 0
		private var videoObject:Object
		
		public function MainController()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationName = "MainController";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			tx_count.text = "loading......."
			PositionUtility.addPosObject(this, "BC")
			btn_niconiconi.enable = false
			cb_loop.enable = false
			addEventListener(ApplicationEvent.OPENED, init)
			var i:int = int(SystemConfig.getLocalConfig("NicoCount")) ? int(SystemConfig.getLocalConfig("NicoCount")) : 0
			SystemConfig.setLocalConfig("NicoCount", ++i)
		}
		
		public function init(e:ApplicationEvent)
		{
			uploadCountsTimer = new Timer(3000, 1)
			setTimeout(onPlayStart, 3500)
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener()
		{
			ZweiteHorizont.UserManagers.addUserEventListener("user_event", onUserUpdate)
			uploadCountsTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onUploadTimerHandle)
			btn_niconiconi.addEventListener(UnitEvent.CLICK, onNicoNicoNiClick)
			cb_loop.addEventListener(UnitEvent.CLICK, onLoopClick)
			//BackgroundManager.addEventListener(VideoEvent.PLAY_COMPLETE, onPlayComplete)
			//BackgroundManager.addEventListener(VideoEvent.PLAY_START, onPlayStart)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onUserUpdate(e:*):void
		{
			TitleManager.MainTitle = "现在有" + ZweiteHorizont.UserManagers.UserList.length + "个用户在线~" // ip:"+ HostManager.USER_IP
		}
		
		private function onUploadTimerHandle(e:TimerEvent):void
		{
			sendToService()
		}
		
		///洗脑按钮.
		private function onLoopClick(e:UnitEvent):void
		{
			if (cb_loop.selected)
			{
				btn_niconiconi.enable = false
				BackgroundManager.addEventListener(VideoEvent.PLAY_COMPLETE, onLoopHandle)
				startNicoNicoNi()
			}
			else
			{
				btn_niconiconi.enable = true
				BackgroundManager.removeEventListener(VideoEvent.PLAY_COMPLETE, onLoopHandle)
			}
		}
		
		///洗脑反馈
		private function onLoopHandle(e:VideoEvent)
		{
			nowPlayCounts++
			count++
			startNicoNicoNi()
		}
		
		///点击 播放一次 按钮.
		private function onNicoNicoNiClick(e:UnitEvent)
		{
			nowPlayCounts++
			count++
			startNicoNicoNi()
		}
		
		///开始播放一次洗脑.
		private function startNicoNicoNi()
		{
			var i:int = int(SystemConfig.getLocalConfig("NicoCount")) ? int(SystemConfig.getLocalConfig("NicoCount")) : 0
			SystemConfig.setLocalConfig("NicoCount", ++i)
			
			uploadCountsTimer.reset()
			uploadCountsTimer.start()
			if (nowPlayCounts > 40)
			{
				sendToService()
			}
			tx_count.text = String(count);
			BackgroundManager.remote(videoObject.url, videoObject.description)
		}
		
		///将次数发送到服务器上.
		private function sendToService():void
		{
			
			var arr:Array = []
			arr.count = nowPlayCounts
			arr.ip = HostManager.USER_IP
			AMFPHP.callResult(ESAmfphp.LoveLive_increaseCount, onSendComplete2, arr)
			nowPlayCounts = 0
		}
		
		///AMFPHP发送结果成功. 同时动态更新数字.
		private function onSendComplete(e:Object):void
		{
			showNumber(int(e))
			count = int(e)
		}
		
		///更新数字.
		private function onSendComplete2(e:Object):void
		{
			trace(e)
			
			SystemConfig.getSystemConfig2("NicoCounts", onSendComplete)
		}
		
		///字体动画
		private function showNumber(i:int)
		{
			var newint:int = i
			TextAnimation.NumberCount(tx_count, newint, true)
		}
		
		///初始化各种数据 pl
		private function onPlayStart():void
		{
			tx_count.text = "0"
			BackgroundManager.removeEventListener(VideoEvent.PLAY_START, onPlayStart)
			SystemConfig.getSystemConfig2("NicoNicoNi", onLoadUrlComplete)
			SystemConfig.getSystemConfig2("NicoCounts", onSendComplete)
			SystemConfig.getSystemConfig("NicoCopyRight", onCopyRight)
			nowPlayCounts++
			
			var i:int = int(SystemConfig.getLocalConfig("NicoCount")) ? int(SystemConfig.getLocalConfig("NicoCount")) : 0
			SystemConfig.setLocalConfig("NicoCount", ++i)
			sendToService()
		}
		
		private function onCopyRight(e:Object):void
		{
			BackgroundManager.infomation(String(e.value), true)
		}
		
		///读取地址结束 ok
		private function onLoadUrlComplete(e:Object):void
		{
			videoObject = e
			btn_niconiconi.enable = true
			cb_loop.enable = true
			if (int(SystemConfig.getLocalConfig("NicoCount") > 2))
			{
				Message.SystemMessage("欢迎继续洗脑,已经niconiconi" + int(SystemConfig.getLocalConfig("NicoCount")) + "次了")
			}
		}
		
		private function removeApplicationListener()
		{
			//BackgroundManager.removeEventListener(VideoEvent.PLAY_COMPLETE, onPlayComplete)
			BackgroundManager.removeEventListener(VideoEvent.PLAY_START, onPlayStart)
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeApplicationListener();
		}
		
		public function dispose()
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object)
		{
			switch (e)
			{
				case "": 
					break;
				default: 
					break;
			}
		}
	
	}

}