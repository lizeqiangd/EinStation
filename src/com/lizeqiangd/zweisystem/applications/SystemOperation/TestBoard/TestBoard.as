package com.lizeqiangd.zweisystem.applications.SystemOperation.TestBoard
{
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.components.encode.DateTimeUtils;
	import com.lizeqiangd.zweisystem.components.encode.HexagonHelper;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.data.media.Music;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.manager.SystemManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.system.applications.musicwidget.MusicWidgetManager;
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.events.NetEvent;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.manager.MusicManager;
	import com.lizeqiangd.zweitehorizont.data.message.Message;
	import com.lizeqiangd.zweitehorizont.events.MessageChannelEvent;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import net.nshen.nfms.FMSEvent;
	import com.junkbyte.console.Cc;
	
	public class TestBoard extends TitleWindows implements iApplication
	{
		private var ssn:SystemStatusNotification;
		private var sub_app:*;
		
		public function TestBoard()
		{
			setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "ZweiSystem OS Application - TestBoard -";
			this.setApplicationName = "TestBoard";
			addEventListener(ApplicationEvent.INIT, init);
			addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		
		}
		
		private function addUiListener()
		{
			btn_test.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test1.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test2.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test3.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test4.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test5.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test6.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test7.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test8.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_test9.addEventListener(UnitEvent.CLICK, mouseTester);
			btn_confirm.addEventListener(UnitEvent.CLICK, onConfirm);
		}
		
		private function removeUiListener()
		{
			btn_test.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_confirm.removeEventListener(UnitEvent.CLICK, onConfirm);
			btn_test1.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_test2.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_test3.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_test4.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_test5.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_test6.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_test7.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_test8.removeEventListener(UnitEvent.CLICK, mouseTester);
			btn_test9.removeEventListener(UnitEvent.CLICK, mouseTester);
			removeEventListener(ApplicationEvent.INIT, init);
			removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onConfirm(e:UnitEvent)
		{
			sub_app = null;
			sub_app = ApplicationManager.open(tx_input.text);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeUiListener();
		}
		
		public function init(e:ApplicationEvent)
		{
			
			ssn = new SystemStatusNotification;
			addChild(ssn);
			ssn.init(800, 560);
			ssn.y = 20
			addUiListener();
			btn_confirm.title = "打开程序";
			btn_test.title = "Console";
			btn_test1.title = "创建";
			btn_test2.title = "加入";
			btn_test3.title = "离开";
			btn_test4.title = "关闭";
			btn_test5.title = "发送信息";
			btn_test6.title = "播放音乐";
			btn_test7.title = "播放音乐2";
			btn_test8.title = "隐藏widget";
			btn_test9.title = "输出配置";
			changeInfo = "ZweiSystem3.0系统测试应用..";
			tx_input.text = "com.lizeqiangd.zweisystem.applications.";
			ssn.clean();
			test();
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function test()
		{
			if (!LoginManager.isAdministrator)
			{
				ssn.anime("notification.app_unauthorize", "没有获得授权,请登陆后尝试")
			}
			ti_1.text = "公共大厅"
			ti_2.text = "所有人都可以进的大厅"
			ti_3.text = "lobby"
			ti_4.text = "10"
			ti_5.text = "1"
			ti_6.text = "message"
			ti_7.text = "lizeqiangd"
			ti_8.text = "测试信息"
			ti_9.text = "qweASDzxc"
			ZweiteHorizont.FMSProxys.addEventListener("CommunicationManagerReceiveMessage", onReceiveMessage)
			//ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.CREATE_CHANNEL, onFMSEventReturn)
			//ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.CLOSE_CHANNEL, onFMSEventReturn)
			//ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.CHANNEL_CLOSE, onFMSEventReturn)
			//ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.JOIN_CHANNEL, onFMSEventReturn)
			//ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.LEAVE_CHANNEL, onFMSEventReturn)
			ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.MESSAGE_UPDATE, onFMSEventReturn)
			//ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.SEND_MESSAGE, onFMSEventReturn)
			//ZweiteHorizont.MessageChannelManagers.addMessageChannelEventListener(MessageChannelEvent.USER_UPDATE, onFMSEventReturn)
		}
		
		private function onFMSEventReturn(e:MessageChannelEvent):void
		{
			tx_receive.appendText("<" + e.data.message.message_user_display_name + ">:" + e.data.message.message_content + "\n")
		}
		
		private function onReceiveMessage(e:FMSEvent)
		{
			if (e.data2.content.type == "message")
			{
				tx_receive.text = ""
				tx_receive.appendText("信息编号mid：" + e.data2.mid)
				tx_receive.appendText("\ncreator_uid:" + e.data2.information.creator_uid)
				tx_receive.appendText("\ncreate_date:" + e.data2.information.create_date)
				tx_receive.appendText("\n信息内容：\n" + e.data2.content.message)
			}
		}
		
		private function mouseTester(e:UnitEvent)
		{
			switch (e.target.name)
			{
				case "btn_test": 
					Cc.visible = !Cc.visible
					break;
				case "btn_test1": 
					var o:Object = {}
					o.channel_name = ti_1.text
					o.channel_description = ti_2.text
					o.channel_type = ti_3.text
					o.channel_security = ti_4.text
					ZweiteHorizont.MessageChannelManagers.CreateChannel(o)
					break;
				case "btn_test2": 
					ZweiteHorizont.MessageChannelManagers.JoinChannel(uint(ti_5.text))
					break;
				case "btn_test3": 
					ZweiteHorizont.MessageChannelManagers.LeaveChannel(uint(ti_5.text))
					break;
				case "btn_test4": 
					ZweiteHorizont.MessageChannelManagers.CloseChannel(uint(ti_5.text), ti_1.text, ti_9.text)
					break;
				case "btn_test5": 
					var m:Message = new Message
					m.message_type = ti_6.text
					m.message_date = DateTimeUtils.getDateTime()
					m.message_content = ti_8.text
					
					ZweiteHorizont.MessageChannelManagers.SendMessage(m, uint(ti_5.text))
					break;
				case "btn_test6": 
					MusicManager.load(new Music("School Days", "Music/test/1.mp3", "Angel Beats", "Angel Beats! Original Soundtrack", "Music/test/1.jpg", 0))
					MusicManager.play()
					break;
				case "btn_test7": 
					MusicManager.load(new Music("Girl's Hop", "Music/test/2.mp3", "Angel Beats", "Angel Beats! Original Soundtrack", "Music/test/1.jpg", 0))
					MusicManager.play()
					//	ApplicationManager.openAssestApplication("assest/IOSYS_tohootomebayashi_loving.swf", "IOSYS_tohootomebayashi_loving", "IOSYS_tohootomebayashi_loving");
					break;
				case "btn_test8": 
					MusicWidgetManager.hideWidget(int(ti_1.text))
					//	ApplicationManager.openAssestApplication("assest/321.swf", "患部で止まってすぐ溶ける～狂気の優曇華院", "患部で止まってすぐ溶ける～狂気の優曇華院");
					break;
				case "btn_test9": 
					Cc.log(SystemManager.systemLog)
					break
				default: 
					break;
			}
		}
		
		private function responderFault(e:*)
		{
			var tx_test:String = "";
			tx_test += "函数调用失败";
			tx_test += "code:" + e["code"] + "\n";
			tx_test += "details:" + e["details"] + "\n";
			tx_test += "lever:" + e["lever"] + "\n";
			tx_test += "line:" + e["line"] + "\n";
			tx_test += "description:" + e["description"] + "\n";
			tx_test += "End of Fault Report";
			Cc.error(tx_test);
		}
		
		private function onResult(e:Object):void
		{
			trace("/**********");
			trace(e);
			for (var i:Object in e)
			{
				trace(i + ":" + e[i]);
				for (var k:Object in e[i])
				{
					trace(k + ":" + e[i][k]);
				}
			}
			trace("**********/");
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
		
		public function dispose()
		{
		}
		
		private function set changeInfo(t:String)
		{
			this.tx_info.text = t;
		}
	}
}