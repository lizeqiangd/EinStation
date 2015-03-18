package com.lizeqiangd.zweisystem.components.encode
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import com.greensock.TweenLite
	
	/**
	 * 修改图片大小的类.
	 */
	public class ResizeImage
	{
		/**
		 * 将一个对象进行缩放,根据宽度缩放
		 * @param	o
		 * @param	aw
		 * @param	ah
		 * @param	motion
		 */
		public static function resizeByWidth(o:*, aw:Number, ah:Number, motion:Boolean)
		{
			var bw:Number = DisplayObject(o).width;
			var bh:Number = DisplayObject(o).height;
			if (motion)
			{
				TweenLite.to(o, 1, {scaleX: ah / bh, scaleY: ah / bh});
			}
			else
			{
				DisplayObject(o).scaleX = ah / bh;
				DisplayObject(o).scaleY = ah / bh;
			}
		
		}
		
		/**
		 * 将一个对象进行缩放,根据高度缩放比例
		 * @param	o
		 * @param	aw
		 * @param	ah
		 * @param	motion
		 */
		public static function resizeByHeight(o:*, aw:Number, ah:Number, motion:Boolean)
		{
			var bw:Number = DisplayObject(o).width;
			var bh:Number = DisplayObject(o).height;
			if (motion)
			{
				TweenLite.to(o, 1, {scaleX: aw / bw, scaleY: aw / bw});
			}
			else
			{
				DisplayObject(o).scaleX = aw / bw;
				DisplayObject(o).scaleY = aw / bw;
			}
		}
		
		
		 /**
		  * 将一个对象进行缩放,根据isOutside决定缩放
		  * @param	o
		  * @param	aw
		  * @param	ah
		  * @param	motion
		  * @param	isOutside 在外还是在内默认在外.
		  */
		public static function resize(o:*, aw:Number, ah:Number, motion:Boolean = false, isOutside:Boolean = true)
		{
			DisplayObject(o).scaleY = 1;
			DisplayObject(o).scaleX = 1;
			var bw:Number = DisplayObject(o).width;
			var bh:Number = DisplayObject(o).height;
			var judge = isOutside ? aw / bw > ah / bh : aw / bw < ah / bh
			if (judge)
			{
				resizeByHeight(o, aw, ah, motion);
			}
			else
			{
				resizeByWidth(o, aw, ah, motion);
			}
			//trace("ResizeImage.resize后的width:",o.width,"height:",o.height);
		}
	}
}