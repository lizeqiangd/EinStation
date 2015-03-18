package com.thehorizon.abstracts
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class BaseLayer
	{
		private var _layername:String = "unknown"
		public var container:Sprite
		
		public function BaseLayer(LayerName:String)
		{
			_layername = LayerName
			container = new Sprite
		}
		
		public function get getContainer():Sprite
		{
			return container
		}
		
		public function get getLayerName():String
		{
			return _layername
		}
	}

}