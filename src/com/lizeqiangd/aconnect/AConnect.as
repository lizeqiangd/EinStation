package com.lizeqiangd.aconnect
{
	import com.lizeqiangd.aconnect.core.AConnectSetting
	import com.lizeqiangd.aconnect.core.SocketDataBuffer;
	import com.lizeqiangd.aconnect.events.AConnectEvent;
	import com.lizeqiangd.aconnect.net.SocketProxy;
	import flash.events.EventDispatcher;
	import flash.net.Socket;
	
	/**
	 * AConnect类.用于Arduino和STC51单片机与flash通信.主要方法是socket方法.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class AConnect
	{
		private static var _eventDispatch:EventDispatcher
		private static var sp:SocketProxy
		private static var sdb:SocketDataBuffer
		
		/*
		 * 初始化该类.
		 */
		public static function init():void
		{
			_eventDispatch = new EventDispatcher
			sdb = new SocketDataBuffer(_eventDispatch)
			sp = new SocketProxy(sdb, _eventDispatch)
		}
		
		/*
		 * 开始连接,需要目标地址的ip和端口
		 * TargetIP:String目标地址ip
		 * Port:uint目标地址的端口
		 */
		public static function connect(TargetIp:String, Port:uint):void
		{
			sp.connect(TargetIp, Port)
		}
		
		/*
		 * 重新连接
		 */
		public static function reconnect():void
		{
			sp.reconnect()
		}
		
		/*
		 * 断开连接
		 */
		public static function disconnect():void
		{
			sp.disconnect()
		}
		
		/*
		 * 向Socket发送数据,默认会自动添加特殊字符.
		 * data_string:String要发送的字符串
		 * autoAddEndMark:Boolean = true默认添加特别字符串
		 */
		public static function sendString(data_string:String, autoAddEndMark:Boolean = true):void
		{
			if (autoAddEndMark)
			{
				sp.sendString(data_string + AConnectSetting.SocketDataEndMark)
			}
			else
			{
				sp.sendString(data_string)
			}
		}
		
		/*
		 * 清除未处理的数据
		 */
		public static function cleanBuffer()
		{
			sdb.cleanBuffer()
		}
		
		/*
		 *获取未处理数据
		 */
		public static function get getBuffer():String
		{
			return sdb.buffer
		}
		
		/*
		 * 添加事件侦听器
		 */
		public static function addEventListener(type:String, listener:Function):void
		{
			_eventDispatch.addEventListener(type, listener, false, 0, true);
		}
		
		/*
		 * 移除事件侦听器
		 */
		public static function removeEventListener(type:String, listener:Function):void
		{
			_eventDispatch.removeEventListener(type, listener);
		}
		
		/*
		 * 直接获得Socket代理
		 */
		public static function get SocketProxys():SocketProxy
		{
			return sp
		}
		
		/*
		 * 直接获得socket本身
		 */
		public static function get Sockets():Socket
		{
			return sp.Sockets
		}
	}

}