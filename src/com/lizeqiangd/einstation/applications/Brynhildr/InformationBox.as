package com.lizeqiangd.einstation.applications.Brynhildr
{
	
	import com.lizeqiangd.zweisystem.abstract.windows.DragWindows;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.components.URLNavigator;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general_s;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * @author lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website $(DefaultSite)
	 */
	
	public class InformationBox extends DragWindows implements iApplication
	{
		public var tx_information:TextField
		public var btn_weibo:btn_general_s
		public var btn_camera:btn_general
		public var btn_cameraroll:btn_general
		
		public function InformationBox()
		{
			this.setDisplayLayer = "applicationLayer";
			//this.setApplicationTitle = "EinStation Application - InformationBox -";
			this.setApplicationName = "BrynhildrInformationBox";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			tx_information.text = "....获取服务器公告中....."
			tx_information.mouseEnabled = false
		}
		
		public function init(e:ApplicationEvent)
		{
			PositionUtility.center(this)
			SystemConfig.getSystemConfig("BrynhildrInfomation", onInformationLoad)
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function onInformationLoad(e:Object):void
		{
			tx_information.text = e.value
			TextAnimation.Typing(tx_information)
		}
		
		private function addApplicationListener()
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			btn_camera.addEventListener(UnitEvent.CLICK, onCameraClick);
			btn_cameraroll.addEventListener(UnitEvent.CLICK, onCamerarollClick);
			btn_weibo.addEventListener(UnitEvent.CLICK, onWeiboClick);
		}
		
		private function onWeiboClick(e:Event):void
		{
			URLNavigator.open("http://weibo.com/lizeqiangd", false, "_blank", true)
		}
		
		private function onCamerarollClick(e:Event):void
		{
			ApplicationManager.ApplicationByPath("com.lizeqiangd.einstation.applications.Brynhildr.MainView").applicationMessage({type: "LoadImage"})
		}
		
		private function onCameraClick(e:Event):void
		{
			ApplicationManager.ApplicationByPath("com.lizeqiangd.einstation.applications.Brynhildr.MainView").applicationMessage({type: "OpenCamera"})
		}
		
		private function removeApplicationListener()
		{
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
			switch (e.type)
			{
				case "CloseApp": 
					this.CloseApplication()
					break;
				default: 
					break;
			}
		}
	}

}