package com.zweisystem.applications.PasscardSystem
{
	import com.zweisystem.abstracts.windows.AssestWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	import flash.events.ErrorEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * 利用可自定义的二维码卡片，来登陆继续。轻松简单。
	 * 
	 */
	public class PasscardSystem extends AssestWindows implements iApplication
	{ // implements iApplication
		
		public function PasscardSystem()
		{
			this.setApplicationName = "";
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationVersion = "0.0.2";
			this.setApplicationTitle = "EinStation Passcard System - beta -";
			this.setAutoRemoveBackground = true;
			
			this.setAssestUrl = "assest/PasscardSystem.swf";
			tx_info.text = "程序启动中，请稍后。";
			
			mc_frameLarge.visible = false;
			addUiListener();
		}
		
		public function smallMode()
		{
			btn_close.x = 300;
			tx_info.y = 240;
			tx_info.width = 320;
			tx_title.width = 320;
			mc_bg.width = 320;
			mc_bg.height = 240;
			mc_title.width = 320;
			mc_frameLarge.visible = false;
			mc_mainframe.visible = true;
		}
		
		public function lagreMode()
		{
			this.setApplicationTitle = "EinStation Passcard System - beta -(LargeMode)";
			mc_frameLarge.scaleX = mc_frameLarge.scaleY = 1;
			mc_frameLarge.visible = true;
			mc_mainframe.visible = false;
			tx_info.y = 480;
			tx_info.width = 640;
			tx_title.width = 640;
			mc_bg.width = 640;
			mc_bg.height = 480;
			mc_title.width = 640;
			btn_close.x = 620;
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
		
		public function init(e:ApplicationEvent)
		{
			lagreMode();
			tx_info.text = "等待PasscardSystem加载完成";
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))			
		}
		
		private function addUiListener()
		{
			addEventListener(ApplicationEvent.INIT, init);
			addEventListener(ApplicationEvent.CLOSE, applicationClose);
			this.addEventListener(Event.COMPLETE, onDisplayAssest);
			this.addEventListener(UnitEvent.CHANGE, onInfoChange);
		/*
		   this.flarManager.addEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
		   this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
		   this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
		 this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);*/
		}
		
		private function removeUiListener()
		{
			/*
			   this.flarManager.removeEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
			   this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			   this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			 this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);*/
			
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(Event.COMPLETE, onDisplayAssest);
			this.removeEventListener(UnitEvent.CHANGE, onInfoChange);
			this.removeEventListener(ApplicationEvent.CLOSE, applicationClose);
		}
		
		private function applicationClose(e:ApplicationEvent)
		{
			tx_info.text = "程序关闭中";
			//this.removeChild(Sprite(this.flarManager.flarSource));
			//flarManager.deactivate();
			(content as EventDispatcher).removeEventListener(UnitEvent.CHANGE, onInfoChange);
			removeUiListener();
		}
		
		private function onDisplayAssest(e:Event)
		{
			this.addChildAt(this.content, 1);
			this.setChildIndex(this.mc_bg, 0);
			this.content.addEventListener(UnitEvent.CHANGE, onInfoChange);
			//(content as  EventDispatcher).addEventListener
			tx_info.text = "程序加载完成。";
			this.content.init(1)
			this.content.y=20
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function onInfoChange(e:UnitEvent)
		{
			trace("onInfoChange:", e.data)
			tx_info.text = e.data;
		}
		
		public function dispose()
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		private function getColorByPatternId(patternId:int):Number
		{
			switch (patternId)
			{
				case 0: 
					return 0x47b200;
				case 1: 
					return 0x990000;
				case 2: 
					return 0xFF7F00;
				case 3: 
					return 0xF2F2B2;
				case 4: 
					return 0x47b200;
				case 5: 
					return 0x990000;
				case 6: 
					return 0xFF7F00;
				case 7: 
					return 0xF2F2B2;
				default: 
					return 0x666666;
			}
		}
	}

}