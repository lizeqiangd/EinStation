package com.zweisystem.applications.PsychoPass.addon
{
	import com.greensock.TweenLite;
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.interfaces.textfield.SimpleText;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.system.proxy.StageProxy;
	import flash.display.Sprite;
	import com.zweisystem.modules.imagedisplay.ImageDisplay;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class UserPsychoPassBar extends Sprite
	{
		
		private var avatarIcon:ImageDisplay
		private var psychoColor:Sprite
		private var psychoArray:Sprite
		private var simpleText:SimpleText
		private var _dataProvider:Object
		
		public function UserPsychoPassBar()
		{
			this.addEventListener(MouseEvent.CLICK, onClick)
		}
		
		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new UnitEvent(UnitEvent.CLICK, _dataProvider))
		}
		
		public function dataProvider(e:Object)
		{
			_dataProvider = e
			simpleText = new SimpleText
			simpleText.x = 55
			simpleText.text = "NAME:" + e.screen_name + " uid:" + e.uid + " Psycho-Pass:" + e.psycho_pass + " CreateDate:" + e.create_date+"  id:"+e.id
			try
			{
				avatarIcon = new ImageDisplay
				avatarIcon.load(e.profile_image_url)
				addChild(avatarIcon)
				avatarIcon.alpha = 0
				var arr:Array = []
				arr = e.psycho_pass_array.split("-")
				
				psychoColor = new Sprite
				psychoArray = new Sprite
				psychoColor.x = 55
				psychoColor.y = 30
				psychoColor.graphics.beginFill(e.mental_color)
				psychoColor.graphics.drawRect(0, 0, 100, 20)
				for (var i:int; i < arr.length; i++)
				{
					psychoArray.graphics.beginFill(0, arr[i] / 5)
					psychoArray.graphics.drawRect(i, 0, 1, 20)
				}
				psychoColor.graphics.endFill()
				psychoColor.addChild(psychoArray)
				this.addChild(psychoColor)
				psychoColor.alpha = 0
					//psychoColor.width = 50
			}
			catch (e:*)
			{
			}
		}
		
		public function init(fulldisplay:Boolean = true)
		{
			if (fulldisplay)
			{
				
				StageProxy.addEventListener(Event.RESIZE, onStageResize)
				TweenLite.to(psychoColor, 1, {width: StageProxy.stageWidth, overwrite: 3, onComplete: onAnimeComplete})
				AnimationManager.fade_in(avatarIcon)
				simpleText.x = 55
				addChild(simpleText)
				TextAnimation.Typing(simpleText)
				psychoColor.alpha = 1
			}
			else
			{
				TweenLite.to(psychoColor, 1, {width: 300, overwrite: 3, onComplete: onAnimeComplete})
				AnimationManager.fade_in(avatarIcon)
				simpleText.x = 55
				addChild(simpleText)
				TextAnimation.Typing(simpleText)
				psychoColor.alpha = 1
			}
		}
		
		private function onAnimeComplete():void
		{
			//StageProxy.removeResizeFunction(onStageResize)
		}
		
		private function onStageResize(e:Event):void
		{
			TweenLite.to(psychoColor, 1, {width: StageProxy.stageWidth - 55, overwrite: 3, onComplete: onAnimeComplete})
		}
	}

}