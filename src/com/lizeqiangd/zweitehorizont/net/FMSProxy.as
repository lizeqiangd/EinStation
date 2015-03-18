package com.lizeqiangd.zweitehorizont.net
{
	import com.lizeqiangd.zweitehorizont.events.NetEvent;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import net.nshen.nfms.FMSEvent;
	import net.nshen.nfms.NCClient;
	
	/**
	 * 本类是FMS服务器连接的加壳类.用于方便管理连接.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * update
	 * 2014.04.06: 修正
	 */
	public class FMSProxy
	{
		private var _nc:NetConnection
		private var _ns:NetStream
		private var inited:Boolean = false
		private var status:String = "not inited"
		private var _eventDispatch:EventDispatcher
		private var _server:String = "rtmp://localhost/ZweiteHorizont"
		private var _token:String
		private var _clientuid:uint
		
		public function FMSProxy()
		{
			_eventDispatch = new EventDispatcher()
			_nc = new NetConnection();
			_nc.client = new NCClient(_nc);
		}
		
		public function init(server:String, token:String, cuid:uint):void
		{
			if (inited)
			{
				return
			}
			_server = server
			_token = token
			_clientuid = cuid
			inited = true
			reconnect()
		}
		
		//连接和断开连接
		public function reconnect():void
		{
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onFMSStatus);
			_nc.connect(_server, _token, _clientuid);
			status = "connecting"
		}
		
		public function disconnect():void
		{
			_nc.removeEventListener(NetStatusEvent.NET_STATUS, onFMSStatus);
			_nc.close()
			status = "closed"
			_eventDispatch.dispatchEvent(new NetEvent(NetEvent.CLOSED))
			_eventDispatch.dispatchEvent(new NetEvent(NetEvent.STATUS, status))
		}
		
		//发送事件，和便捷方法
		public function dispatchEvent(e:FMSEvent):void
		{
			if (status == "connected")
			{
				NCClient(_nc.client).dispatchEvent(e)
			}
		}
		
		public function dispatch(eventType:String, data:Object = null):void
		{
			if (status == "connected")
			{
				NCClient(_nc.client).dispatchEvent(new FMSEvent(eventType, data))
			}
		}
		
		//对连接侦听事件
		public function addConnectionEventListener(type:String, func:Function):void
		{
			_eventDispatch.addEventListener(type, func, false, 0, true)
		}
		
		public function removeConnectionEventListener(type:String, func:Function):void
		{
			_eventDispatch.removeEventListener(type, func)
		}
		
		//对服务器侦听事件
		public function addEventListener(type:String, func:Function):void
		{
			NCClient(_nc.client).addEventListener(type, func)
		}
		
		public function removeEventListener(type:String, func:Function):void
		{
			NCClient(_nc.client).removeEventListener(type, func)
		}
		
		private function onFMSStatus(e:NetStatusEvent):void
		{
			if (e.info.code == "NetConnection.Connect.Success")
			{
				status = "connected"
				//FMS.dispatch("UserManagerUpdateUserInformation", {user_name: LoginManager.getUsername, driver_code: "test", level: LoginManager.isAdministrator ? 10 : 0})
				trace("ZweiteHorizont.FMSProxy:FMS服务器连接成功")
				_eventDispatch.dispatchEvent(new NetEvent(NetEvent.STATUS, status))
				_eventDispatch.dispatchEvent(new NetEvent(NetEvent.CONNECTED))
				return 
			}
			if (e.info.code == "NetConnection.Connect.Closed")
			{
				trace("ZweiteHorizont.FMSProxy:FMS服务器连接已经被关闭")
				status = "closed"
				_eventDispatch.dispatchEvent(new NetEvent(NetEvent.STATUS, status))
				_eventDispatch.dispatchEvent(new NetEvent(NetEvent.CLOSED))
				return 
			}
			if (e.info.code == "NetConnection.Connect.Rejected")
			{
				trace("ZweiteHorizont.FMSProxy:FMS服务器连接已经被拒绝")
				status = "rejected"
				_eventDispatch.dispatchEvent(new NetEvent(NetEvent.STATUS, status))
				_eventDispatch.dispatchEvent(new NetEvent(NetEvent.REJECTED))
				return 
			}
			if (e.info.code == "NetConnection.Connect.Failed")
			{
				trace("ZweiteHorizont.FMSProxy:FMS服务器连接失败")
				status = "failed"
				_eventDispatch.dispatchEvent(new NetEvent(NetEvent.STATUS, status))
				_eventDispatch.dispatchEvent(new NetEvent(NetEvent.FAILED))
				return 
			}
			trace("ZweiteHorizont.FMSProxy: e.info.code:", e.info.code)
		}
		/**
		 * 获取是否已经连接上服务器.
		 */
		public function get isConnected():Boolean
		{
			return Boolean(status == "connected")
		}
		/**
		 * 获取目前连接状态
		 */
		public function get getStatus():String
		{
			return status
		}
	}

}
