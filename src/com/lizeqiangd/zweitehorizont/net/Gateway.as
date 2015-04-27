package com.lizeqiangd.zweitehorizont.net
{
	
	/**
	 * @author Lizeqiangd
	 * 在原有的基础上面增加时间戳
	 */
	public class Gateway extends ObjectSocket
	{
		
		public function Gateway(callback:Function = null)
		{
			super(callback)
		}
		
		override public function sendObject(obj:Object):void
		{			
			obj.timestamp = getSystemTime();
			super.sendObject(obj);
		}
		
		private function getSystemTime():String
		{
			var d:Date = new Date;
			return d.getFullYear() + '-' + d.getMonth() + 1 + '-' + d.getDate() + ' ' + d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds();
		}
	}

}