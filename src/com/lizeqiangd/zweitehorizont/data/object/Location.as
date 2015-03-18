package com.lizeqiangd.zweitehorizont.data.object
{
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class Location
	{
		private var _x:Number
		private var _y:Number
		
		public function Location()
		{
		
		}
		
		public function set x(e:Number):void
		{
		_x=e
		}
		
		public function set y(e:Number):void
		{
		_y=e
		}
		
		public function set lat(e:Number):void
		{
		_y=e
		}
		
		public function set lng(e:Number):void
		{
		_x=e
		}
		
		public function get x():Number
		{
		return _x
		}
		
		public function get y():Number
		{
		return _y
		}
		
		public function get lat():Number
		{
		return _y
		}
		
		public function get lng():Number
		{
		return _x
		}
		public function get object():Object {
			return {x:this._x,y:this._y}
		}
	}

}