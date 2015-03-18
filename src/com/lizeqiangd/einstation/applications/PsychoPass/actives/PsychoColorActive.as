package com.zweisystem.applications.PsychoPass.actives
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.greensock.TweenLite;
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.events.ActiveEvent;
	import flash.display.Sprite;
	import flash.utils.setTimeout
	
	public class PsychoColorActive extends BaseActive implements iActive
	{
		private var mc_color:Sprite
		private var mc_psycho:Sprite
		
		private var arr:Array = []
		private var color:uint = 0
		
		public function PsychoColorActive()
		{
			super("PsychoColorActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			mc_mask.x = 10
			mc_mask.y = 40
			mc_mask.height = 30
			mc_mask.width = 1
			mc_mask.visible = false
			tx_title.text = ""
		}
		
		public function init()
		{ //1040400
			mc_mask.visible = true
			tx_title.text = "Mental Color Analyzes"
			TextAnimation.Changing(tx_title, TextAnimation.ALPHABET, 1, true)
			mc_color = new Sprite
			mc_psycho = new Sprite
			var w:int = 400 / 100
			mc_color.x = 10
			mc_color.y = 40
			mc_color.graphics.beginFill(color)
			mc_color.graphics.drawRect(0, 0, 400, 30)
			for (var i:int; i < arr.length; i++)
			{
				mc_psycho.graphics.beginFill(0, arr[i] / 5)
				mc_psycho.graphics.drawRect(i * w, 0, w, 30)
			}
			mc_color.graphics.endFill()
			mc_color.addChild(mc_psycho)
			this.addChildAt(mc_color, 0)
			mc_color.mask = mc_mask
			TweenLite.to(mc_mask, 1, {width: 400})
			setTimeout(animeOK, 1300)
		}
		
		private function animeOK():void
		{
			host.applicationMessage({type: "CalculationComplete"})
		}
		
		private function addUiListener()
		{
		
		}
		
		private function removeUiListener()
		{
		
		}
		
		public function activeMessage(msg:Object)
		{
			switch (msg.type)
			{
				case "PsychoPassArray": 
					arr = msg.data
					break;
				case "MentalColor": 
					color = msg.data
					break;
				default: 
					break;
			}
		
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			init()
			addUiListener()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			removeUiListener()
		}
		
		public function dispose()
		{
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
			mc_color.graphics.clear()
			mc_psycho.graphics.clear()
			this.removeChildren()
		}
	}

}