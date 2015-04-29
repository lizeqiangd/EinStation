package com.lizeqiangd.zweitehorizont
{
	import com.lizeqiangd.zweitehorizont.events.GatewayEvent;
	import com.lizeqiangd.zweitehorizont.net.Gateway;
	import flash.events.Event;
	
	/**
	 * ZweiteHorziontServer(base on Node.js) 2.0 MainEntence
	 *
	 * @author Lizeqiangd
	 */
	public class ZweiteHorziontServer
	{
		private static var _instance:ZweiteHorziontServer
		
		public static function get getInstance():ZweiteHorziontServer
		{
			if (!_instance)
			{
				_instance = new ZweiteHorziontServer;
			}
			return _instance;
		}
		
		private var gateway:Gateway
		
		///本机是否在服务器上完成初始化逻辑.
		private var inited:Boolean = false
		
		public function ZweiteHorziontServer()
		{
			if (_instance)
			{
				throw('ZweiteHorziontServer:please use getInstance to create an instance');
			}
			gateway = new Gateway(onRouteFunction)
			gateway.addEventListener(GatewayEvent.CONNECTED, onGatewayConnected)
			gateway.addEventListener(GatewayEvent.CLOSED, onGatewayClosed)
			gateway.addEventListener(GatewayEvent.CONNECTING, onGatewayConnecting)
		}
		
		private function onGatewayConnected(e:Event):void
		{
			
			if (!inited)
			{
				trace('连接成功,初始化中.')
				gateway.sendData({access_key: 'test'}, 'connection_manager', 'access_zweitehorizont_server');
				return;
			}
		}
		
		private function onGatewayClosed(e:Event):void
		{
			trace('连接被关闭')
		}
		
		private function onGatewayConnecting(e:Event):void
		{
			trace('正在尝试连接')
		}
		
		public function connectToServer(_host:String, _port:int):void
		{
			gateway.connect(_host, _port)
		}
		
		public function disconnectToServer():void
		{
			gateway.close()
		}
		
		private function onRouteFunction(obj:Object):void
		{
			if (!inited && obj.client_id)
			{
				gateway.client_id = obj.client_id
				inited = true
				trace('连接成功,client_id:', gateway.client_id)
				return;
			}
			Gateway.traceObjectContent(obj)
		}
	
	}

}