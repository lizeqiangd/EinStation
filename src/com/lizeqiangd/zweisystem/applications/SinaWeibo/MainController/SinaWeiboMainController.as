package com.lizeqiangd.zweisystem.applications.SinaWeibo.MainController
{
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.interfaces.scrollbar.ScrollBar;
	import com.zweisystem.managers.HostManager;
	import com.zweisystem.modules.notification.SystemStatusNotification;
	import com.zweisystem.system.applications.message.Message;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.zweisystem.managers.ApplicationManager;
	import flash.text.TextField;
	
	public class SinaWeiboMainController extends TitleWindows implements iApplication
	{
		public var tx_output:TextField;
		public var mc_MCP:MainControlPanel;
		public var btn_scrollbar:ScrollBar;
		
		private var ssn:SystemStatusNotification		
		public function SinaWeiboMainController()
		{
			mc_MCP.visible = false;
			btn_scrollbar.visible = false;
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "新浪微博总控端";
			this.setApplicationName = "SinaWeiboMainController";
			this.setApplicationVersion = "2.0";
			addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent)
		{
			SinaMicroBlogManager.init();
			
			ssn = new SystemStatusNotification;
			
			mc_MCP.init();
			mc_btn1.title = "登陆微博";
			mc_btn2.title = "测试";
			mc_btn3.title = "主控制台";
			mc_btn3.enable = SinaMicroBlogManager.isLogined;
			tx_output.text = "";
			ssn.init(0, 20, 300, 180);
			
			addChild(ssn);
			addUiListener();
			addInfo("微博初始化完成");
			btn_scrollbar.visible = true;
			btn_scrollbar.initText(tx_output, 140);
			mc_btn2.enable = false
			btn_close.visible=false
			dispatchEvent (new ApplicationEvent (ApplicationEvent.INITED))	}
		
		private function addUiListener()
		{
			SinaMicroBlogManager.addEventListener("loginOnWeb", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("loginWithTokenAndUid", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("UploadStatus", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("UserShow", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("CommentsCreate", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("CommentsToMe", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("UpdateStatus", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("Repost", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("GetUid", onWeiboHandle);
			SinaMicroBlogManager.addEventListener("FriendsTimeline", onWeiboHandle);
			mc_btn1.addEventListener(UnitEvent.CLICK, onLoginClick);
			mc_btn2.addEventListener(UnitEvent.CLICK, onDebug);
			mc_btn3.addEventListener(UnitEvent.CLICK, onMainControl);
			addEventListener(ApplicationEvent.CLOSE, applicationClose);
		
		}
		
		private function removeUiListener()
		{
			SinaMicroBlogManager.removeEventListener("loginOnWeb", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("loginWithTokenAndUid", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("UploadStatus", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("UserShow", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("CommentsCreate", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("CommentsToMe", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("UpdateStatus", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("GetUid", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("Repost", onWeiboHandle);
			SinaMicroBlogManager.removeEventListener("FriendsTimeline", onWeiboHandle);
			mc_btn1.removeEventListener(UnitEvent.CLICK, onLoginClick);
			mc_btn2.removeEventListener(UnitEvent.CLICK, onDebug);
			mc_btn3.removeEventListener(UnitEvent.CLICK, onMainControl);
			removeEventListener(ApplicationEvent.INIT, init);
			removeEventListener(ApplicationEvent.CLOSE, applicationClose);
		}
		
		private function applicationClose(e:ApplicationEvent)
		{
			//trace(MicroBlogEvent.LOGIN_RESULT);
			removeUiListener();
			mc_MCP.dispose();
			SinaMicroBlogManager.dispose();
			try
			{
				ApplicationManager.Application("WeiboPublisher").applicationMessage("app_close");
			}
			catch (e:*)
			{
			}
		}
		
		public function applicationMessage(e:Object)
		{
			switch (e.type)
			{
				case "message": 
					addInfo(e.message, e.messageType);
					break;
				case "author_success_close": 
					addInfo("微博授权成功", 4);
					ssn.clean();
					break;
				case "author_error_close": 
					addInfo("微博授权失败", 2);
					addInfo("Error:" + e.error, 3);
					addInfo("ErrorDescription" + e.error_description, 3);
					mc_btn2.enable = true;
					ssn.clean();
					break;
				case "author_close": 
					addInfo("微博授权页面被关闭", 4);
					ssn.clean();
					break;
				case "hide": 
					this.visible = false
					//AnimationManager.fade_out(this)
					break;
				case "show": 
					this.visible = true
					//AnimationManager.fade_in(this)
					break;
				default: 
					break;
			}
		
		} //**************微博响应部分*********************
		
		private function onWeiboHandle(e:MicroBlogEvent)
		{
			trace("SinaWeiboController Report:", e.type);
			switch (e.type)
			{
				case "loginWithTokenAndUid": 
					//air debug
					ssn.clean();
					mc_btn1.enable = false
					mc_btn2.enable = false;
					mc_btn3.enable = SinaMicroBlogManager.isLogined;
					addInfo("Air或Debug模式微博已经登陆", 1);
					SinaMicroBlogManager.ApiUserShow(e.result.uid);
					break;
				case "loginOnWeb": 
					//web
					ssn.clean();
					mc_btn1.enable = false
					mc_btn2.enable = false;
					mc_btn3.enable = SinaMicroBlogManager.isLogined;
					addInfo("Web模式微博已经登陆", 1);
					SinaMicroBlogManager.ApiGetUid();
					break;
				case "GetUid": 
					SinaMicroBlogManager.uid = e.result.uid
					SinaMicroBlogManager.ApiUserShow(Number(SinaMicroBlogManager.uid));
					addInfo("个人uid获取完成", 1);
					break;
				case "UserShow": 
					if (e.result.id == SinaMicroBlogManager.uid)
					{
						//trace("UserShow个人资料信息接收完成");
						mc_MCP.dataProvider = e.result;
						addInfo("个人资料信息接收完成", 1);
					}
					break;
				case "CommentsCreate": 
					break;
				case "UploadStatus": 
					onUpdateStatus();
					addInfo("微博已经连同图发送出去", 1);
					try
					{
						ApplicationManager.Application("WeiboPublisher").applicationMessage("complete")
					}
					catch (e:*)
					{
					}
					;
					break;
				case "CommentsToMe": 
					break;
				case "UpdateStatus": 
					onUpdateStatus();
					addInfo("微博已经发送出去", 1);
					ApplicationManager.Application("WeiboPublisher").applicationMessage("complete");
					break;
				case "Repost": 
					break;
				case "FriendsTimeline": 
					addInfo("Timeline已經更新", 1);
					break;
				default: 
					trace("新浪微博未知错误");
					break;
			}
		}
		
		private function onUpdateStatus()
		{
			Message.SinaWeiboPublishOk()
		}
		
		public function addInfo(t:String, code:int = -1)
		{
			var preText:String = "";
			switch (code)
			{
				case 0: 
					preText = "提示：";
					break;
				case 1: 
					preText = "通知：";
					break;
				case 2: 
					preText = "警告：";
					break;
				case 3: 
					preText = "错误：";
					break;
				case 4: 
					preText = "系统提示：";
					break;
				default: 
					preText = "";
					break;
			}
			tx_output.text = preText + t + "\n" + tx_output.text;
			//mc_ScrollBar.refresh();
		}
		
		public function dispose()
		{
		}
		
		private function onMainControl(e:UnitEvent)
		{
			if (!mc_MCP.visible)
			{
				AnimationManager.fade_in(mc_MCP);
			}
			else
			{
				AnimationManager.fade_out(mc_MCP);
			}
		}
		
		private function onLoginClick(e:UnitEvent):void
		{
			addInfo("微博开始准备授权", 4);
			if (HostManager.USER_IP == "localhost")
			{
				ApplicationManager.open("SinaWeibo.Authorization.AirAuthorization");
			}
			else
			{
				SinaMicroBlogManager.login()
			}
			ssn.anime("state.Pleasewait","等待授权中");
		}
		
		private function onDebug(e:UnitEvent)
		{
			SinaMicroBlogManager.debugMode()
			addInfo("Debug模式，已经输入accessToken", 1);
			mc_btn2.enable = false;
		}
	
	}
}