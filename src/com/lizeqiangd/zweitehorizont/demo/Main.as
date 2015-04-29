package com.lizeqiangd.zweitehorizont.demo
{
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general;
	import com.lizeqiangd.zweitehorizont.net.Gateway;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * 用于和Node通信的Socket项目.
	 * @author Lizeqiangd
	 */
	public class Main extends Sprite
	{
		private const max_reconnect_count:uint = 240
		private const reconnect_delay:uint = 5000
		
		private var host_url:String = '127.0.0.1'
		private var host_port:int = 20100;
		
		private var s:Gateway
		private var reconnect_timer:Timer
		
		public function Main()
		{
			s = new Gateway(onSocketData)
			s.addEventListener(Event.CONNECT, onSocketConnected)
			s.addEventListener(IOErrorEvent.IO_ERROR, onSocketError)
			s.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData)
			s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketError)
			s.addEventListener(Event.CLOSE, onSocketError)
			addChild(new btn_general)
			addChild(new btn_general)
			addChild(new btn_general)
			addChild(new btn_general)
			addChild(new btn_general)
			addChild(new btn_general)
			
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var btn:btn_general = getChildAt(i) as btn_general
				btn.title = '测试按钮' + String(i + 1)
				btn.y = i * 60
				btn.addEventListener(UIEvent.CLICK, onMouseClick)
			}
			
			reconnect_timer = new Timer(reconnect_delay, max_reconnect_count)
			reconnect_timer.addEventListener(TimerEvent.TIMER, function(e:*):void
				{
					s.connect(host_url, host_port)
				})
			reconnect_timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:*):void
				{
					trace('reconnect failed. reach the max retry times.')
				})
			s.connect(host_url, host_port)
			
			trace()
		}
		
		private function onSocketData(obj:Object):void
		{
			for (var i:String in obj)
			{
				trace(i, ':', obj[i])
				for (var k:String  in obj[i]) {
					trace(i,'.',k,':',obj[i][k])
				}
			}
		}
		
		private function onMouseClick(e:UIEvent):void
		{
			switch (e.target.title)
			{
				case '测试按钮1': 
					s.sendObject({module: 'system_manager',action:'get_system_infotmation'})
					break;
				case '测试按钮2':
					break;
				case '测试按钮3':					
					break;
				case '测试按钮4':
					
					break;
				case '测试按钮5':
					
					break;
				case '测试按钮6':
					
					break;
				default: 
			}
		}
		
		private function onSocketError(e:* = null):void
		{
			
			if (!reconnect_timer.running)
			{
				reconnect_timer.start()
				trace('Socket error reconnecting in ' + reconnect_delay / 1000 + ' seconds')
				trace(e)
			}
			else
				trace('Socket error', e)
		}
		
		private function onSocketConnected(e:Event):void
		{
			reconnect_timer.running ? trace('Socket:Reconnection is connected!') : trace('Socket:Connection is connected!');
			reconnect_timer.reset()
		}
	}
}