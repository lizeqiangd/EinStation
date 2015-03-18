package com.thehorizon.com.thehorizonabstcom.zcom.thehorizonweitehorizontracts
{
	impcom.thehorizonort com.greensock.TweenLite;
	import com.thehorizon.LayerManager;
	import com.zweitehorizont.BaseObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class BaseMark extends Sprite
	{
		private var displayLayer:String = "TopLayer"
		private var markName:String = "unnameed"
		private var baseObject:BaseObject
		private var nextLocationPoint:Point
		private var layerManager:LayerManager
		private var isDisplayed:Boolean = false
		
		public function BaseMark()
		{
		
		}
		
		public function dispose():void
		{
		
		}
		
		public function set setLayerManager(value:LayerManager):void
		{
			this.layerManager = value
		}
		
		public function get getNextLocationPoint():Point
		{
			return nextLocationPoint
		}
		
		public function set setNextLocationPoint(value:Point):void
		{
			this.nextLocationPoint = value
			//test
			if (this.isDisplayed)
			{
				TweenLite.to(this, 1, {x: value.x, y: value.y})
			}
			else
			{
				isDisplayed = !isDisplayed
				layerManager.addObjectToLayer(this)
			}
		}
		
		public function get getDisplayName():String
		{
			return displayLayer
		}
		
		public function set setDisplayName(value:String):void
		{
			this.displayLayer = value
		}
		
		public function get getMarkName():String
		{
			return markName
		}
		
		public function set setMarkName(value:String):void
		{
			this.markName = value
		}
		
		public function get getBaseObject():BaseObject
		{
			return baseObject;
		}
		
		public function set setBaseObject(value:BaseObject):void
		{
			baseObject = value;
		}
	}

}