package com.lizeqiangd.zweisystem.events
{
	import flash.events.Event;
	
/**
	 * 网络类事件,通常用于amfphp和fms等服务的连接.而socket的连接就不会经过这里,大概会经过acconet那边吧.
	 * @author:Lizeqiangd
	 * 2014.03.28 更新备注.
	 */
	public class NetEvent extends Event
	{
		public static var SERVICE_OK:String = "service_ok";
		
		//网络上下载事件 
		public static var UPLOAD_START:String = "upload_start";
		public static var PROGRESSING:String = "progressing";
		public static var UPLOAD_OK:String = "upload_ok";
		
		//发布类事件
		public static var PUBLISH_OK:String = "publish_ok";
		public static var PUBLISH_FAILED:String = "publish_FAILED";
		
		//连接成功
		public static var CONNECTED:String = "connected";
		//连接失败
		public static var FAILED:String = "failed";
		//网络错误
		public static var ERROR:String = "net_error";
		//连接被拒绝
		public static var REJECTED:String = "rejected";
		//连接被关闭.
		public static var CLOSED:String = "closed";
		public var data:*;
		
		public function NetEvent(type:String, DispatchData:* = null, bubbles:Boolean = false)
		{
			super(type, bubbles);
			data = DispatchData;
		}
	}
}