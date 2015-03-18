package com.lizeqiangd.zweitehorizont.system
{
	import com.lizeqiangd.zweitehorizont.abstracts.BaseObject;
	
	/**
	 * 本类用于数据类型的转化
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class ConversionData
	{
		/**
		 * 将一个object的信息转换成为BaseObject
		 * @param	o
		 * @return
		 */
		public static function ObjectToBaseObject(o:Object):BaseObject
		{
			var bo:BaseObject = new BaseObject
			bo.content = o.content
			bo.handler.handler_uid = o.handler.handler_uid
			bo.handler.handler_type = o.handler.handler_type
			bo.information.item_id = o.information.item_id
			bo.information.creator_uid = o.information.creator_uid
			bo.information.create_date = o.information.create_date
			bo.location.x = o.location.x
			bo.location.y = o.location.y
			bo.shape.radius = o.shape.radius
			bo.shape.type = o.shape.type
			bo.shape.polygon_points = o.shape.polygon_points
			bo.shape.circum_circle_centre_point = o.shape.circum_circle_centre_point
			bo.oid = o.oid
			bo.sid = o.sid
			return bo
		}
		/**
		 * 将一个Object的信息覆盖到BaseObject中
		 * @param	o
		 * @param	bo
		 */
		public static function ObjectOverlayBaseObject(o:Object, bo:BaseObject):void
		{
			bo.content = o.content
			bo.handler.handler_uid = o.handler.handler_uid
			bo.handler.handler_type = o.handler.handler_type
			bo.information.item_id = o.information.item_id
			bo.information.creator_uid = o.information.creator_uid
			bo.information.create_date = o.information.create_date
			bo.location.x = o.location.x
			bo.location.y = o.location.y
			bo.shape.radius = o.shape.radius
			bo.shape.type = o.shape.type
			bo.shape.polygon_points = o.shape.polygon_points
			bo.shape.circum_circle_centre_point = o.shape.circum_circle_centre_point
			bo.oid = o.oid
			bo.sid = o.sid
		}
	
	}

}