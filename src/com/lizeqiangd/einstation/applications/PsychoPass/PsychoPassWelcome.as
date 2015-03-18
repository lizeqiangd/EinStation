package com.zweisystem.applications.PsychoPass
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.greensock.TweenLite;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.ApplicationManager;
	import com.zweisystem.managers.LayerManager;
	import flash.utils.setTimeout
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.abstracts.windows.TitleWindows;
	
	public class PsychoPassWelcome extends TitleWindows implements iApplication
	{
		public function PsychoPassWelcome()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "Psycho-Pass With Weibo";
			this.setApplicationName = "PsychoPassWelcome";
			btn_login.title = "进入SiblySystem"
			btn_login.title2 = "Login SiblySystem"
			btn_weibo.title = "登陆微博获得授权"
			btn_weibo.title2 = "Weibo Authorization"
			mc_information.visible = false
			addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent)
		{
			addUiListener();
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function addUiListener()
		{
			btn_login.addEventListener(UnitEvent.CLICK, onClick);
			btn_weibo.addEventListener(UnitEvent.CLICK, onClick);
			addEventListener(ApplicationEvent.CLOSE, applicationClose);
			SinaMicroBlogManager.addEventListener("UserShow", onWeiboUserShow, false, 0,false)
		}
		
		private function onWeiboUserShow(e:*)
		{
			moveOutButton()
			mc_information.visible = true
			TweenLite.from(mc_information, 0.5, {x: mc_information.x + 100, alpha: 0})
			mc_information.init(e.result)
			setTimeout(openMain, 3000)
			setTimeout(closeIt, 3200)
		}
		
		private function openMain()
		{
			ApplicationManager.open("PsychoPass.PsychoPassInformationDisplay")
			LayerManager.setForceLayer(this)
		}
		
		private function closeIt()
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		private function onClick(e:UnitEvent):void
		{
			switch (e.target.name)
			{
				case "btn_login": 
					ApplicationManager.Application("PsychoPassBackground").dispose()	
					ApplicationManager.open("com.zweisystem.applications.PsychoPass.PsychoPassControlSystem",true)
				 CloseApplication()
					break
				case "btn_weibo": 
					//trace("PsychoPassWelcome内侧模式")
					//SinaMicroBlogManager.debugMode()
					SinaMicroBlogManager.login()
					break;
			}
		}
		
		private function moveOutButton()
		{
			TweenLite.to(btn_login, 0.5, {y: btn_login.y + 100, alpha: 0})
			TweenLite.to(btn_weibo, 0.5, {y: btn_weibo.y + 100, alpha: 0})
		}
		
		private function removeUiListener()
		{
			btn_login.removeEventListener(UnitEvent.CLICK, onClick);
			btn_weibo.removeEventListener(UnitEvent.CLICK, onClick);
			removeEventListener(ApplicationEvent.INIT, init);
			removeEventListener(ApplicationEvent.CLOSE, applicationClose);
			SinaMicroBlogManager.removeEventListener("UserShow", onWeiboUserShow)
		}
		
		private function applicationClose(e:ApplicationEvent)
		{
			removeUiListener();
		}
		
		public function dispose()
		{
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