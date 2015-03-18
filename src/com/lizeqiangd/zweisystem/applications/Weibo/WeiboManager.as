package com.lizeqiangd.zweisystem.applications.Weibo
{
	import com.lizeqiangd.zweisystem.data.weibo.*;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.config.ESSetting;
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.junkbyte.console.Cc;
	import flash.utils.ByteArray;
	/**
	 * 新浪微博授权机,封装flashache的weibo sdk.同时自动化管理.可随时增加需要功能.必要功能已经封装完成.
	 * update :
	 * 2014.06.26 更新全部注释,优化逻辑.
	 */
	public class WeiboManager
	{
		private static var _mb:MicroBlog = new MicroBlog();
		private static var _userDataCache:SinaWeiboUserData;
		private static var _uid:String = "";
		private static var inited:Boolean = false		
		private static var isLogin:Boolean = false;
		/**
		 * 初始化微博封装管理.需要实现输入用户的应用key
		 */
		public static function init()
		{
			if (inited)
			{
				return
			}
			inited = true
			_mb.consumerKey = ESSetting.SinaWeiboConsumerKey
			_mb.consumerSecret = ESSetting.SinaWeiboConsumerSecret;
			addWeiboListener();
			Cc.log("SinaWeiboManager:inited complete")
		}
		
		///对微博实例增加侦听器
		public static function addEventListener(type:String, func:Function, userCapture:Boolean = false, priority:int = 0, userWeakReference:Boolean = false)
		{
			_mb.addEventListener(type, func, userCapture, priority, userWeakReference);
		}
		
		///对微博实例移除侦听器
		public static function removeEventListener(type:String, func:Function)
		{
			_mb.removeEventListener(type, func);
		}
		
		///默认添加的微博侦听.
		private static function addWeiboListener()
		{
			_mb.addEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
			_mb.addEventListener(MicroBlogErrorEvent.LOGIN_ERROR, onLoginError);
			_mb.addEventListener("UserShow", onGetUserData);
			_mb.addEventListener("GetUid", onGetUid);
			_mb.addEventListener("onWeiboApiRequestError", onWeiboApiRequestErrorHangle);
		}
		
		///默认在销毁的时候移除...(有销毁的机会么?)
		private static function removeWeiboListener()
		{
			_mb.removeEventListener("onWeiboApiRequestError", onWeiboApiRequestErrorHangle);
		}
		
		///登陆失败的时候会进行反馈信息.
		private static function onLoginError(e:MicroBlogErrorEvent)
		{
			_mb.removeEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
			_mb.removeEventListener(MicroBlogErrorEvent.LOGIN_ERROR, onLoginError);
			Cc.log("SinaWeiboManager:onLoginError", e.message)
		}
		
		/******************************
		 * debug模式用于实现输入key
		 */
		public static function debugMode()
		{                   
			loginWithToken("2.00d7nVtB0swsN_e7913098a20YtrM_")
		}
		
		/********************************************
		 * 开始登陆微博,并且弹出网页.(local connection类)
		 */
		public static function login()
		{
			//普通web版本授权模式
			_mb.proxyURI = ESSetting.SinaWeiboProxyPHP
			_mb.login();
			Cc.log("SinaWeiboManager:start web auth")
		}
		
		/**************************************
		 * 通过直接输入token直接强行当作登陆.
		 * @param	s token(string)
		 */
		public static function loginWithToken(s:String)
		{
			//air和本地测试强行获得token并输入
			Cc.log("SinaWeiboManager:start direct token auth")
			_mb.access_token = s;
			onLoginResult(null)
			
		}
		
		///网页授权成功后开始后续步骤.
		private static function onLoginResult(e:MicroBlogEvent)
		{
			_mb.removeEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
			_mb.removeEventListener(MicroBlogErrorEvent.LOGIN_ERROR, onLoginError);
			Cc.log("SinaWeiboManager:get token success loading uid")
			ApiGetUid()
		}
		
		///获取用户uid
		private static function onGetUid(e:MicroBlogEvent)
		{
			_mb.removeEventListener("GetUid", onGetUid);
			_uid = e.result.uid
			Cc.log("SinaWeiboManager:get uid success ,loading user data")
			ApiUserShow(_uid)
		}
		
		///获取用户实际情况,登陆过程完成.
		private static function onGetUserData(e:MicroBlogEvent)
		{
			_mb.removeEventListener("UserShow", onGetUserData);
			_userDataCache = null;
			_userDataCache = new SinaWeiboUserData(e.result);
			
			isLogin = true;
			///自创事件...
			var evt:MicroBlogEvent = new MicroBlogEvent(MicroBlogEvent.LOGIN_SUCCESS);
			evt.result = e.result
			_mb.dispatchEvent(evt);
			Cc.log("SinaWeiboManager:get user data success,login complete")
		}
		
		///获取当前用户token
		public static function get getUserAccessToken():String
		{
			return _mb.access_token
		}
		
		///获取当前用户uid
		public static function get getUid():String
		{
			return _uid;
		}
		
		///获取本管理器是否已经登陆成功
		public static function get getIsLogined():Boolean
		{
			return isLogin;
		}
		
		///获取微博实例
		public static function get getWeiboInstance():MicroBlog
		{
			return _mb;
		}
		
		///获取当前用户人物本身信息.
		public static function get getCacheUserData():SinaWeiboUserData
		{
			return _userDataCache;
		}		//主要会用到的api放置区域
		
		/**
		 * 获取用户自身的uid
		 */
		private static function ApiGetUid()
		{
			if (!inited)
			{
				Cc.log("SinaWeiboManager: unable to call apis, not inited")
				return;
			}
			//trace("微博api调用：2/account/get_uid");
			_mb.callWeiboAPI("2/account/get_uid", null, "GET", "GetUid", "onWeiboApiRequestError");
		}
		
		/**
		 * 获取 一定数量 的时间轴,也就是获取你能看到的微博们.
		 * @param	count 需要的数量
		 */
		public static function ApiFriendsTimeline(count:int = 50)
		{
			if (!isLogin)
			{
				Cc.log("SinaWeiboManager: unable to call apis, not inited")
				return;
			}
			var o:Object = new Object();
			o.count = count;
			//trace("微博api调用：2/statuses/friends_timeline");
			_mb.callWeiboAPI("2/statuses/friends_timeline", o, "GET", "FriendsTimeline", "onWeiboApiRequestError");
		}
		
		/**
		 * 转发一个微博.
		 * @param	id 微博id
		 * @param	status 微博内容
		 */
		public static function ApiRepost(id:Number, status:String = "")
		{
			if (!isLogin)
			{
				Cc.log("SinaWeiboManager: unable to call apis, not inited")
				return;
			}
			//trace("微博api调用：2/statuses/repost");
			var o:Object = new Object();
			o.id = id;
			o.status = status;
			_mb.callWeiboAPI("2/statuses/repost", o, "POST", "Repost", "onWeiboApiRequestError");
		}
		
		/**
		 * 发送一条评论
		 * @param	id 原微博id
		 * @param	comment 评论内容
		 */
		public static function ApiCommentsCreate(id:Number, comment:String)
		{
			if (!isLogin)
			{
				Cc.log("SinaWeiboManager: unable to call apis, not inited")
				return;
			}
			//trace("微博api调用：2/statuses/create");
			var o:Object = new Object();
			o.id = id;
			o.comment = comment;
			var api:String = "2/comments/create";
			var methor:String = "POST";
			var eventTyep:String = "CommentsCreate";
			_mb.callWeiboAPI(api, o, methor, eventTyep, "onWeiboApiRequestError");
		}
		
		/**
		 * 发送一条微博. 就信息和需要的经纬度.可造假哦.
		 * @param	status
		 * @param	lat
		 * @param	long
		 */
		public static function ApiUpdateStatus(status:String, lat:Number = 0, long:Number = 0)
		{
			if (!isLogin)
			{
				Cc.log("SinaWeiboManager: unable to call apis, not inited")
				return;
			}
			//trace("微博api调用：2/statuses/update");
			var o:Object = new Object();
			o.status = status;
			o.lat = lat;
			o.long = long;
			_mb.callWeiboAPI("2/statuses/update", o, "POST", "UpdateStatus", "onWeiboApiRequestError");
		}
		
		/**
		 * 发送一条微博,带图片! 和可以造假的经纬度.
		 * @param	status
		 * @param	pic
		 * @param	lat
		 * @param	long
		 */
		public static function ApiUploadStatus(status:String, pic:ByteArray, lat:Number = 0, long:Number = 0)
		{
			if (!isLogin)
			{
				Cc.log("SinaWeiboManager: unable to call apis, not inited")
				return;
			}
			//trace("微博api调用：2/statuses/upload");
			var o:Object = new Object();
			o.status = status;
			o.pic = pic;
			o.lat = lat;
			o.long = long;
			_mb.callWeiboAPI("2/statuses/upload", o, "POST", "UploadStatus", "onWeiboApiRequestError");
		}
		
		/**
		 * 获取用户对自己的评论列表.
		 */
		public static function ApiCommentsToMe(count:int = 50)
		{
			if (!isLogin)
			{
				Cc.log("SinaWeiboManager: unable to call apis, not inited")
				return;
			}
			//trace("微博api调用：2/statuses/to_me");
			var o:Object = new Object();
			o.count = count
			o.page
			o.since_id
			o.max_id
			_mb.callWeiboAPI("2/comments/to_me", o, "GET", "CommentsToMe", "onWeiboApiRequestError");
		}
		
		/**
		 * 获取某个用户的微博列表.
		 * @param	uid
		 * @param	screen_name
		 * @param	count
		 * @param	trim_user
		
		   public static function ApiUserTimeline(uid:* = "", screen_name:String = "", count:int = 20, trim_user:String = "0")
		   {
		   if (!isLogin)
		   {
		   Cc.log("SinaWeiboManager: unable to call apis, not inited")
		   return;
		   }
		   //trace("微博api调用：2/statuses/user_timeline");
		   var o:Object = new Object();
		   if (uid)
		   {
		   o.uid = uid;
		   }
		   if (screen_name)
		   {
		   o.screen_name = screen_name;
		   }
		   o.count = count
		   o.trim_user = trim_user
		   var api:String = "2/statuses/user_timeline";
		   var methor:String = "GET";
		   var eventTyep:String = "UserTimeline";
		   _mb.callWeiboAPI(api, o, methor, eventTyep, "onWeiboApiRequestError");
		   }
		 */
		
		/**
		 * 读取某个用户的信息. 需要uid或者昵称
		 * @param	uid
		 * @param	screen_name
		 */
		public static function ApiUserShow(uid:* = 0, screen_name:String = "")
		{
			if (!inited)
			{
				Cc.log("SinaWeiboManager: unable to call apis, not inited")
				return;
			}
			//trace("微博api调用：2/statuses/show");
			var o:Object = new Object();
			if (uid != 0)
			{
				o.uid = uid;
			}
			if (screen_name != "")
			{
				o.screen_name = screen_name;
			}
			var api:String = "2/users/show";
			var methor:String = "GET";
			var eventTyep:String = "UserShow";
			_mb.callWeiboAPI(api, o, methor, eventTyep, "onWeiboApiRequestError");
		}
		
		///当weibo api 呼叫失败的时候反馈信息至信息框.
		private static function onWeiboApiRequestErrorHangle(e:MicroBlogErrorEvent):void
		{
			Cc.log("SinaWeiboManager:fail to call api:", e.message)
			//Message.SinaWeiboApiError(e.message)
		}
		
		///销毁微博实例,目前来看毫无疑义...没任何机会去销毁.
		public static function dispose()
		{
			//removeWeiboListener();
			//	isLogin = false;
			//	_mb = null;
		}
	}
}