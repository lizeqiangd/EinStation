package com.thehorizon.manager
{
	import com.thehorizoncom.thehorizon.BaseLayer;
	import com.thehorizon.abstracts.BaseMark;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class LayerManager
	{
		private var RadiationLayer:BaseLayer
		private var RouteLayer:BaseLayer
		private var MarkLayer:BaseLayer
		private var MessageLayer:BaseLayer
		private var TopLayer:BaseLayer
		private var MainContainer:Sprite
		
		public function LayerManager()
		{
		
		}
		
		public function init(maincontainer:Sprite):void
		{
			MainContainer = maincontainer
			RadiationLayer = new BaseLayer("RadiationLayer")
			RouteLayer = new BaseLayer("RouteLayer")
			MarkLayer = new BaseLayer("MarkLayer")
			MessageLayer = new BaseLayer("MessageLayer")
			TopLayer = new BaseLayer("TopLayer")
			MainContainer.addChild(RadiationLayer.getContainer)
			MainContainer.addChild(RouteLayer.getContainer)
			MainContainer.addChild(MarkLayer.getContainer)
			MainContainer.addChild(MessageLayer.getContainer)
			MainContainer.addChild(TopLayer.getContainer)
		}
		
		public function addObjectToLayer(e:*):void
		{
			switch (BaseMark(e).getDisplayName.toLowerCase)
			{
				case RadiationLayer.getLayerName.toLowerCase: 
					RadiationLayer.container.addChild(e)
					break
				case RouteLayer.getLayerName.toLowerCase: 
					RouteLayer.container.addChild(e)
					break
				case MarkLayer.getLayerName.toLowerCase: 
					MarkLayer.container.addChild(e)
					break
				case MessageLayer.getLayerName.toLowerCase: 
					MessageLayer.container.addChild(e)
					break
				case TopLayer.getLayerName.toLowerCase: 
					TopLayer.container.addChild(e)
					break
				default: 
					trace("LayerManager:没有定义的LayerName")
					TopLayer.container.addChild(e)
					break
			
			}
		
		}
	}

}