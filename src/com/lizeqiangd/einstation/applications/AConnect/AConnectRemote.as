package com.zweisystem.applications.AConnect
{
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.LoginManager;
	import com.zweitehorizont.ZweiteHorizont;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class AConnectRemote extends TitleWindows implements iApplication
	{
		public function AConnectRemote()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - AConnectRemote -";
			this.setApplicationName = "AConnectRemote";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			btn_all.enabled = LoginManager.isAdministrator
			btn_all.title = "全局发送"
			tx_cid.text = ""
		}
		
		public function init(e:ApplicationEvent)
		{
			for (var i:int = 1; i < 13; i++)
			{
				this["btn" + i].title = "command" + i
				this["btn" + i].setColor = "lightblue"
				this["btn" + i].addEventListener(UnitEvent.CLICK, onCommandClick, false, 0, true)
			}
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			
			addApplicationListener()
		}
		
		private function onCommandClick(e:UnitEvent):void
		{
			var receive_type:String = btn_all.isSelected ? "all" : "cid";
			var receive_content:String = btn_all.isSelected ? "0" : tx_cid.text;
			var object_message:Object = {receiver: {type: receive_type, content: receive_content}, information: {creator_uid: ZweiteHorizont.UserManagers.Users.cid, create_date: new Date().toUTCString()}, content: {type: "message", message: e.target.title}}
			ZweiteHorizont.FMSProxys.dispatch("CommunicationManagerSendMessage", object_message)
		}
		
		private function addApplicationListener()
		{
			//this.btn_all.addEventListener(UnitEvent.CHANGE, onAllClick)
			this.btn_connect.addEventListener(UnitEvent.CLICK, onConnectClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onConnectClick(e:UnitEvent):void
		{
			ZweiteHorizont.FMSProxys.reconnect()
		}
		
		private function onAllClick(e:UnitEvent):void
		{
			if (e.data)
			{
			}
			else
			{
			}
		
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			this.btn_connect.removeEventListener(UnitEvent.CLICK, onConnectClick)
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