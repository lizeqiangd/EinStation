package com.lizeqiangd.zweisystem.applications.SystemOperation.LoginSystem
{
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.LoginEvent;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout
	
	/**
	 * 普通系统登陆应用，简单的操作和应用。用途简单易懂结合ssn的使用。
	 * 2014.05.10 重新修正应用程序外观,更小更难以看清.新ui模式. 将来估计要将本地缓存放入新管理器中保存.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class LoginSystem extends TitleWindows implements iApplication
	{
		private var ssn:SystemStatusNotification;
		private var cache:Boolean = false;
		
		private var isLoginHandle:Boolean = false
		
		public function LoginSystem()
		{
			//this.setDisplayLayer = "topLayer";
			this.setDisplayLayer = "animationLayer";
			this.setApplicationTitle = "ZweiSystem - Login -";
			this.setApplicationName = "LoginSystem";
			this.setApplicationVersion = "2.0"
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent)
		{
			
			ssn = new SystemStatusNotification;
			ssn.init(220, 80);
			ssn.y = 20
			addChild(ssn);
			btn_left.title = "登出";
			btn_right.title = "登陆";
			this.ti_username.title = "";
			this.ti_password.title = "";
			if (LoginManager.isAdministrator)
			{
				welcome = "管理员:" + LoginManager.getUsername + " 已经登陆";
			}
			else
			{
				welcome = "请输入用户名和密码"
			}
			AnimationManager.MaskInStage()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
			StageProxy.focus = ti_username.tf
			StageProxy.nextTabForce(ti_password.tf)
		}
		
		private function addApplicationListener()
		{
			addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			btn_left.addEventListener(UnitEvent.CLICK, onLogOut);
			btn_right.addEventListener(UnitEvent.CLICK, onLogin);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onSubmit);
			LoginManager.addEventListener(LoginEvent.LOGIN_OK, onLoginSuccess)
			LoginManager.addEventListener(LoginEvent.LOGIN_FAULT, onLoginFailed)
		}
		
		private function removeApplicationListener()
		{
			btn_left.removeEventListener(UnitEvent.CLICK, onLogOut);
			btn_right.removeEventListener(UnitEvent.CLICK, onLogin);
			this.removeEventListener(KeyboardEvent.KEY_DOWN, onSubmit);
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			LoginManager.removeEventListener(LoginEvent.LOGIN_OK, onLoginSuccess)
			LoginManager.removeEventListener(LoginEvent.LOGIN_FAULT, onLoginFailed)
		}
		
		private function onSubmit(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				onLogin(null);
			}
		}
		
		private function onLoginSuccess(e:LoginEvent):void
		{
			welcome = "当前登陆用户为：" + LoginManager.getUsername;
			isLoginHandle ? setTimeout(this.CloseApplication, 2000) : null
			ssn.clean();
		}
		
		private function onLoginFailed(e:LoginEvent):void
		{
			btn_left.enabled = true
			btn_right.enabled = true
			isLoginHandle ? welcome = "登陆失败" : welcome = "请登录";
			Message.LoginFailed(ti_username.title)
			ssn.clean();
		}
		
		
		private function onLogOut(e:UnitEvent)
		{
			LoginManager.logOut();
			welcome = "已经成功登出.";
		}
		
		private function onLogin(e:UnitEvent)
		{
			ssn.anime("state.ssn_sending", "登陆中，请稍后");
			btn_left.enabled = false
			btn_right.enabled = false
			LoginManager.login(ti_username.text, ti_password.text, cb_save.selected);
			isLoginHandle = true
		}
		
		public function set welcome(t:String)
		{
			this.la_infomation.text = t;
			la_infomation.startTyping()
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			isLoginHandle = false
			removeApplicationListener();
			ssn.dispose()
			AnimationManager.MaskOutStage()
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