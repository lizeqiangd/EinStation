package com.lizeqiangd.zweisystem.abstract.layers
{
	import flash.display.Sprite;
/**
 * 该类是所有显示层对象的基类.用于显示层内容.目前情况下不需要作任何更改,以后有机会在弄
 * @update:2014.03.30 增加注释
 */
	public class Layer extends Sprite
	{
		public var layerName:String;
		public var layerIndex:int;
		public function Layer(n:String="unknownLayer",i:int=0)
		{
			super();
			layerName = n;
			layerIndex=i
		}
	}
}