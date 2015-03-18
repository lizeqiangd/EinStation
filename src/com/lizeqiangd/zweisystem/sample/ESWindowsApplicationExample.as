package com.lizeqiangd.zweisystem.sample
{	
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.sina.microblog.events.MicroBlogEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * 2014.06.30 完成授权段的设计制作.
	 */
	
	public class WeiboMainController extends TitleWindows implements iApplication
	{
		private var ssn:SystemStatusNotification
		public var btn_oauth:btn_general
		public var btn_publish:btn_general
		private var image:ImageDisplay
		private var isMask:Boolean = true
		
		public function WeiboMainController()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "微博总控端";
			this.setApplicationName = "WeiboMainController";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			tx_name.text = "等待授权"
		}
		
		public function init(e:ApplicationEvent)
		{
			ssn = new SystemStatusNotification
			ssn.init(180, 180, this)
			ssn.y = 20
			AnimationManager.fade(mc_bg, 0.7)
			//put your code here
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener()
		{
			mc_bg.addEventListener(MouseEvent.CLICK, onMouseMaskClick)
			btn_oauth.addEventListener(UnitEvent.CLICK, onOauthClick)
			btn_publish.addEventListener(UnitEvent.CLICK, onPublishClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			WeiboManager.addEventListener(MicroBlogEvent.LOGIN_SUCCESS, onLoginSuccess)
		}
		
		private function onPublishClick(e:Event):void
		{
			ApplicationManager.open("com.lizeqiangd.zweisystem.applications.Weibo.Publisher.WeiboDefaultPublisher")
		}
		
		private function onMouseMaskClick(e:MouseEvent):void
		{
		}
		
		private function onLoginSuccess(e:MicroBlogEvent):void
		{
			ssn.clean()
			btn_oauth.title = "退出授权"
			this.tx_name.text = WeiboManager.getCacheUserData.screen_name
			image = new ImageDisplay()
			image.configNone()
			image.load(WeiboManager.getCacheUserData.avatar_large)
			image.y = 20
			addChildAt(image, 0)
		}
		
		private function onOauthClick(e:Event):void
		{
			if (!WeiboManager.getIsLogined)
			{
				ssn.anime("notification.app_wait", "等待授权token返回")
				WeiboManager.debugMode()
				//WeiboManager.login()
			}
			else
			{
				btn_publish.enable = false
				WeiboManager
			}
		}
		
		private function removeApplicationListener()
		{
			btn_oauth.removeEventListener(UnitEvent.CLICK, onOauthClick)
			WeiboManager.removeEventListener(MicroBlogEvent.LOGIN_SUCCESS, onLoginSuccess)
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