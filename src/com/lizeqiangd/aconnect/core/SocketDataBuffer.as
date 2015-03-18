package com.lizeqiangd.aconnect.core
{
	import com.lizeqiangd.aconnect.AConnect;
	import com.lizeqiangd.aconnect.events.AConnectEvent;
	import flash.events.EventDispatcher;
	
	/**
	 *  该类用于将收到的数据进行储存,直到触发识别符号.识别符号默认为$
	 * 可以修改识别符号.
	 * @author Lizeqiangd
	 */
	public class SocketDataBuffer
	{
		private var bufferData:String = ""
		private var _eventDispatch:EventDispatcher
		
		/**
		 *  初始化类,为该类添加主侦听器
		 *  ed:主事件侦听器
		 */
		public function SocketDataBuffer(ed:EventDispatcher)
		{
			_eventDispatch = ed
		}
		/**
		 *  检查最后输入的字符是否为特殊符号.如果识别到特殊符号,则将之前收到的信息放入事件流然后分割字符串后续进行操作.
		 *  e:输入的字符串
		 */
		public function addSocketString(e:String):void
		{
			bufferData += e
			cherkSocketDataEnd()
		}
		/**
		 *  检查最后输入的字符是否为特殊符号.如果识别到特殊符号,则将之前收到的信息放入事件流然后分割字符串后续进行操作.
		 */
		private function cherkSocketDataEnd():void
		{
			var index:int = bufferData.indexOf(AConnectSetting.SocketDataEndMark)
			if (index > 0)
			{
				_eventDispatch.dispatchEvent(new AConnectEvent(AConnectEvent.MESSAGE, bufferData.slice(0, index)))
				bufferData = bufferData.slice(index + AConnectSetting.SocketDataEndMark.length)
			}
		}
		/**
		 *  特殊时候用于将信息读取出
		 */
		public function get buffer():String
		{
			return bufferData
		}
		
		/**
		 *  清理掉所有收到的信息
		 */
		public function cleanBuffer()
		{
			bufferData = ""
		}
	}
}