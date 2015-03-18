package com.lizeqiangd.einstation.applications.AConnect
{
	import com.lizeqiangd.aconnect.AConnect;
	import com.lizeqiangd.aconnect.events.AConnectEvent;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.AnimationManager;
	import com.zweitehorizont.User;
	import com.zweitehorizont.ZweiteHorizont;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import net.nshen.nfms.FMSEvent;
	import com.zweitehorizont.NetEvent;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class AConnectClient extends TitleWindows implements iApplication
	{
		private var increaseId:uint = 0
		private var trans_to_cid:uint = 0
		
		public function AConnectClient()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - AConnectClient -";
			this.setApplicationName = "AConnectClient";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			tx_trans.text = ""
			tx_input_cid.title = "接收端cid"
			onClientClick(null)
			onCleanClick(null)
		}
		
		public function init(e:ApplicationEvent)
		{
			AConnect.init()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			onClientClick(null)
			addApplicationListener()
			if (ZweiteHorizont.FMSProxys.isConnected)
			{
				var user:User = ZweiteHorizont.UserManagers.Users
				user.display_name = "ACClient" + user.cid
				ZweiteHorizont.UserManagers.updateUserInformation(user)
				
			}onClientClick(null)
		}
		
		private function addApplicationListener()
		{
			ZweiteHorizont.FMSProxys.addEventListener("CommunicationManagerReceiveMessage", onReceiveMessage)
			ZweiteHorizont.FMSProxys.addConnectionEventListener(NetEvent.STATUS, onClientClick)
			AConnect.addEventListener(AConnectEvent.MESSAGE, onSocketMessage)
			AConnect.addEventListener(AConnectEvent.SOCKET_STATE, onSocketState)
			btn_clean.addEventListener(UnitEvent.CLICK, onCleanClick)
			btn_client.addEventListener(UnitEvent.CLICK, onClientClick)
			btn_connect.addEventListener(UnitEvent.CLICK, onConnectClick)
			btn_submit.addEventListener(UnitEvent.CLICK, onSubmitClick)
			tx_input.addEventListener(KeyboardEvent.KEY_DOWN, onSubmit)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			tx_input_cid.addEventListener(UnitEvent.SEARCH, onCidClick)
		}
		private function onCidClick(e:UnitEvent):void
		{
			trans_to_cid = uint(e.data)
			tx_trans.text = "转发信息给cid:" + trans_to_cid
		}
		
		private function onSubmit(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				onSubmitClick(null)
			}
		}
		
		private function onSubmitClick(e:UnitEvent):void
		{
			tx_income.appendText("本机发送信息:" + tx_input.text + "\n")
			tx_income.scrollV = tx_income.maxScrollV
			btn_receive.alpha = 1
			AnimationManager.fade_out(btn_receive)
			AConnect.sendData(tx_input.text)
		}
		
		private function onReceiveMessage(e:FMSEvent)
		{
			if (e.data2.content.type == "message")
			{
				tx_income.appendText("信息编号mid：" + e.data2.mid + "\n")
				tx_income.appendText("发送者cid:" + e.data2.information.creator_uid + "\n")
				tx_income.appendText("发送时间:" + e.data2.information.create_date + "\n")
				tx_income.appendText("信息内容:" + e.data2.content.message + "\n")
				tx_income.scrollV = tx_income.maxScrollV
				btn_receive.alpha = 1
				AnimationManager.fade_out(btn_receive)
				AConnect.sendData(e.data2.content.message)
			}
			//trans_to_cid = uint(e.data2.information.creator_uid)
			//tx_trans.text = "转发信息给cid:" + trans_to_cid
		}
		
		private function sendMessage(e:String)
		{
			//var receive_type:String = trans_to_cid == 0 ? "all" : "cid";
			if (trans_to_cid == 0)
			{
				return
			}
			var receive_content:String = String(trans_to_cid);
			var object_message:Object = {receiver: {type: "cid", content: receive_content}, information: {creator_uid: ZweiteHorizont.UserManagers.Users.cid, create_date: new Date().toUTCString()}, content: {type: "message", message: e}}
			ZweiteHorizont.FMSProxys.dispatch("CommunicationManagerSendMessage", object_message)
		}
		
		private function onSocketState(e:AConnectEvent):void
		{
			btn_connect.enable = true
			if (e.data == "connected")
			{
				btn_connect.title = "断开连接"
			}
			else
			{
				btn_connect.title = "开始连接"
			}
			tx_output.appendText("Connection:" + e.data + "\n")
		}
		
		private function onSocketMessage(e:AConnectEvent):void
		{
			tx_output.appendText("[" + increaseId + "]:" + e.data + "\n")
			sendMessage(e.data)
			tx_output.scrollV = tx_output.maxScrollV
			btn_output.alpha = 1
			AnimationManager.fade_out(btn_output)
			increaseId++
		}
		
		private function onClientClick(e:*):void
		{
			if (ZweiteHorizont.FMSProxys.isConnected)
			{
				tx_client.text = "本机cid:" + ZweiteHorizont.UserManagers.Users.cid + " display_name: " + ZweiteHorizont.UserManagers.Users.display_name
			}
			else
			{
				tx_client.text = "没有连接到服务器,请点击左上角应用后，点击【重新连接】"
			}
		}
		
		private function onCleanClick(e:UnitEvent):void
		{
			tx_income.text = ""
			tx_input.text = ""
			tx_output.text = ""
		}
		
		private function onConnectClick(e:UnitEvent):void
		{
			if (btn_connect.title == "断开连接")
			{
				btn_connect.title = "开始连接"
				btn_connect.enable = false
				AConnect.disconnect()
				return
			}
			if (btn_connect.title == "开始连接")
			{
				btn_connect.title = "断开连接"
				btn_connect.enable = false
				AConnect.connect(tx_host.text, uint(tx_port.text))
				return
			}
		
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			ZweiteHorizont.FMSProxys.removeEventListener("CommunicationManagerReceiveMessage", onReceiveMessage)
			AConnect.removeEventListener(AConnectEvent.MESSAGE, onSocketMessage)
			AConnect.removeEventListener(AConnectEvent.SOCKET_STATE, onSocketState)
			btn_clean.removeEventListener(UnitEvent.CLICK, onCleanClick)
			btn_client.removeEventListener(UnitEvent.CLICK, onClientClick)
			btn_connect.removeEventListener(UnitEvent.CLICK, onConnectClick)
			btn_submit.removeEventListener(UnitEvent.CLICK, onSubmitClick)
			tx_input.removeEventListener(KeyboardEvent.KEY_DOWN, onSubmit)
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