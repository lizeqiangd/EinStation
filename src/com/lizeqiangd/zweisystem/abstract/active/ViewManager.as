package com.lizeqiangd.zweisystem.abstract.active
{
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class ViewManager extends ActiveManager
	{
		private var lastView:String = ""
		private var am_mask:Sprite = new Sprite
		
		/**
		 * 
		 */
		public function ViewManager(hostApp:iApplication , _x:Number ,_y:Number ,_width:Number, _height:Number)
		{
			super(hostApp)
			super.registerPointByXY(0, 0, "ViewMode")
			am_mask.graphics.beginFill(0,0)
			am_mask.graphics.drawRect(_x,_y, _width, _height)
			addChild(am_mask)
			//super.mask =am_mask
		}
		/**
		 * 
		 */
		public function moveview(activename:String, direction:String = "fade"):iActive 
		{
			if (lastView !== "")
			{
				super.moveout(lastView)
			}
			lastView = activename
			return iActive (movein(activename, "ViewMode", direction))
		}/**
		 * 
		 */
		override public function registerActive(active:BaseActive)
		{
			//trace("registerActive",active);
			active.VM = this;
			active.host = _host;
			_ActiveArray.push(active);
			DisplayObjectContainer(_host).removeChild(active);
		}
	}

}