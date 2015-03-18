package com.lizeqiangd.zweisystem.applications.MessageChannel.Lobby.Standard
{
	
	import com.lizeqiangd.zweisystem.components.encode.DateTimeUtils;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general_s;
	import com.lizeqiangd.zweisystem.interfaces.numericstepper.ns_general;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.modules.datagird.DataGird;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweitehorizont.data.message.MessageChannel;
	import com.lizeqiangd.zweitehorizont.events.MessageChannelEvent;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import flash.events.Event;
	
	/**
	 * @author lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website $(DefaultSite)
	 */
	
	public class StandardLobby extends TitleWindows implements iApplication
	{
		public var row_title:rows_standard_lobby_channel
		public var btn_create_channel:btn_general_s
		public var btn_refresh:btn_general_s
		public var btn_close_channel:btn_general_s
		public var btn_join_channel:btn_general_s
		public var ns_rows:ns_general
		
		private var dg:DataGird
		private var ssn:SystemStatusNotification
		private var tempChatRoom:iApplication
		private var tempRowData:Object
		
		public function StandardLobby()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - StandardLobby - (demo)";
			this.setApplicationName = "StandardLobby";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			dg = new DataGird()
			dg.config(this, "com.lizeqiangd.zweisystem.applications.MessageChannel.Lobby.Standard.rows_standard_lobby_channel", 9)
			dg.y = 40
			row_title.titleMode()
			row_title.tx_id.text = "id"
			row_title.tx_channel_name.text = "频道名称"
			row_title.tx_channel_creator_display_name.text = "创建者显示名称"
			row_title.tx_channel_type.text = "类别"
			row_title.tx_user_count.text = "人数"
			ssn = new SystemStatusNotification
			ssn.init(500, 380)
			ssn.y = 20
			addChild(ssn)
			tx_information.text = ""
		}
		
		public function init(e:ApplicationEvent)
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
			onRefreshClick(null)
			onUserLoginHandle()
			tx_information.text = "目前通道无法被用户创建.可加现有的进行测试.修改昵称去点击左上角按钮进入用户界面"
			
			la_creator.title = "没有选择目标"
			la_channel_security.title = "安全等级:" + " "
			la_user_count.title = "在线用户数:" + " "
			la_channel_create_time.title = "创建时间:" + " "
			la_channel_type.title = "通道类型:" + " "
			ti_channel_name.title = " "
			ti_channel_description.title = " "
		}
		
		private function addApplicationListener()
		{
			LoginManager.addLoginFunction(onUserLoginHandle)
			btn_refresh.addEventListener(UnitEvent.CLICK, onRefreshClick)
			btn_create_channel.addEventListener(UnitEvent.CLICK, onCreateChannelClick)
			btn_join_channel.addEventListener(UnitEvent.CLICK, onJoinChannelClick)
			btn_close_channel.addEventListener(UnitEvent.CLICK, onCloseChannelClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			ns_rows.addEventListener(UnitEvent.CHANGE, onNSChange)
			dg.addRowsListener(UnitEvent.CLICK, onRowClick)
			ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.GET_CHANNELS, onGetChannels)
			ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.JOIN_CHANNEL, onJoinChannelHandle)
		}
		
		private function onNSChange(e:UnitEvent):void
		{
		
		}
		
		private function onRowClick(e:UnitEvent):void
		{
			tempRowData = e.data
			la_creator.title = tempRowData.channel.channel_data.channel_creator.display_name
			la_channel_security.title = "安全等级:" + tempRowData.channel.channel_data.channel_security
			la_user_count.title = "在线用户数:" + tempRowData.user_count
			la_channel_create_time.title = "创建时间:" + tempRowData.channel.channel_data.channel_create_time
			la_channel_type.title = "通道类型:" + tempRowData.channel.channel_data.channel_type
			ti_channel_name.title = tempRowData.channel.channel_data.channel_name
			ti_channel_description.title = tempRowData.channel.channel_data.channel_description
			
			la_creator.startTyping()
			la_channel_security.startTyping()
			la_user_count.startTyping()
			la_channel_type.startTyping()
			la_channel_create_time.startTyping()
		}
		
		private function onRefreshClick(e:Event):void
		{
			ZweiteHorizont.MessageChannelManagers.GetChannels("all")
			ssn.anime("state.ssn_loading", "读取列表中,请稍后")
		}
		
		private function onGetChannels(e:MessageChannelEvent):void
		{
			ssn.clean()
			ns_rows.init(9, e.data.length)
			if (e.data.length == 0)
			{
			}
			else
			{
				dg.init(e.data)
				dg.animation()
			}
		}
		
		private function onCloseChannelClick(e:Event):void
		{
		
		}
		
		private function onJoinChannelClick(e:Event):void
		{
			ssn.anime("state.ssn_loading", "加入中,请稍后")
			tempChatRoom = ApplicationManager.open("com.lizeqiangd.zweisystem.applications.MessageChannel.ChatRoom.Standard.StandardChatRoom")
			ZweiteHorizont.MessageChannelManagers.JoinChannel(tempRowData.channel.channel_data.channel_id)
		}
		
		private function onJoinChannelHandle(e:MessageChannelEvent):void
		{
			ssn.clean()
			try
			{
				tempChatRoom.applicationMessage({type: "channel_id", value: MessageChannel.GetChannel(e.data).channel_data.channel_id})
			}
			catch (e:*)
			{
			}
		}
		
		private function onCreateChannelClick(e:Event):void
		{
		
		}
		
		private function onUserLoginHandle():void
		{
			btn_close_channel.enable = LoginManager.isAdministrator
			btn_create_channel.enable = LoginManager.isAdministrator
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