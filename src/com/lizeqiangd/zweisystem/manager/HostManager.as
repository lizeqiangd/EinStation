package com.lizeqiangd.zweisystem.manager
{
	import com.lizeqiangd.zweisystem.system.config.ESSetting;
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import com.lizeqiangd.zweisystem.data.advertisement.Advertisement;
	import com.lizeqiangd.zweisystem.data.application.ApplicationExplorer;
	import com.lizeqiangd.zweisystem.data.image.Image;
	import com.lizeqiangd.zweisystem.net.AMFPHP;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.events.LoaderEvent;
	
	import com.junkbyte.console.Cc;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * HostManager用于储存网站基本配置信息。给其他网站应用的基本配置带来便利。
	 * 2013.06.30 重做HostManager，所有信息还是移交给外部管理器。
	 * 2013.09.07 重做HostManager，所有设置全部在数据库上记录。
	 * 2014.04.05 重做HostManger,删除无用功能,更改引用和注释.同时逻辑修复.
	 */
	public class HostManager
	{
		///services url
		private static var url_blog:String = "http://acgs.me/"
		private static var url_host:String = "http://einstation.sinaapp.com/"
		private static var url_amphp:String = HOST_URL + "amfphp/index.php";
		private static var url_upload:String = HOST_URL + "UploadFile/upload.php";
		private static var url_fms:String = "rtmp://121.199.41.110/ZweiteHorizont";
		private static var token_fms:String = "ZweiteHorizont"
		
		///information setting
		private static var background_image:Image
		private static var advertisement:Advertisement
		
		///loader Setting
		private static var _loaderQueue:LoaderMax;
		private static var _loaderApplications:XMLLoader;
		
		///user data
		public static var USER_IP:String = "";
		
		///system
		private static var system_available:Boolean = true
		
		///hostmanager private 
		private static var max_config:uint = 7
		private static var now_loaded:uint = 0
		private static var _okFunc:Function
		
		///方式连接时间上冲突导致崩溃
		private static var AmfphpConnectDelayTimer:Timer
		
		/**
		 * 初始化应用程序,系统设置会从服务器获取,而amfphp连接在这里输入.同时输入程序目录xml的地址.以及下一步操作的方法.
		 * 当app输入为"none"的时候处理.
		 * @param	amfphp_url
		 * @param	url_applications
		 * @param	okFunction
		 */
		public static function init(amfphp_url:String, url_applications:String, okFunction:Function = null):void
		{
			AddOnManager.initLoaderMax()
			url_amphp = amfphp_url
			AMFPHP.init(HostManager.AMFPHP_URL);
			if (null == okFunction)
			{
				_okFunc = null
			}
			else
			{
				_okFunc = okFunction
			}
			AmfphpConnectDelayTimer = new Timer(ESSetting.HostManagerAmfphpLoadTime, 1)
			AmfphpConnectDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAMFPHPConnectDelay)
			AmfphpConnectDelayTimer.start()
			if (url_applications == "none")
			{
				now_loaded++
			}
			else
			{
				_loaderQueue = new LoaderMax({name: "HostManagerLoaderQueue", onComplete: onLoadComplete});
				_loaderApplications = new XMLLoader(url_applications, {name: "Applications", estimatedBytes: 2000});
				_loaderQueue.append(_loaderApplications);
				_loaderQueue.load();
			}
			Cc.log("HostManager.loadApplications address:" + url_applications);
		
		}
		
		///加载完应用程序目录xml后交给ApplicationExplorer
		private static function onLoadComplete(e:LoaderEvent):void
		{
			ApplicationExplorer.init(_loaderQueue.getContent("Applications"));
			++now_loaded == max_config ? dispose() : null;
		}
		
		static private function onAMFPHPConnectDelay(e:TimerEvent):void
		{
			SystemConfig.getSystemConfig("BackgroundImage", onSystemConfigLoaded)
			SystemConfig.getSystemConfig("Advertisement", onSystemConfigLoaded)
			SystemConfig.getSystemConfig("FMSServerAddress", onSystemConfigLoaded)
			SystemConfig.getSystemConfig("BlogAddress", onSystemConfigLoaded)
			SystemConfig.getSystemConfig("HostAddress", onSystemConfigLoaded)
			SystemConfig.getSystemConfig("SystemAvailable", onSystemConfigLoaded)
		}
		
		static private function onSystemConfigLoaded(e:Object):void
		{
			switch (e.name)
			{
				case "BackgroundImage": 
					var bgm:Object = JSON.parse(e.value);
					background_image = new Image;
					background_image.url = bgm.url;
					background_image.description = bgm.description;
					break;
				case "Advertisement": 
					var ad:Object = JSON.parse(e.value)
					advertisement = new Advertisement;
					advertisement.url = ad.Address;
					advertisement.description = ad.Description;
					var img:Image = new Image();
					img.url = ad.ImageAddress;
					advertisement.image = img;
					break;
				case "FMSServerAddress": 
					url_fms = e.value;
					break;
				case "BlogAddress": 
					url_blog = e.value;
					break;
				case "HostAddress": 
					url_host = e.value;
					break;
				case "SystemAvailable": 
					system_available = Boolean(e.value == "1");
					break;
			}
			++now_loaded == max_config ? dispose() : null;
		}
		
		public static function get BLOG_URL():String
		{
			return url_blog
		}
		
		public static function get HOST_URL():String
		{
			return url_host
		}
		
		public static function get AMFPHP_URL():String
		{
			return url_amphp
		}
		
		public static function get UPLOAD_URL():String
		{
			return url_upload
		}
		
		public static function get FMS_URL():String
		{
			return url_fms
		}
		
		public static function get FMS_TOKEN():String
		{
			return token_fms
		}
		
		public static function get BACKGROUND_IMAGE():Image
		{
			return background_image
		}
		
		public static function get ADVERTISEMENT():Advertisement
		{
			return advertisement
		}
		
		public static function get SYSTEM_AVAILABLE():Boolean
		{
			return system_available
		}
		
		/**
		 * 销毁本类中的实例部分.同时进行下一步.
		 */
		private static function dispose():void
		{
			AmfphpConnectDelayTimer.stop();
			AmfphpConnectDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onAMFPHPConnectDelay);
			AmfphpConnectDelayTimer = null;
			try
			{
				_loaderApplications.dispose();
				_loaderApplications = null;
				_loaderQueue.dispose();
				_loaderQueue = null;
			}
			catch (e:*)
			{
			}
			null !== _okFunc?_okFunc():null
		}
	}
}