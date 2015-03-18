package com.lizeqiangd.zweisystem.applications.Weibo.Authorization
{
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.system.applications.message.Message;
	import flash.html.HTMLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.zweisystem.managers.ApplicationManager;
	
	public class AirAuthorization extends TitleWindows implements iApplication
	{
		
		private var _html:HTMLLoader;
		private var _duty:Boolean = false;
		
		public function AirAuthorization()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - 新浪微博授权 -(for air)";
			this.setApplicationName = "SinaAuthorForAir";
			addUiListener();
		}
		
		public function init(e:ApplicationEvent)
		{			
			var url:String = "https://api.weibo.com/oauth2/authorize";
			url += "?client_id=" + SinaMicroBlogManager.consumerKey;
			url += "&response_type=token";
			url += "&display=flash";
			if (HTMLLoader.isSupported)
			{
				_html = new HTMLLoader();
				_html.addEventListener(Event.LOCATION_CHANGE, onLocationChange);
				_html.width = 800;
				_html.height = 420;
				_html.y = 20;
				_html.load(new URLRequest(url));
				removeChild(tx_info);
				addChild(_html);
			}
			else
			{
				tx_info.text = "不支持此授权方式，请关闭。";
			}
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function addUiListener()
		{
			
			addEventListener(ApplicationEvent.INIT, init);
			addEventListener(ApplicationEvent.CLOSE, applicationClose);
		}
		
		private function removeUiListener()
		{
			_html.removeEventListener(Event.LOCATION_CHANGE, onLocationChange);
			removeEventListener(ApplicationEvent.INIT, init);
			removeEventListener(ApplicationEvent.CLOSE, applicationClose);
		}
		
		protected function onLocationChange(event:Event):void
		{
			var lc:String = _html.location;
			//授权成功的情况： 
			var o:Object = new Object;
			var arr:Array = String(lc.split("#")[1]).split("&");
			var access_token:String = "";
			var expires_in:String = "";
			var remind_in:String = "";
			var uid:String = "";
			var error:String = "";
			var error_description:String = "";
			
			for (var i:int = 0; i < arr.length; i++)
			{
				var str:String = arr[i];
				if (str.indexOf("access_token=") >= 0)
				{
					access_token = str.split("=")[1];
					
				}
				if (str.indexOf("expires_in=") >= 0)
				{
					expires_in = str.split("=")[1];
				}
				if (str.indexOf("remind_in=") >= 0)
				{
					remind_in = str.split("=")[1];
				}
				if (str.indexOf("uid=") >= 0)
				{
					uid = str.split("=")[1];
				}
				if (str.indexOf("error=") >= 0)
				{
					error = str.split("=")[1];
				}
				if (str.indexOf("error_description=") >= 0)
				{
					error_description = str.split("=")[1];
				}
			}
			/*var result:String = "-- access_token: " + access_token + "\n";
			   result +=  "-- expires_in: " + expires_in + "\n";
			   result +=  "-- remind_in: " + remind_in + "\n";
			   result +=  "-- uid: " + uid + "\n";
			   result +=  "-- error: " + error + "\n";
			   result +=  "-- error_description: " + error_description + "\n";
			   trace("***");
			   trace(lc);
			   trace("***");
			   trace(arr);
			 trace("***");*/
			trace("-- access_token: " + access_token);
			if (error != "")
			{
				//说明登陆失败
				_html.removeEventListener(Event.LOCATION_CHANGE, onLocationChange);
				removeChild(_html);
				
				addChild(tx_info);
				//	SinaMicroBlogManager.loginWithTokenAndUid(access_token,uid);
				tx_info.text = "授权失败";
				//	this.CloseApplication();
				o.type = "author_error_close";
				o.error = error;
				o.error_description = error_description;
				ApplicationManager.Application("SinaWeiboController").applicationMessage(o);
				this.CloseApplication();
			}
			if (access_token != "")
			{
				//说明登陆成功;
				_html.removeEventListener(Event.LOCATION_CHANGE, onLocationChange);
				removeChild(_html);
				addChild(tx_info);
				SinaMicroBlogManager.loginWithTokenAndUid(access_token, uid);
				tx_info.text = "授权成功";
				o.type = "author_success_close";
				o.uid = uid;
				o.remind_in = remind_in;
				o.expires_in = expires_in;
				o.access_token = access_token;
				ApplicationManager.Application("SinaWeiboMainController").applicationMessage(o);
				this.CloseApplication();
			}
		}
		
		private function applicationClose(e:ApplicationEvent)
		{
			var o:Object = new Object;
			o.type = "author_close";
			try
			{
				ApplicationManager.Application("SinaWeiboMainController").applicationMessage(o);
			}
			catch (e:*)
			{
				Message.SinaWeiboAuthorizationError("宿主程序[SinaWeiboMainController]不存在，新浪微博授权[Air模式]失败")
			}
			removeUiListener();
			_html = null;
		
		}
		
		public function dispose()
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object)
		{
		}
	
	}

}