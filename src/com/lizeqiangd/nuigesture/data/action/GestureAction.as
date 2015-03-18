package com.lizeqiangd.nuigesture.data.action
{
	public class GestureAction
	{
		private var _from:String = "";
		private var _speed:Number = 0;
		private var _direction:String = "";
		private var _type:uint = 0;
		/*
		 * 手势动作
		 * from u1r 用户1的右手
		 * speed 相对位移速度
		 * direction 方向
		 * type 自动分析是高速还是低速 (待删除)
		 */
		public function GestureAction(from:String ,speed:Number ,direction:String ,type:uint )
		{
			_from = from;
			_speed = speed;
			_direction = direction;
			_type = type;
		}
		public function get toString():String
		{
			var s:String = "";
			s +=  "from:" + from;
			s +=  "\nspeed:" + speed;
			s +=  "\ndirection:" + direction;
			s +=  "\ntype:" + type;
			return s
		}
		public function get from():String
		{
			return _from;
		}
		public function get speed():Number
		{
			return _speed;
		}
		public function get direction():String
		{
			return _direction;
		}
		public function get type():uint
		{
			return _type;
		}
	}
}