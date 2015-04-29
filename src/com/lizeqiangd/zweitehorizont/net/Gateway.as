package com.lizeqiangd.zweitehorizont.net
{
	import com.lizeqiangd.zweitehorizont.events.GatewayEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author Lizeqiangd
	 * 在原有的基础上面增加时间戳
	 * 写错timer的方式.
	 */
	public class Gateway extends ObjectSocket
	{
		private const max_reconnect_count:uint = 10
		private const reconnect_delay:uint = 1000
		private var reconnect_timer:Timer
		private var _retry_count:int = 0
		private var _user_closed:Boolean = false
		private var _host:String = '127.0.0.1'
		private var _port:int = 20100
		
		public var client_id:String = '0';
		
		public function Gateway(callback:Function = null)
		{
			super(callback)
			this.addEventListener(Event.CONNECT, onSocketConnected);
			this.addEventListener(IOErrorEvent.IO_ERROR, onSocketError);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketError);
			this.addEventListener(Event.CLOSE, onSocketClosed);
			
			reconnect_timer = new Timer(reconnect_delay, 1)
			reconnect_timer.addEventListener(TimerEvent.TIMER_COMPLETE, reconnectTimerCompleted)
		}
		
		/**
		 * 连接到服务器,会保存服务器地址用于断线重连
		 * @param	host_url
		 * @param	host_port
		 */
		override public function connect(host_url:String, host_port:int):void
		{
			_user_closed = false
			_host = host_url
			_port = host_port
			this.dispatchEvent(new GatewayEvent(GatewayEvent.CONNECTING))
			super.connect(host_url, host_port)
		}
		
		override public function close():void
		{
			_user_closed = true
			super.close()
		}
		
		/**
		 * 发送Object,同时会附带时间戳
		 * @param	obj
		 */
		public function sendData(data:Object, module:String, action:String = ''):String
		{
			var o:Object = {}
			o.data = data
			o.module = module
			o.action = action
			o.client_id = client_id
			o.timestamp = Gateway.getSystemTime();
			o.fingerprint = Gateway.getRandomFingerprint()
			super.sendObject(o);
			return o.fingerprint
		}
		
		/**
		 * 返回是否在尝试连接.
		 */
		public function get reconnecting():Boolean
		{
			return reconnect_timer.running
		}
		
		/**
		 * 重新连接计时器完成
		 * @param	e
		 */
		private function reconnectTimerCompleted(e:TimerEvent):void
		{
			if (_retry_count > max_reconnect_count)
			{
				trace('ZweiteHorziont.Gateway:reconnect failed. reach the max retry times.')
			}
			else
			{
				this.connect(_host, _port)
				_retry_count++
			}
			//this.dispatchEvent(new GatewayEvent(GatewayEvent.CLOSED))
		}
		
		/**
		 * 当连接发生错误的时候会立刻尝试进行重新连接.
		 * 抛出Event.SUSPEND事件.
		 * @param	e
		 */
		private function onSocketError(e:* = null):void
		{
			trace('ZweiteHorizont.Gateway:connection error');
			this.dispatchEvent(new GatewayEvent(GatewayEvent.ERROR))
			reconnect_timer.start()
		}
		
		/**
		 * 连接成功的时候,清空重连计时器
		 * @param	e
		 */
		private function onSocketConnected(e:Event):void
		{
			if (reconnect_timer.running)
			{
				//trace('Socket:Reconnection is connected!')
			}
			else
			{
				//trace('Socket:Connection is connected!');
			}
			_retry_count = 0
			reconnect_timer.reset()
			this.dispatchEvent(new GatewayEvent(GatewayEvent.CONNECTED))
		}
		
		/**
		 * 连接关闭的时候,如果是人为关闭则关闭.反之重新连接.
		 * @param	e
		 */
		private function onSocketClosed(e:Event):void
		{
			if (_user_closed)
			{
				this.dispatchEvent(new GatewayEvent(GatewayEvent.CLOSED))
			}
			else
			{
				reconnect_timer.start()
			}
		}
		
		/**
		 * 全局方法.
		 * 获得目前时间戳
		 * 格式:0000-00-00 00:00:00
		 * @return
		 */
		public static function getSystemTime():String
		{
			var d:Date = new Date;
			return d.getFullYear() + '-' + d.getMonth() + 1 + '-' + d.getDate() + ' ' + d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds();
		}
		
		/**
		 * 全局方法.
		 * 输出当前Object的3层级内容..类似于php的var_dump功能.
		 * @param	obj
		 */
		public static function traceObjectContent(obj:Object):void
		{
			for (var i:String in obj)
			{
				trace(i, ':', obj[i])
				for (var k:String in obj[i])
				{
					trace(i, '.', k, ':', obj[i][k])
					for (var w:String in obj[i][k])
					{
						trace(i, '.', k, '.', w, ':', obj[i][k][w])
					}
				}
			}
		}
		
		public static function getRandomFingerprint():int
		{
			return Math.round(Math.random() * 1000000)
		}
	}
}