package com.lizeqiangd.aconnect.net
{
	import com.lizeqiangd.aconnect.core.AConnectSetting;
	import com.lizeqiangd.aconnect.core.SocketDataBuffer;
	import com.lizeqiangd.aconnect.events.AConnectEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	/**
	 * AConnect的Socket主代理类.用于封装和管理socket
	 * @author Lizeqiangd
	 */
	public class SocketProxy
	{
		
		private var socket:Socket
		private var sdb:SocketDataBuffer
		private var _state:String = "not init"
		private var _targetIp:String = "127.0.0.1"
		private var _port:uint = 8088
		private var eventDispatch:EventDispatcher
		
		/**
		* AConnect的Socket主代理类.用于封装和管理socket
		* buffer:SocketDataBuffer,
		* _eventDispatch:EventDispatcher,
		* targetIP:String = "127.0.0.1",
		* port:uint = 8088
		* @author Lizeqiangd
		*/
		public function SocketProxy(buffer:SocketDataBuffer, _eventDispatch:EventDispatcher, targetIP:String = "127.0.0.1", port:uint = 8088)
		{
			this.socket = new Socket()
			this._targetIp = targetIP
			this._port = port
			this.sdb = buffer
			this.eventDispatch = _eventDispatch
			this.socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData)
			this.socket.addEventListener(Event.CONNECT, onSocketConnected)
			this.socket.addEventListener(Event.CLOSE, onSocketClosed)
			this.socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError)
			this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError)
			_state = "inited"
			reconnect()
		}
		/* 重新连接到一个新地址.同时覆盖重连的地址.(通常不适用该方法)
		 * TargetIp:String
		 * Port:uint
		 */
		public function connect(TargetIp:String, Port:uint):void
		{
			this._targetIp = TargetIp
			this._port = Port
			socket.connect(TargetIp, Port)
		}
		
		/*
		 * socket重新连接
		 */
		public function reconnect():void
		{
			socket.connect(_targetIp, _port)
		}
		
		/*
		 * socket断开连接,同时状态更改为closed
		 */
		public function disconnect():void
		{
			if (_state != "closed")
			{
				socket.close()
				//onSocketClosed(null)				
			}
		}
		/*
		 * 要发送的字符串
		 * data:String要发送的字符串
		 */
		public function sendStringAndHold(data:String):void
		{
			if (_state == "connected")
			{
				this.socket.writeUTFBytes(data)
				this.socket.flush()
			}
			else
			{
				trace("AConnect:send data failed. not connected")
			}
		}
		/*
		 * 销毁本类并清理所有侦听器,同时断开连接.
		 */
		public function dispose():void		
		{
			disconnect()		
			this.socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData)
			this.socket.removeEventListener(Event.CONNECT, onSocketConnected)
			this.socket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketIOError)
			this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError)	
			this.socket = null
			this=null 
		}
		/*
		 * 安全错误,通常是沙箱问题.
		 */
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			//trace("AConnect:SecurityError")
			_state = "SecurityError"
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_ERROR, e.text))
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_CLOSED))
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_STATE, _state))
		}
		/*
		 * 写入错误,一般不会出现.
		 */
		private function onSocketIOError(e:IOErrorEvent):void
		{
			//trace("AConnect:IOError :", e.text)
			_state = "IOError"
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_ERROR, e.text))
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_CLOSED))
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_STATE, _state))
		}
		/*
		 * 成功连接.
		 */
		private function onSocketConnected(e:Event):void
		{
			//trace("AConnect:Connected.")
			_state = "connected"
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_CONNECT))
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_STATE, _state))
		}
		/*
		 * 连接被关闭
		 */
		private function onSocketClosed(e:Event):void
		{
			_state = "closed"
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_CLOSED))
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_STATE, _state))
		}
		/*
		 * 当有信息收到时,会自动将受到的信息用SOCKET_DATA调度
		 */
		private function onSocketData(e:ProgressEvent):void
		{
			var temp:String = socket.readUTFBytes(socket.bytesAvailable)
			sdb.addSocketString(temp)
			eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.SOCKET_DATA, temp))
		}
		
		/*
		 * 获取本类的socket
		 */
		public function get Sockets():Socket
		{
			return this.socket
		}
		/*
		 * 获得目标地址ip
		 */
		public function get Host():String
		{
			return _targetIp;
		}
		/*
		 * 获得目标地址端口
		 */
		public function get Port():uint
		{
			return _port;
		}
		/*
		 * 获取当前连接状态
		 */
		public function get State():String
		{
			return _state;
		}
	
	}

}
