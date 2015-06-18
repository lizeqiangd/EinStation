package com.lizeqiangd.zweisystem.net
{
	import com.lizeqiangd.zweisystem.events.NetEvent;
	import com.junkbyte.console.Cc;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Timer;
	
	/**
	 * ZweiSystem网络核心类.AMFPHP 利用外部组件AMFPHP使得flash可以很轻松的和php通信.
	 * 后台数据库等所有操作全部经过AMFPHP
	 * 用法很简单,输入AMFPHP连接地址后直接调用call方法.
	 * PHP部分写好类再写好方法就可以直接调用,但是在发送的参数中,请注意使用array
	 * 然后用array.password="12"等方法操作.否则会因为object的问题进入乱码.
	 * @author:Lizeqiangd
	 * 2014.03.18更改路径
	 * 2014.03.28重新审视该方法,似乎可以变得更简便.
	 * 2014.10.27增加对沙箱问题的反馈
	 */
	public class PHPAPI
	{
		private static var _gateway:NetConnection; /*NetConnect容器*/
		private static var _gatewayUrl:String = ""; /*Gateway的请求URL*/
		private static var _status:String = "not inited";
		private static var inited:Boolean = false;
		
		/**
		 * 初始化AMFPHP类.
		 */
		public static function init(url:String = ""):void
		{
			if (inited)
			{
				return;
			}
			inited = true;
			_gateway = new NetConnection();
			_gateway.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			_gateway.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError)
			//_gateway.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError)
			gatewayUrl = url;
			Cc.log("AMFPHP: gateway url:" + _gatewayUrl);
			trace("AMFPHP: gateway url:" + _gatewayUrl)
			connect(_gatewayUrl);
		}
		private static var security_error:SecurityErrorEvent
		
		static private function onSecurityError(e:SecurityErrorEvent):void
		{
			security_error = e
			Cc.error(security_error)
		}
		
		/**
		 * 当网络断开的时候需要重新连接.不过仔细想想似乎这个方法会在提交call的时候使用.
		 */
		public static function connect(url:String = ""):void
		{
			if (url != "")
			{
				gatewayUrl = url;
				_gateway.connect(url);
				_status = "connected";
			}
			else
			{
				Cc.log("AMFPHP (" + gatewayUrl + ") Reconnecting");
				trace("AMFPHP (" + gatewayUrl + ") Reconnecting")
				_gateway.connect(gatewayUrl);
			}
			//_status = "connected";
		}
		
		/**
		 * 连接的时候发生的问题会在这里反馈.事实上flash在连接成功的时候不会反馈事件.只有在发送的时候会.
		 */
		private static function onStatus(e:NetStatusEvent):void
		{
			Cc.error("Amfphp: NetStatusEvent:", e.info.code);
			trace("Amfphp: NetStatusEvent:", e.info.code);
			
			switch (e.info.code)
			{
				case "NetConnection.Call.BadVersion":
					
					/*obj.info = "服务连接失败，可能是某种bug也可能是你发现了点神奇的东西。。Status:NetConnection.Call.BadVersion";
					   obj.btn1 = "是";
					   obj.btn2 = "否";
					   obj.anime = "mc_ani_blueExcalmatory";
					   obj.animeText1 = "系统警告";
					   obj.animeText2 = "System Warning";
					 Msg.show(obj);*/
					//_status = "error";
					break;
				case "NetConnection.Call.Failed": 
					/*obj.info = "连接后台服务失败,所有涉及数据库服务将无法使用。Status:NetConnection.Call.Failed";
					   obj.btn1 = "确认";
					   obj.anime = "mc_ani_blueExcalmatory";
					   obj.animeText1 = "系统警告";
					   obj.animeText2 = "System Warning";
					 Msg.show(obj);*/
					//_status = "failed";
					responderFault(e)
					break;
				case "NetConnection.Connect.Failed": 
					responderFault(e)
					/*obj.info = "连接AMFPHP失败,所有涉及数据库服务将无法使用,是否重启本系统。Status:NetConnection.Connect.Failed";
					   obj.btn1 = "是";
					   obj.btn2 = "否";
					   obj.anime = "mc_ani_blueExcalmatory";
					   obj.animeText1 = "系统警告";
					   obj.animeText2 = "System Warning";
					 Msg.confirm(obj,URLNavigateManager.refresh());*/
					//_status = "failed";
					break;
				case "NetConnection.Call.Prohibited": 
					break;
				case "NetConnection.Connect.Success": 
					//	_eventDispatch.dispatchEvent(new NetEvent(NetEvent.CONNECTED))
					_status = "connected";
					break;
				case "NetConnection.Connect.Rejected": 
					break;
				case "NetConnection.Connect.NetworkChange": 
					break;
				case "NetConnection.Connect.Closed": 
					//_status = "closed";
					break;
			}
		}
		
		/**
		 * 传统信息提交方法,需要php的访问方法.其次需要一个Responder 这个方法很麻烦.不建议用了.
		 */
		public static function call(command:String, responder:Responder, rest:* = null):void
		{
			if (_status == "connected")
			{
				trace("AMFPHP.call:" + command);
				Cc.log("AMFPHP.call:" + command);
				if (!rest)
				{
					_gateway.call(command, responder);
				}
				else
				{
					_gateway.call(command, responder, rest);
				}
			}
		}
		
		/**
		 * 简易方法,直接提交访问方法,和一个成功执行后的返回的函数.
		 */
		public static function callResult(command:String, result:Function, rest:* = null):void
		{
			if (_status == "connected")
			{
				if (!rest)
				{
					call(command, new Responder(result, responderFault));
				}
				else
				{
					call(command, new Responder(result, responderFault), rest);
				}
			}
		}
		
		/**
		 * 在直接使用AMFPHP.callResult的时候,调用失败的时候的函数.可以由外部提交并解析到Console组件中.同时trace掉.
		 */
		public static function responderFault(e:*):void
		{
			var tx_test:String = "";
			tx_test += "函数调用失败";
			try
			{
				tx_test += "code:" + e.info["code"] + "\n";
				tx_test += "lever:" + e.info["lever"] + "\n";
				
			}
			catch (e:*)
			{
			}
			try
			{
				tx_test += "details:" + e["details"] + "\n";
				tx_test += "line:" + e["line"] + "\n";
				tx_test += "description:" + e["description"] + "\n";
			}
			catch (e:*)
			{
			}
			tx_test += "End of Fault Report";
			
			Cc.error(e);
			Cc.error(tx_test);
			
			for (var i:Object in e)
			{
				trace("MainKey:" + i);
				trace(i + ":" + e[i]);
				for (var k:Object in e[i])
				{
					trace(k + ":" + e[i][k]);
				}
			}
		}
		
		/**
		 * 获取当前连接状态.
		 */
		static public function get status():String
		{
			return _status;
		}
		
		/**
		 * 获取NetConnection实例
		 */
		static public function get nc():NetConnection
		{
			return _gateway;
		}
		
		/**
		 * 获取连接的AMFPHP地址
		 */
		static public function get gatewayUrl():String
		{
			return _gatewayUrl;
		}
		
		/**
		 * 设置连接的AMFPHP地址
		 */
		static public function set gatewayUrl(value:String):void
		{
			_gatewayUrl = value;
		}
		
		/**
		 * 特殊操作test方法:输出一个object内的key和value.同时输出下一级的key和value
		 */
		public static function openObject(e:*):void
		{
			for (var i:Object in e)
			{
				trace(i + ":" + e[i]);
				for (var k:Object in e[i])
				{
					trace(k + ":" + e[i][k]);
				}
			}
		}
	
	}
}