package com.zweisystem.applications.AConnect
{
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.UnitEvent;
	import com.zweitehorizont.ZweiteHorizont;
	import net.nshen.nfms.FMSEvent;
	import com.zweisystem.managers.LoginManager;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class AConnectRemote2 extends TitleWindows implements iApplication
	{
		public function AConnectRemote2()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - AConnectRemote2 -";
			this.setApplicationName = "AConnectRemote2";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			btn_all.enabled = LoginManager.isAdministrator
			btn_all.title = "全局发送"
			tx_cid.text = ""
			tx_output1.text = ""
			tx_output2.text = ""
			tx_output3.text = ""
		}
		
		public function init(e:ApplicationEvent)
		{
			for (var i:int = 1; i < 7; i++)
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
			var object_message:Object = {receiver: {type: receive_type, content: receive_content}, information: {creator_uid: 0, create_date: new Date().toUTCString()}, content: {type: "message", message: e.target.title}}
			ZweiteHorizont.FMSProxys.dispatch("CommunicationManagerSendMessage", object_message)
		}
		
		private function addApplicationListener()
		{
			
			this.btn_connect.addEventListener(UnitEvent.CLICK, onConnectClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			ZweiteHorizont.FMSProxys.addEventListener("CommunicationManagerReceiveMessage", onReceiveMessage)
		}
		
		private function onReceiveMessage(e:FMSEvent)
		{
			if (e.data2.content.type == "message")
			{
				tx_output3.text = ""
				//tx_output3.appendText("信息编号mid：" + e.data2.mid + "\n")
				tx_output3.appendText("发送者客户端id:" + e.data2.information.creator_uid + "\n")
				tx_output3.appendText("" + e.data2.information.create_date + "\n")
				tx_output3.appendText("信息内容:" + e.data2.content.message + "\n")
			}
			if (e.data2.content.message == "power1")
			{
				tx_output1.text = "当前电源开关为: 开"
			}
			if (e.data2.content.message == "power0")
			{
				tx_output1.text = "当前电源开关为: 关"
			}
			var index1:int = String(e.data2.content.message).search('C')
			if (index1 > 0)
			{
				tx_output2.text = "当前室内温度为: " + String(e.data2.content.message).replace("C", "") + "°C";
			}
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