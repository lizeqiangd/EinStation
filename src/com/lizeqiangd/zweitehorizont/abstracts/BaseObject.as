package com.lizeqiangd.zweitehorizont.abstracts 
{
	import com.lizeqiangd.zweitehorizont.data.object.Handler;
	import com.lizeqiangd.zweitehorizont.data.object.Information;
	import com.lizeqiangd.zweitehorizont.data.object.Location;
	import com.lizeqiangd.zweitehorizont.data.object.Shape;
	import com.lizeqiangd.zweitehorizont.manager.ObjectManager;
	import com.lizeqiangd.zweitehorizont.system.ClientUtils;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class BaseObject 
	{
		public var handler:Handler
		public var information:Information
		public var location:Location
		public var shape:Shape
		public var sid:uint 
		public var oid:uint 
		public var content:Object 
		private var om:ObjectManager 
		public function BaseObject() 
		{
			handler = new Handler
			handler.handler_type = 0
			handler.handler_uid= 0
			
			information = new Information
			information.create_date =  new Date().toUTCString()
			information.creator_uid = 0
			information.item_id = 0
			
			
			location = new Location
			location.x = 0.0000000
			location.y = 0.0000000
			
			shape = new Shape
			shape.type = 0
			shape.radius = 0
			
			content = new Object
			
			oid = ClientUtils.getNewObjectUid
			
		}
		
	}
	
}