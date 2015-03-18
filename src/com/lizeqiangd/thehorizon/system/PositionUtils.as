package com.thehorizon.system
{
	import com.google.maps.LatLng;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class PositionUtils
	{
		static private var top_lat:Number = 1
		static private var right_lng:Number = 1
		static private var left_lng:Number = 1
		static private var bottom_lat:Number = 1
		
		static private var width_display_zone:Number = 1
		static private var height_display_zone:Number = 1
		
		static private var delta_lng:Number = 1
		static private var delta_lat:Number = 1
		
		static private var delta_displayX:Number = 1
		static private var delta_displayY:Number = 1
		
		static public function setDisplayZone(width:Number, height:Number):void
		{
			width_display_zone = width
			height_display_zone = height
		}
		
		/*
		   static public function setBaseMapLocation(value:Number, direction:String):void
		   {
		   switch (direction.toLowerCase)
		   {
		   case "top":
		   top_lng = value
		   break;
		   case "right":
		   right_lat = value
		   break;
		   case "left":
		   left_lat = value
		   break;
		   case "bottom":
		   bottom_lng = value
		   break;
		   default:
		   trace("Error:PositionUtils.setDisplayPosition.direction:" + direction)
		   }
		   delta_lng = top_lng - bottom_lng
		   delta_lat = right_lat - left_lat
		   delta_displayX = width_display_zone / delta_lng
		   delta_displayY = height_display_zone / delta_lat
		   }
		 */
		static public function setBaseMapLocation(top:Number, right:Number, bottom:Number, left:Number):void
		{
			top_lat = top
			right_lng = right
			left_lng = left
			bottom_lat = bottom
			delta_lat	 = top_lat - bottom_lat
			delta_lng = right_lng - left_lng
			delta_displayX = width_display_zone / delta_lng
			delta_displayY = height_display_zone /delta_lat 
		}
		
		static public function LatLngNumberToPoint(lat:Number, lng:Number):Point
		{
			var returnX:Number = width_display_zone-(right_lng - lng) * delta_displayX
			var returnY:Number = (top_lat - lat) * delta_displayY			
			return new Point(returnX, returnY)
		}
		
		static public function LatLngToPoint(latlng:LatLng):Point
		{
			return LatLngNumberToPoint(Number(latlng.lat), Number(latlng.lng))
		}
		
		static public function PointToLatLng(point:Point):LatLng
		{
			return XYToLatLng(point.x, point.y)
		}
		
		static public function XYToLatLng(x:Number, y:Number):LatLng
		{
			var returnY:Number = top_lat - y / height_display_zone * delta_lat
			var returnX:Number = right_lng - x / width_display_zone * delta_lng
			return new LatLng(returnY,returnX )
		}
		
		static public function toString():void
		{
		/*	trace("top_lng:" + top_lng)
			trace("right_lat:" + right_lat)
			trace("left_lat:" + left_lat)
			trace("bottom_lng:" + bottom_lng)
			trace("delta_displayX:" + delta_displayX)
			trace("delta_displayY:" + delta_displayY)
			trace("delta_lat:" + delta_lat)
			trace("delta_lng:" + delta_lng)*/
		}
	
	}

}