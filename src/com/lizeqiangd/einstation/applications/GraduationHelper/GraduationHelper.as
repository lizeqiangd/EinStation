package com.zweisystem.applications.GraduationHelper
{
	import com.zweisystem.abstracts.active.ActiveManager;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.modules.notification.SystemStatusNotification;
	import flash.events.MouseEvent;
	
	/**
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	
	public class GraduationHelper extends TitleWindows implements iApplication
	{
		private var am:ActiveManager
		private var ssn:SystemStatusNotification
		public function GraduationHelper()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - GraduationHelper -";
			this.setApplicationName = "GraduationHelper";
			this.setApplicationVersion = "0"
			am = new ActiveManager(this)
			am.registerPointByActive(active_WelcomeActive, "p1")
			am.registerPointByActive(active_ManagerActive, "p2")
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent)
		{
			ssn = new SystemStatusNotification
			addChild(ssn)
			ssn.init (0,20,800,480)
			am.movein("WelcomeActive","p1")
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener()
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			this.btn_return.addEventListener (MouseEvent.CLICK ,onReturnClick)
		}
		
		private function onReturnClick(e:MouseEvent):void 
		{
			am.movein("WelcomeActive","p1")
			am.moveOutActiveByPoint("p1")
			am.moveOutActiveByPoint("p2")
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.btn_return.removeEventListener (MouseEvent.CLICK ,onReturnClick)
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
				case "wait": 
					ssn.anime ("state.Pleasewait","读取课程模块中")
					break;
				case "clean": 
					ssn.clean()
					break;
				default: 
					break;
			}
		}
	}

}