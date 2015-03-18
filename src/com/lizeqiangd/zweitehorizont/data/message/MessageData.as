package com.lizeqiangd.zweitehorizont.data.message 
{
	import com.lizeqiangd.zweitehorizont.data.object.User;
	/**
	 * 2014.07.07作为message channel一部分使用.
	 * @author lizeqiangd
	 */
	public class MessageData 
	{
		public var channel_name:String = ""
		public var channel_description:String =""
		public var channel_id:uint=0
		public var channel_type:String =""
		public var channel_security:int =0
		public var channel_mumber_limit:uint = 0
		public var channel_creator:User
		public var channel_create_time:String  =""
		
		
	}

}