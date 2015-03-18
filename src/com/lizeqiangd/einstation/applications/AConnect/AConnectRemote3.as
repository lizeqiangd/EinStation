package com.lizeqiangd.einstation.applications.AConnect
{
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.UnitEvent;
	import com.zweitehorizont.NetEvent;
	import com.zweitehorizont.ClientUtils;
	import com.zweitehorizont.ZweiteHorizont;
	import flash.events.Event;
	import net.nshen.nfms.FMSEvent;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class AConnectRemote3 extends TitleWindows implements iApplication
	{
		public function AConnectRemote3()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "AConnectRemote,本客户端cid:" + ClientUtils.getClientCid
			this.setApplicationName = "AConnectRemote3";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			tx_output.text = ""
			tx_cid.text = ""
			tx_connection_state.text = "连接中"
		}
		
		public function init(e:ApplicationEvent)
		{
			for (var i:int = 1; i < 10; i++)
			{
				this["btn" + i].title = "command" + i
				this["btn" + i].setColor = "lightblue"
				this["btn" + i].addEventListener(UnitEvent.CLICK, onCommandClick, false, 0, true)
			}
			onConnectStateHandle(null)
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function onCommandClick(e:UnitEvent):void
		{
			var receive_type:String = "cid";
			var receive_content:String = tx_cid.text;
			var object_message:Object = {receiver: {type: receive_type, content: receive_content}, information: {creator_uid: 0, create_date: new Date().toUTCString()}, content: {type: "message", message: e.target.title}}
			ZweiteHorizont.FMSProxys.dispatch("CommunicationManagerSendMessage", object_message)
		}
		
		private function addApplicationListener()
		{
			this.btn_connect.addEventListener(UnitEvent.CLICK, onConnectClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			ZweiteHorizont.FMSProxys.addConnectionEventListener(NetEvent.STATUS, onConnectStateHandle)
			ZweiteHorizont.FMSProxys.addEventListener("CommunicationManagerReceiveMessage", onReceiveMessage)
		}
		
		private function onConnectStateHandle(e:NetEvent):void
		{
			if (ZweiteHorizont.FMSProxys.isConnected)
			{
				tx_connection_state.text = "已经成功连接至服务器"
				btn_connect.enabled = false
				for (var i:int = 1; i < 10; i++)
				{
					this["btn" + i].enabled = true
				}
			}
			else
			{
				for (var k:int = 1; k < 10; k++)
				{
					this["btn" + k].enabled = false
				}
				btn_connect.enabled = true
				tx_connection_state.text = "服务器的连接已经断开"
			}
		
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onConnectClick(e:UnitEvent):void
		{
			ZweiteHorizont.FMSProxys.reconnect()
			tx_connection_state.text = "重新连接中"
		}
		
		private function onReceiveMessage(e:FMSEvent)
		{
			if (e.data2.content.type == "message")
			{
				tx_output.text = ""
				tx_output.appendText("" + e.data2.information.create_date + "\n")
				tx_output.appendText("" + e.data2.content.message )
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