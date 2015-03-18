package com.lizeqiangd.zweitehorizont.data.object
{

	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	/*
	   用户对象所包含的内容如下：
	   uid:用户在数据库中的绝对id
	   sid:服务器识别用id
	   cid:客户端绝对id
	   user_type:用户的类别(player,Administrator,GameMasterPool
	   display_name:显示名，昵称
	   description:显示自己当前状态等信息
	   client_object:当前客户端对象
	 */
	public class User 
	{
		public var uid:uint 
		public var sid:uint 
		public var cid:uint
		public var user_type:String 
		public var display_name:String 
		public var description:String 
	}

}