package com.lizeqiangd.nuigesture.data
{
	
	/*
	 * 区块数据,原计划将用户手的距离按照不同位置进行区分区域.(失效)
	 */
	public class Zone
	{
		private var _zonename:String;
		private var _startDistand:int;
		private var _endDistand:int;
		
		/*
		 * 设置区域的开始距离和结束距离以及区域名字
		 */
		public function Zone(zonename:String, startDistand:Number, endDistand:Number)
		{
			_zonename = zonename;
			_startDistand = startDistand;
			_endDistand = endDistand;
		}
		
		public function get startDistand():Number
		{
			return _startDistand;
		}
		
		public function get endDistand():Number
		{
			return _endDistand;
		}
		
		public function get zoneName():String
		{
			return _zonename;
		}
	}
}