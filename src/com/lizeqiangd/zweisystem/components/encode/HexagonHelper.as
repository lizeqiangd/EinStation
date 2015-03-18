package com.lizeqiangd.zweisystem.components.encode
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author lizeqiangd
	 */
	public class HexagonHelper
	{
		
		public function HexagonHelper()
		{
		
		}
		
		/**
		 * 计算水平模式的六边形位置.
		 * 排列效果
		 * 0 4 9 O
		 *  3 7 O
		 * 1 5 O O
		 *  4 8 O
		 * 2 6 O O
		 * 计算方式:calculateHorizontalPosition(0,100,86.55,10,3)
		 * @param	count
		 * @param	hex_width
		 * @param	hex_height
		 * @param	distance
		 * @param	maxHeightCount
		 * @return
		 */
		public static function calculateHorizontalPosition(count:int, hex_width:Number, hex_height:Number, distance:Number, maxHeightCount:uint):Point
		{
			var p:Point = new Point()
			var numberInSet:int = count % (maxHeightCount * 2 - 1)
			var sets:int = (count - numberInSet) / (maxHeightCount * 2 - 1)
			var horizontal_distance:Number = distance * Math.sin(1.04719758)
			//trace("numberInSet", numberInSet, " sets",sets," horizontal_distance",horizontal_distance)
			if (numberInSet < maxHeightCount)
			{
				p.x = sets * (1.5 * hex_width + horizontal_distance * 2)
				p.y = numberInSet * (hex_height + distance)
			}
			else
			{
				
				p.x = (sets * 2 + 1) * (0.75 * hex_width + horizontal_distance)
				
				p.y = (numberInSet - maxHeightCount) * (hex_height + distance) + (hex_height + distance) / 2
			}
			return p
		}
		
		public static function calculateHorizontalTotal(count:int, hex_width:Number, hex_height:Number, distance:Number, maxHeightCount:uint)
		{
			var p:Point = new Point()
			p.y = maxHeightCount * (hex_height + distance) //+ hex_height
			p.x = (count % (maxHeightCount * 2 - 2) - maxHeightCount) * (hex_height + distance) + (hex_height + distance) / 2
			return p
		}
	}

}