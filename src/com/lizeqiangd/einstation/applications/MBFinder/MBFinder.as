package com.lizeqiangd.einstation.applications.MBFinder
{
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.SystemManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.applications.zweitehorizontwidget.ZweiteHorizontService;
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweitehorizont.data.object.User;
	import com.lizeqiangd.zweitehorizont.events.UserEvent;
	import com.lizeqiangd.zweitehorizont.system.ClientUtils;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.desktop.SystemTrayIcon;
	import flash.display.BitmapData;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ScreenMouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import net.nshen.nfms.FMSEvent;
	
	/**
	 * @author Lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 * 1.0开始
	 * 1.1增加拖动,提示,登陆
	 * 1.2优化登陆,修复提示,发布苹果版本
	 * 1.3bug修复
	 */
	
	public class MBFinder extends TitleWindows implements iApplication
	{
		private var applicationTitle:String = "MB在不在 1.3"
		
		public function MBFinder()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = applicationTitle;
			this.setApplicationName = "MBFinder";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			this.y = 1
		}
		private var mb_exist:BitmapData
		private var mb_not_exist:BitmapData
		
		public function init(e:ApplicationEvent)
		{
			
			cb_bishi.title = "bishi"
			cb_chiyue.title = "赤月"
			cb_other.title = "木木"
			cb_mb.title = "MB在房间"
			tx_content.text = ""
			sp_login.la_title.title = applicationTitle
			TextField(tx_content).type = TextFieldType.DYNAMIC
			
			this.setDragEnable = false
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
			
			trace("NativeApplication.supportsDockIcon", NativeApplication.supportsDockIcon)
			trace("NativeApplication.supportsSystemTrayIcon:", NativeApplication.supportsSystemTrayIcon)
			var sp:Sprite = new Sprite
			var txmb:TextField = new TextField()
			if (NativeApplication.supportsDockIcon)
			{
				mb_exist = new BitmapData(64, 64, true, 0)
				mb_not_exist = new BitmapData(64, 64, true, 0)
				sp.graphics.beginFill(0x33FF00)
				sp.graphics.drawCircle(32, 32, 32)
				sp.graphics.endFill()
				txmb.defaultTextFormat.size = 25
				txmb.text = "mb"
				txmb.x = txmb.y = 0
				sp.addChild(txmb)
				
				mb_exist.draw(sp)
				sp.graphics.clear()
				sp.graphics.beginFill(0x3399ff)
				sp.graphics.drawCircle(16, 16, 16)
				sp.graphics.endFill()
				mb_not_exist.draw(sp)
				NativeApplication.nativeApplication.icon.bitmaps = [mb_not_exist]
					//DockIcon(NativeApplication.nativeApplication.icon).addEventListener(ScreenMouseEvent.CLICK, onDockClick)
			}
			if (NativeApplication.supportsSystemTrayIcon)
			{
				mb_exist = new BitmapData(16, 16, true, 0)
				mb_not_exist = new BitmapData(16, 16, true, 0)
				sp.graphics.beginFill(0x33FF00)
				sp.graphics.drawCircle(08, 08, 8)
				sp.graphics.endFill()
				txmb.text = "mb"
				txmb.x = -1
				txmb.y = -2
				sp.addChild(txmb)
				
				mb_exist.draw(sp)
				sp.graphics.clear()
				sp.graphics.beginFill(0x3399ff)
				sp.graphics.drawCircle(08, 08, 8)
				sp.graphics.endFill()
				mb_not_exist.draw(sp)
				SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = applicationTitle
				NativeApplication.nativeApplication.icon.bitmaps = [mb_not_exist]
				SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(ScreenMouseEvent.CLICK, onDockClick)
			}
			if (SystemConfig.getLocalConfig("mbfinder_userinfo"))
			{
				sp_login.tx_username.text = SystemConfig.getLocalConfig("mbfinder_userinfo").user
				sp_login.tx_password.text = SystemConfig.getLocalConfig("mbfinder_userinfo").psw
			}
			else
			{
				SystemConfig.setLocalConfig("mbfinder_userinfo", {user: "", pws: ""})
			}
			
			cb_bishi.enable = false
			cb_chiyue.enable = false
			cb_other.enable = false
			cb_mb.enable = false
			
			NativeApplication.nativeApplication.activeWindow.x = 1920 - 230 - 2
			NativeApplication.nativeApplication.activeWindow.y = 2 + 25
		}
		
		private function addApplicationListener()
		{
			sp_login.btn_login.addEventListener(UnitEvent.CLICK, onLoginClick)
			
			cb_bishi.addEventListener(UnitEvent.CLICK, onCBClick)
			cb_chiyue.addEventListener(UnitEvent.CLICK, onCBClick)
			cb_other.addEventListener(UnitEvent.CLICK, onCBClick)
			cb_mb.addEventListener(UnitEvent.SELECTED, onCBClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			ZweiteHorizont.FMSProxys.addEventListener("CommunicationManagerReceiveMessage", onReceiveMessage)
			this.mc_title.addEventListener(MouseEvent.MOUSE_DOWN, onApplicatoinMouseDown)
			ZweiteHorizont.UserManagers.addUserEventListener(UserEvent.USER_ONLINE, onUserUpdate)
		}
		
		private function onDockClick(e:ScreenMouseEvent):void
		{
			NativeApplication.nativeApplication.activate(StageProxy.stage.nativeWindow)
		}
		
		private function onApplicatoinMouseDown(e:MouseEvent):void
		{
			StageProxy.stage.nativeWindow.startMove()
		}
		
		private function onUserUpdate(e:UserEvent):void
		{
			if (isAdmin)
			{trace(e.data.cid)
				var object_message:Object = {receiver: {type: "cid", content: "mbfinder"}, information: {creator_uid: 0, create_date: new Date().toUTCString()}, content: message_content}
				ZweiteHorizont.FMSProxys.dispatch("CommunicationManagerSendMessage", object_message)
			}
		}
		private var pwd:String = "bilibili0516"
		private var isAdmin:Boolean = false
		
		private function onLoginClick(e:UnitEvent):void
		{
			var o:User = new User
			o.cid = ClientUtils.getClientCid
			o.uid = 0
			o.description = "mbfinder_user"
			o.display_name = sp_login.tx_username.text ? sp_login.tx_username.text : "guest" + ClientUtils.getClientCid
			o.user_type = "mbfinder"
			trace(sp_login.tx_username.text)
			switch (sp_login.tx_username.text)
			{
				case "Lizeqiangd": 
					if (sp_login.tx_password.text == pwd)
					{
						cb_bishi.enable = true
						cb_chiyue.enable = true
						cb_other.enable = true
						cb_mb.enable = true
						TextField(tx_content).type = TextFieldType.INPUT
						ZweiteHorizont.UserManagers.updateUserInformation(o)
						AnimationManager.fade_out(sp_login)
						isAdmin = true
					}
					else
					{
						Message.LoginFailed("密码错误")
					}
					break;
				case "aristotle9": 
				case "A9": 
				case "a9": 
					if (sp_login.tx_password.text == pwd)
					{
						cb_bishi.enable = true
						cb_chiyue.enable = true
						cb_other.enable = true
						cb_mb.enable = true
						TextField(tx_content).type = TextFieldType.INPUT
						ZweiteHorizont.UserManagers.updateUserInformation(o)
						AnimationManager.fade_out(sp_login)
						isAdmin = true
					}
					else
					{
						Message.LoginFailed("密码错误")
					}
					break
				default: 
					ZweiteHorizont.UserManagers.updateUserInformation(o)
					AnimationManager.fade_out(sp_login)
			}
			SystemConfig.setLocalConfig("mbfinder_userinfo", {user: sp_login.tx_username.text, psw: sp_login.tx_password.text})
			sp_login.tx_username.text = o.display_name
		}
		
		private function onReceiveMessage(e:FMSEvent)
		{
			if (e.data2.content.type == messageType)
			{
				tx_content.text = e.data2.content.message
				cb_bishi.selected = e.data2.content.bishi == "1" ? true : false
				cb_chiyue.selected = e.data2.content.chiyue == "1" ? true : false
				cb_other.selected = e.data2.content.other == "1" ? true : false
				cb_mb.selected = e.data2.content.mb == "1" ? true : false
			}
			if (cb_mb.selected && cb_notify.selected)
			{
				NativeApplication.nativeApplication.activate(StageProxy.stage.nativeWindow)
				Message.SystemMessage("前方线报:MB已经回来了哦~", true)
			}
			if (NativeApplication.supportsSystemTrayIcon)
			{
				SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = cb_mb.selected ? "mb在办公室" : "mb不在办公室"
				NativeApplication.nativeApplication.icon.bitmaps = cb_mb.selected ? [mb_exist] : [mb_not_exist]
			}
			if (NativeApplication.supportsDockIcon)
			{
				NativeApplication.nativeApplication.icon.bitmaps = cb_mb.selected ? [mb_exist] : [mb_not_exist]
				if (cb_notify.selected && cb_mb.selected)
				{
					DockIcon(NativeApplication.nativeApplication.icon).bounce(NotificationType.CRITICAL)
				}				
				else
				{
					DockIcon(NativeApplication.nativeApplication.icon).bounce(NotificationType.INFORMATIONAL)
				}
			}
		
		}
		/*
		   private function onReceiveMessage(e:FMSEvent):void
		   {
		   trace("mb:", e.data2.content.mb)
		   trace("bishi:", e.data2.content.bishi)
		   trace("chiyue:", e.data2.content.chiyue)
		   trace("other:", e.data2.content.other)
		   trace("message:", e.data2.content.message)
		 }*/
		private var message_content:Object = {}
		private var messageType:String = "mbfinder1"
		
		private function onCBClick(e:UnitEvent):void
		{
			message_content.type = messageType
			switch (e.target)
			{
				case cb_bishi: 
					break;
				case cb_chiyue: 
					break;
				case cb_other: 
					break;
				case cb_mb: 
					break;
				default: 
			}
			message_content.bishi = cb_bishi.selected ? "1" : "0"
			message_content.chiyue = cb_chiyue.selected ? "1" : "0"
			message_content.other = cb_other.selected ? "1" : "0"
			message_content.mb = cb_mb.selected ? "1" : "0"
			message_content.message = tx_content.text + ""
			
			var object_message:Object = {receiver: {type: "all", content: "mbfinder"}, information: {creator_uid: 0, create_date: new Date().toUTCString()}, content: message_content //content
				}
			ZweiteHorizont.FMSProxys.dispatch("CommunicationManagerSendMessage", object_message)
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeApplicationListener();
			addEventListener(ApplicationEvent.CLOSED, onfinalClose)
		}
		
		private function onfinalClose(e:ApplicationEvent):void
		{
			NativeApplication.nativeApplication.exit()
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