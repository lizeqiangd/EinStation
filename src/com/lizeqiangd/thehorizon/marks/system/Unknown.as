package com.thehorizon.marks.system
{
	import com.thehorizon.abstracts.BaseMark;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class Unknown extends BaseMark
	{
		
		public function Unknown()
		{
			test()
		}
		
		public function test():void
		{
			this.graphics.beginFill(0x3399ff, 0.8)
			this.graphics.drawCircle(0, 0, 10)
			this.graphics.endFill()
		}
	}

}