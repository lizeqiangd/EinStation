package com.zweisystem.applications.PsychoPass.actives
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.events.ActiveEvent;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import com.zweisystem.system.proxy.StageProxy;
	import flash.utils.setTimeout
	
	public class MentalColorActive extends BaseActive implements iActive
	{
		private var h:int = 0;
		private var w:int = 0
		private var totalColor:Number = 0;
		private var mc_ts:Sprite
		private var bm:BitmapData = new BitmapData(180, 180);
		
		public function MentalColorActive()
		{
			super("MentalColorActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			tx_title.text = "Mental Color"
			tx_text1.text = ""
			tx_text2.text = ""
		}
		
		public function init()
		{
			tx_text1.text = "calculating"
			TextAnimation.Changing(tx_text1, TextAnimation.ALPHABET, 1, true)
			StageProxy.addEnterFrameFunction(loadColor);
			mc_ts = new Sprite
			mc_ts.x = 130
			mc_ts.y = 45
			this.addChildAt(mc_ts, 0)
		}
		
		private function loadColor():void
		{
			
			if (h > 180)
			{tx_text1.visible=true
				StageProxy.removeEnterFrameFunction(loadColor);
				mc_ts.graphics.clear()
				mc_ts.graphics.beginFill(totalColor / (32400))
				mc_ts.graphics.drawRect(0, 0, 50, 60)
				calculated()
				this.getAcitveManager.movein("PsychoPassActive", "p3", "right")
				return
			}
			for (var i:int; i < 90; i++)
			{
				totalColor += bm.getPixel(w, h);
				w++;
				if (w > 180)
				{
					h++;
					w = 0
				}
			}
			tx_text1.visible = !tx_text1.visible
			tx_text2.text = String((totalColor / (32400))) //
			mc_ts.graphics.clear()
			mc_ts.graphics.beginFill(bm.getPixel(w, h))
			mc_ts.graphics.drawRect(0, 0, 50, 60)
		
		}
		
		private function calculated()
		{
			tx_text2.text = (totalColor / (32400)).toString(16)
			tx_text1.text = "Calculated"
			TextAnimation.Changing(tx_text1, TextAnimation.ALPHABET, 1, true)
			TextAnimation.Changing(tx_text2, TextAnimation.ALPHABET + TextAnimation.NUMBER, 1, true)
			setTimeout(afterAnime, 1600);
			setTimeout(afterAnime2, 3200);
			host.applicationMessage( { type:"MentalColor", data:totalColor / (32400) } )
			this.getActive("PsychoColorActive").activeMessage({type:"MentalColor",data:totalColor / (32400)})
		}
		
		private function afterAnime():void
		{
			tx_text1.text = "计算结束"
			TextAnimation.Changing(tx_text1, TextAnimation.CHINESE, 1, true)
		}
		
		private function afterAnime2():void
		{
			tx_text1.text = "色相为："
			TextAnimation.Changing(tx_text1, TextAnimation.CHINESE, 1, true)
		}
		
		private function addUiListener()
		{
		
		}
		
		private function removeUiListener()
		{
		
		}
		
		public function activeMessage(msg:Object)
		{
			bm.draw(DisplayObject(msg))
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
		
		}
	}

}