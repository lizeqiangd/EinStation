package com.zweisystem.applications.GraduationHelper.datagird
{
	import flash.events.MouseEvent;
	
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.modules.datagird.BaseRow;
	
	/**
	 * DataGirdRows 请配合模板使用。
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	public class rows_class extends BaseRow
	{
		
		public function rows_class()
		{
			this.oddAlpha = 0.3
			this.evenAlpha = 0.5
			addRowsListener()
		}
		
		//侦听器
		public function addRowsListener():void
		{
			mc_background.addEventListener(MouseEvent.CLICK, onRowsClicked)
			this.addEventListener(UnitEvent.UNIT_COMPLETED, onInitCompleted)
		}
		
		public function removeRowsListener():void
		{
			this.removeEventListener(UnitEvent.UNIT_COMPLETED, onInitCompleted)
			mc_background.removeEventListener(MouseEvent.CLICK, onRowsClicked)
		}
		
		//事件响应
		private function onRowsClicked(e:MouseEvent):void
		{
			dispatchEvent(new UnitEvent(UnitEvent.CLICK))
		}
		
		private function onInitCompleted(e:UnitEvent = null):void
		{
			tx_name.text = data.name
			tx_point.text = data.point
			this.classType(data.type)
		}
		
		public function classType(type:String)
		{
			switch (type)
			{
				case "zhbx": 
					this.color(0xff3366)
					break;
				case "zybx": 
					this.color(0x3399ff)
					break;
				case "zyxx": 
					this.color(0x66ff66)
					break;
				case "ggxx": 
					this.color(0xff9900)
					break;
			}
		}
		
		public function color(color:uint)
		{
			AnimationManager.changeColor(mc_bg, color, true)
		}
		
		//rows animation
		public function rowsAnimationInit()
		{
			
			mc_background.alpha = 0
			AnimationManager.fade(mc_background, getRowsOriginalAlpha, getIsOdd ? 1 : 2)
		}
		
		public function rowsAnimation()
		{
			onInitCompleted(null)
			TextAnimation.Typing(tx_name)
			TextAnimation.Changing(tx_point, "123456789")
		}
		
		//释放
		public function dispose()
		{
			removeRowsListener()
		}
	}
}