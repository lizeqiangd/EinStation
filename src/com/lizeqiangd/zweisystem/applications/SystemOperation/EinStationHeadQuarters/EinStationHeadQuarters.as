package com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters
{
	import com.lizeqiangd.zweisystem.abstract.active.ActiveManager;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweitehorizont.events.NetEvent
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * EinStationHeadQuarters为FMS服务器专属控制端。用于连接服务器操控等各项功能。
	 * 2013.03.31：开始着手制作功能
	 * 2014.05.10 更新应用 更改成为ZweiSystemHQ 同时修改应用构架
	 */
	
	public class EinStationHeadQuarters extends TitleWindows implements iApplication
	{
		public var ssn:SystemStatusNotification
		private var am:ActiveManager
		private const offline_password:String = "76423416"
		
		public function EinStationHeadQuarters()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "ZweiSystem Application - ZweiSystemHeadQuarters -";
			this.setApplicationName = "ZweiSystemHeadQuarters";
			this.setApplicationVersion = "0.8"
			this.addEventListener(ApplicationEvent.INIT, init);
			am = new ActiveManager(this)
			am.registerPointByActive(active_FunctionActive, "p0")
			am.registerPointByActive(active_BoardcastActive, "p1")
			am.registerPointByActive(active_UserActive, "p2")
			ssn = new SystemStatusNotification
		}
		
		public function init(e:ApplicationEvent)
		{
			
			ssn.init(500, 350)
			ssn.y = 20
			addChild(ssn)
			icon_connect_0.visible = false
			icon_connect_0.mouseEnabled = false
			icon_connect_1.visible = false
			icon_connect_1.mouseEnabled = false
			btn_login.title = "登陆系统"
			btn_search.title = "离线Code"
			btn_connect.title = "开始连接"
			btn_user_setting.title = "用户显示"
			cherkLogin()
			onFMSStatusChange(null)
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener()
		{
			btn_login.addEventListener(UnitEvent.CLICK, onLoginClick)
			btn_search.addEventListener(UnitEvent.SEARCH, onSearchClick)
			btn_connect.addEventListener(UnitEvent.CLICK, onConnectClick)
			btn_user_setting.addEventListener(UnitEvent.CLICK, user_setting_only)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			ZweiteHorizont.FMSProxys.addConnectionEventListener(NetEvent.STATUS, onFMSStatusChange)
			LoginManager.addLoginFunction(cherkLogin)
		}
		
		private function removeApplicationListener()
		{
			btn_login.removeEventListener(UnitEvent.CLICK, onLoginClick)
			btn_search.removeEventListener(UnitEvent.SEARCH, onSearchClick)
			btn_connect.removeEventListener(UnitEvent.CLICK, onConnectClick)
			btn_user_setting.removeEventListener(UnitEvent.CLICK, user_setting_only)
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			ZweiteHorizont.FMSProxys.removeConnectionEventListener(NetEvent.STATUS, onFMSStatusChange)
			LoginManager.removeLoginFunction(cherkLogin)
		}
		
		private function onFMSStatusChange(e:NetEvent=null):void
		{
			if (ZweiteHorizont.FMSProxys.isConnected)
			{
				if (LoginManager.isAdministrator)
				{
					ssn.clean()
				}
				else
				{
					ssn.anime("notification.app_unauthorize", "应用没有获得授权，请登录")
				}
				btn_connect.title = "断开连接"
				AnimationManager.fade_in(icon_connect_1)
				AnimationManager.fade_out(icon_connect_0)
			}
			else
			{
				ssn.anime("notification.app_unauthorize", "没有连接至EinStation总控制服务器")
				btn_connect.title = "开始连接"
				AnimationManager.fade_out(icon_connect_1)
				AnimationManager.fade_in(icon_connect_0)
			}
		}
		
		private function cherkLogin():void
		{
			if (LoginManager.isAdministrator)
			{
				btn_user_setting.enable = false
				if (ZweiteHorizont.FMSProxys.isConnected)
				{
					ssn.clean()
				}
				else
				{
					ssn.anime("notification.app_unauthorize", "没有连接至EinStation总控制服务器")
				}
				am.moveOutActiveByPoint("p0", "left")
				am.moveOutActiveByPoint("p1", "right")
				am.moveOutActiveByPoint("p2", "right")
				am.movein("FunctionActive", "p0", "left")
			}
			else
			{
				btn_user_setting.enable = true
				am.moveOutActiveByPoint("p0", "left")
				am.moveOutActiveByPoint("p1", "right")
				am.moveOutActiveByPoint("p2", "right")
				ssn.anime("notification.app_unauthorize", "应用没有获得授权，请登录")
			}
		}
		
		private function user_setting_only(e:UnitEvent)
		{
			btn_user_setting.enable = false
			
			
			am.movein("UserSettingActive", "p1")
			am.movein("UserActive", "p2")
			ssn.clean()
		}
		
		private function onLoginClick(e:UnitEvent):void
		{
			ApplicationManager.open("com.lizeqiangd.zweisystem.applications.SystemOperation.LoginSystem.LoginSystem")
			//FMS.dispatch("EinStationBoardcastMessage",{message:"测试广播",user_name:LoginManager.getUsername})
		}
		
		private function onSearchClick(e:UnitEvent):void
		{
			if (e.data == offline_password)
			{
				ssn.clean()
				Message.HQ_offline_control()
			}else {
				btn_search.title="error code"
			}
		}
		
		private function onConnectClick(e:UnitEvent):void
		{
			switch (e.target.title)
			{
				case "开始连接": 
					ZweiteHorizont.FMSProxys.reconnect()
					break;
				case "断开连接": 
					ZweiteHorizont.FMSProxys.disconnect()
					break;
				default: 
			}
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