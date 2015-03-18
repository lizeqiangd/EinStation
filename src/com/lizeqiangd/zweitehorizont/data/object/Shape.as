package com.lizeqiangd.zweitehorizont.data.object 
{
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class Shape 
	{
		/* type:
		 * 0:Point
		 * 1:Circle
		 * 2:Polygon
		 */
		
		public var type:uint
		public var radius:uint 
		public var circum_circle_centre_point:Location 
		public var polygon_points:Vector.< Location>

		
	}

}