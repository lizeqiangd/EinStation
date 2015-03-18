package com.lizeqiangd.zweisystem.system.applications.zweitehorizontwidget
{
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.LoginEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweitehorizont.data.object.User;
	import com.lizeqiangd.zweitehorizont.events.NetEvent;
	import com.lizeqiangd.zweitehorizont.events.UserEvent;
	import com.lizeqiangd.zweitehorizont.system.ClientUtils;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class ZweiteHorizontWidget extends BaseWindows implements iApplication
	{
		private var _uid:uint = 0
		private var _user_type:String = "guest"
		private var _display_name:String = "ES_Guest" + ClientUtils.getClientCid
		private var _description:String = "EinStationUser"
		
		public function ZweiteHorizontWidget()
		{
			this.setDisplayLayer = "topLayer";
			this.setApplicationName = "ZweiteHorizontWidget";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			init(null)
			btn_confirm.mouseEnabled = false
			btn_close.mouseEnabled = false
			btn_wait.mouseEnabled = false
			btn_confirm.alpha = 0
			btn_close.alpha = 1
			btn_wait.alpha = 0
		}
		
		public function init(e:ApplicationEvent)
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener()
		{
			this.addEventListener(MouseEvent.CLICK, onClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			ZweiteHorizont.FMSProxys.addConnectionEventListener("status", onFMSStatus)
			ZweiteHorizont.UserManagers.addUserEventListener("user_event", onUserUpdate)
			LoginManager.addLoginFunction(onLoginFunction)
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(MouseEvent.CLICK, onClick)
			this.removeEventListener(ApplicationEvent.INIT, init);
			ZweiteHorizont.FMSProxys.removeConnectionEventListener("status", onFMSStatus)
			ZweiteHorizont.UserManagers.removeUserEventListener("user_event", onUserUpdate)
			LoginManager.removeLoginFunction(onLoginFunction)
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onClick(e:MouseEvent):void
		{
			ApplicationManager.open("com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters.EinStationHeadQuarters");
		}
		
		private function onLoginFunction():void
		{
			if (ZweiteHorizont.FMSProxys.isConnected)
			{
				onLogin2ZweiteHorizont()
			}
		}
		
		private function onLogin2ZweiteHorizont()
		{
			btn_wait.alpha = 1
			
			if (LoginManager.isAdministrator)
			{
				_user_type = LoginManager.getUserType
				_display_name = LoginManager.getUsername
			}
			var o:User = new User
			o.cid = ClientUtils.getClientCid
			o.uid = _uid
			o.description = _description
			o.display_name = _display_name
			o.user_type = _user_type
			ZweiteHorizont.UserManagers.updateUserInformation(o)
		}
		
		private function onUserUpdate(e:UserEvent):void
		{
			if (e.data.cid == ClientUtils.getClientCid)
			{
				_uid = e.data.uid
				_description = e.data.description
				_display_name = e.data.display_name
				_user_type = e.data.user_type
			}
			tx_text1.text = "本机识别名:" + ZweiteHorizont.UserManagers.Users.display_name
			tx_text2.text = "cid:" + String(ZweiteHorizont.UserManagers.Users.cid)
			
			TextAnimation.Typing(tx_text1)
			TextAnimation.Typing(tx_text2)
			btn_wait.alpha = 1
			AnimationManager.fade_out(btn_wait)
		}
		
		private function onFMSStatus(e:NetEvent):void
		{
			
			if (e.data == "connected")
			{
				onLogin2ZweiteHorizont()
				AnimationManager.fade_in(btn_confirm)
				AnimationManager.fade_out(btn_close)
			}
			else
			{
				AnimationManager.fade_in(btn_close)
				AnimationManager.fade_out(btn_confirm)
			}
			
			tx_text3.text = ZweiteHorizont.FMSProxys.getStatus
			TextAnimation.Changing(tx_text3, TextAnimation.ALPHABET, 1, true)
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
				case 1: 
					tx_text1.text = e.content
					break;
				case 2: 
					tx_text2.text = e.content
					break;
				case "changeusername": 
					_user_type = e.user_type
					_display_name = e.display_name
					_description = e.description
				default: 
					break;
			}
		}
		
		public function updateUserInformation()
		{
			onLoginFunction()
		}
		
		public function set setUid(value:uint)
		{
			_uid = value
		}
		
		public function set setUser_type(value:String)
		{
			_user_type = value
		}
		
		public function set setDisplay_name(value:String)
		{
			_display_name = value
		}
		
		public function set setDescription(value:String)
		{
			_description = value
		}
	}
}

