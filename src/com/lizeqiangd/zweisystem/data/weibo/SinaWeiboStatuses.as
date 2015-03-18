package com.lizeqiangd.zweisystem.data.weibo
{
	public class SinaWeiboStatuses
	{
		private var statuses:Array;
		private var maxid:String 
		public function SinaWeiboStatuses(a:Array )
		{
			statuses = a;
			maxid=a[0].id
		}
		public function get Statuses():Array
		{
			return statuses;
		}
		///用于表示该类中最新一个状态的id,防止重复获取多次.
		public function get Max_id():String {
			return maxid
		}
	}
}