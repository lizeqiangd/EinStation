package com.lizeqiangd.zweisystem.applications.SystemOperation.WelcomeBoard
{
	import com.lizeqiangd.zweisystem.abstract.active.ActiveManager;
	import com.lizeqiangd.zweisystem.components.URLNavigator;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.manager.HostManager;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import flash.events.MouseEvent;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class WelcomeBoard extends TitleWindows implements iApplication
	{
		private var image_ad:ImageDisplay;
		private var adUrl:String;
		private var AM:ActiveManager;
		
		public var _configActive:Boolean;
		
		public function WelcomeBoard()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "欢迎来访EinStation";
			this.setApplicationName = "WelcomeBoard";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			
			AM = new ActiveManager(this);
			AM.registerPointByActive(active_InformationActive, "point1");
			AM.registerPointByActive(active_UpdateActive, "point2");
		}
		
		public function init(e:ApplicationEvent)
		{
			
			initAD();
			
			AM.movein("InformationActive", "point1", "left");
			AM.movein("UpdateActive", "point2", "fade");
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function initAD()
		{
			tx_ad.text = "感谢一直以来的支持";
			image_ad = new ImageDisplay;
			image_ad.config(200, 160, ImageDisplay.proportionalInside);
			image_ad.load(HostManager.ADVERTISEMENT.image.url);
			addChildAt(image_ad, 3);
			image_ad.y = 160;
			image_ad.x = 320;
			tx_ad2.text = HostManager.ADVERTISEMENT.description;
			//image_ad.mask = masker;
		}
		
		private function onClick(e:MouseEvent)
		{
			URLNavigator.open(HostManager.ADVERTISEMENT.url, false, "_blank", true);
		}
		
		public function onConfigActive(e:MouseEvent = null)
		{
			if (!_configActive)
			{
				_configActive = true;
				applicationMessage("configMode");
			}
			else
			{
				_configActive = false;
				applicationMessage("informationsMode");
			}
		}
		
		private function addApplicationListener()
		{btn_icp.addEventListener(MouseEvent.CLICK,onIcpClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			btn_config.addEventListener(MouseEvent.CLICK, onConfigActive);
			mc_ad.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onIcpClick(e:MouseEvent):void 
		{
			URLNavigator.open("http://www.miitbeian.gov.cn/",true)
		}
		
		private function removeApplicationListener()
		{btn_icp.removeEventListener(MouseEvent.CLICK,onIcpClick)
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			
			btn_config.removeEventListener(MouseEvent.CLICK, onConfigActive);
			mc_ad.removeEventListener(MouseEvent.CLICK, onClick);
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
				case "informationsMode": 
					AM.movein("InformationActive", "point1", "right");
					AM.moveout("ConfigActive", "left");
					break;
				case "configMode": 
					AM.moveout("InformationActive", "right");
					AM.movein("ConfigActive", "point1", "left");
				default: 
					break;
			}
		}
	}

}