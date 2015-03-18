package com.lizeqiangd.zweisystem.system.applications.zweitehorizontwidget
{
	import com.lizeqiangd.zweisystem.abstract.windows.DragWindows;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.data.application.ApplicationConfig;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.manager.HostManager;
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.system.applications.background.BackgroundManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.applications.navigation.NavigationManager;
	import com.lizeqiangd.zweisystem.system.applications.title.TitleManager;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweitehorizont.system.ClientUtils;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import net.nshen.nfms.FMSEvent;
	
	/**
	 * 这里是所有远程遥控的接收端。作为后台使用
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * 2013.02.26 开始策划
	 * 2013.06.14 整合ZweiteHorizont
	 */
	public class ZweiteHorizontService
	{
		private static var inited:Boolean = false
		private static var zhw:ZweiteHorizontWidget
		
		public static function init(show_widget:Boolean = false)
		{
			if (inited)
			{
				return
			}
			inited = true
			
			ZweiteHorizont.ServerAddress = HostManager.FMS_URL
			ZweiteHorizont.ApplicationToken = HostManager.FMS_TOKEN
			ZweiteHorizont.init()
			
			ZweiteHorizont.FMSProxys.addEventListener("EinStationEditBackgroundImage", EditBackgroundImage)
			ZweiteHorizont.FMSProxys.addEventListener("EinStationEditTitle", EditTitle)
			ZweiteHorizont.FMSProxys.addEventListener("EinStationEditApplicationBackground", EditApplicationBackground)
			ZweiteHorizont.FMSProxys.addEventListener("EinStationBoardcastMessage", BoardcastMessage)
			ZweiteHorizont.FMSProxys.addEventListener("EinStationShutdownSystem", ShutdownSystem)
			ZweiteHorizont.FMSProxys.addEventListener("EinStationRecoverSystem", RecoverSystem)
			ZweiteHorizont.FMSProxys.addEventListener("CommunicationSendMessage", ReceiveMessage)
			
			zhw = LayerManager.createPopUp(ZweiteHorizontWidget)
			zhw.applicationMessage({type: 1, content: "ZweiteHorizont"})
			onResize()
			StageProxy.addResizeFunction(onResize)
			show_widget ? showWidget() : hideWidget()
		
		}
		
		/**
		 * 修改用户信息并同步到服务器
		 * @param	_username
		 * @param	_usertype
		 * @param	_description
		 */
		public static function setZweiteHorizontUserInformation(_username:String = "guest", _usertype:String = "guest", _description:String = "")
		{
			zhw.applicationMessage({type: "changeusername", user_type: _usertype, display_name: _username, description: _description})
		}
		
		/**
		 * 快捷方法获得用户Cid
		 * @return
		 */
		public static function get getZweiteHorizontUserCid():uint
		{
			return ClientUtils.getClientCid
		}
		
		/**
		 * 显示Widget
		 */
		public static function showWidget()
		{
			zhw.visible = true
		}
		
		/**
		 * 隐藏Widget
		 */
		public static function hideWidget()
		{
			zhw.visible = false
		}
		
		/**
		 * 返回Widget实例
		 */
		public static function get ZweiteHorizontWidgets():ZweiteHorizontWidget
		{
			return zhw
		}
		
		static private function onResize():void
		{
			if (inited)
			{
				PositionUtility.setDisplayPosition(zhw, "TL")
			}
		}
		
		private static function EditBackgroundImage(e:FMSEvent)
		{
			BackgroundManager.remote(e.data2.url, e.data2.description)
		}
		
		private static function EditTitle(e:FMSEvent)
		{
			TitleManager.MainTitle = e.data2.title
		}
		
		private static function EditApplicationBackground(e:FMSEvent)
		{
			var arr:Vector.<ApplicationConfig> = ApplicationManager.getApplicationArray
			for (var i:int = 0; i < arr.length; i++)
			{
				if (arr[i].self is DragWindows)
				{
					DragWindows(arr[i].self).setBgAlpha = e.data2.alpha
				}
			}
		}
		
		private static function BoardcastMessage(e:FMSEvent)
		{
			var s:String = "来自" + e.data2.user_name + "的全域广播: " + e.data2.message
			Message.BoardcastMessage(s)
		}
		
		private static function ShutdownSystem(e:FMSEvent)
		{
			var s:String = "现有的全系统已经被锁定，操作者：" + e.data2.user_name + " 原因为:" + e.data2.message
			Message.BoardcastMessage(s)
			if (!LoginManager.isAdministrator)
			{
				AnimationManager.MaskInStage(0.8)
				NavigationManager.enableNavigation(false)
			}
		
		}
		
		private static function RecoverSystem(e:FMSEvent)
		{
			AnimationManager.MaskOutStage()
			var s:String = "系统锁定已经被恢复，操作者：" + e.data2.user_name + " 原因为:" + e.data2.message
			Message.BoardcastMessage(s)
			NavigationManager.enableNavigation(true)
		}
		
		private static function ReceiveMessage(e:FMSEvent)
		{
			Message.BoardcastMessage(e.data2.message)
		}
	
	}

}