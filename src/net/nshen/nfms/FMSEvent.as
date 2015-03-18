package net.nshen.nfms
{
	import flash.events.Event;
	
	/**
	 * @author nn
	 * @editBy lizeqiangd
	 */
	public class FMSEvent extends Event
	{
		// 服务器传来的参数列表
		public var data:Object = {};
		
		public function FMSEvent(type:String, Data:Object = null)
		{
			super(type, false, false);
			this.data = Data;
		}
		public function get data2():Object {
			return data[0]
		}
	
	}

}