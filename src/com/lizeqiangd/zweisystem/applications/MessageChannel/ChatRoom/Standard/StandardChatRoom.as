package com.lizeqiangd.zweisystem.applications.MessageChannel.ChatRoom.Standard
{
	
	import com.lizeqiangd.zweisystem.components.encode.DateTimeUtils;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweitehorizont.data.message.Message;
	import com.lizeqiangd.zweitehorizont.data.message.MessageChannel;
	import com.lizeqiangd.zweitehorizont.data.message.MessageData;
	import com.lizeqiangd.zweitehorizont.events.MessageChannelEvent;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	/**
	 * @author lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website $(DefaultSite)
	 */
	
	public class StandardChatRoom extends TitleWindows implements iApplication
	{
		public var tx_channel_info:TextField
		public var tx_userlist:TextField
		public var tx_content:TextField
		public var tx_submit:TextField
		public var tx_type:TextField
		public var tx_input:TextField
		
		public var mc_submit:MovieClip
		public var mc_type:MovieClip
		
		private var channel_id:uint = 0
		private var ssn:SystemStatusNotification
		private var lastmessage:Message
		
		public function StandardChatRoom()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - StandardChatRoom -";
			this.setApplicationName = "StandardChatRoom";
			this.setApplicationVersion = "0"
			this.setMutiExistEnable = true
			this.addEventListener(ApplicationEvent.INIT, init);
			tx_content.text = ""
			tx_channel_info.text = "没有定义channel_id"
			tx_content.text = "等待连接"
			tx_input.text = ""
			tx_userlist.text = ""
			tx_content.mouseEnabled = false
			tx_userlist.mouseEnabled = false
			tx_type.mouseEnabled = false
			tx_submit.mouseEnabled = false
		}
		
		public function init(e:ApplicationEvent)
		{
			//put your code here
			ssn = new SystemStatusNotification
			ssn.init(400, 20)
			ssn.y = 380
			addChild(ssn)
			tx_userlist.text="无法查看用户列表"
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function addApplicationListener()
		{
			btn_submit.addEventListener(MouseEvent.CLICK, onSubmitClick)
			btn_type.addEventListener(MouseEvent.CLICK, onTypeClick)
			this.addEventListener(KeyboardEvent.KEY_DOWN, onSubmit);
			ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.SEND_MESSAGE, onMessageSend)
			ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.MESSAGE_UPDATE, onMessageUpdate)
		}
		
		private function onSubmit(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				this.removeEventListener(KeyboardEvent.KEY_DOWN, onSubmit);
				onSubmitClick(null)
			}		
		}
		
		private function onMessageSend(e:MessageChannelEvent):void
		{
			ssn.clean()
			tx_input.text = ""
			StageProxy.focus = tx_input
			this.addEventListener(KeyboardEvent.KEY_DOWN, onSubmit);
		}
		
		private function onMessageUpdate(e:MessageChannelEvent):void
		{
			if (e.data.channel_id == channel_id)
			{
				input("<" + Message(e.data.message).message_user_display_name + ">:" + Message(e.data.message).message_content)
			}
		}
		
		private function onSubmitClick(e:MouseEvent):void
		{
			ssn.anime("")
			lastmessage = new Message()
			lastmessage.message_content = tx_input.text + ""
			lastmessage.message_date = DateTimeUtils.getDateTime()
			lastmessage.message_user_display_name = ZweiteHorizont.UserManagers.Users.display_name
			lastmessage.message_type = "message"
			trace("channel_id:", channel_id)
			ZweiteHorizont.MessageChannelManagers.SendMessage(lastmessage, channel_id)
		}
		
		private function onTypeClick(e:MouseEvent):void
		{
		
		}
		
		private function removeApplicationListener()
		{
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
		
		public function input(e:String)
		{
			tx_content.appendText(e + "\n")
			tx_content.scrollV = tx_content.maxScrollV
		}
		
		public function applicationMessage(e:Object)
		{
			switch (e.type)
			{
				case "channel_id": 
					channel_id = e.value
					addApplicationListener()
					var md:MessageData = new MessageData
					md = MessageChannel.SearchChannel("channel_id", e.value).channel_data
					input("频道介绍:" + md.channel_description)
					tx_channel_info.text = "频道名称:" + md.channel_name + " 创建者:" + md.channel_creator.display_name + " 安全等级:" + md.channel_security + " 通道编号:" + md.channel_id
					break;
				default: 
					break;
			}
		}
	}

}