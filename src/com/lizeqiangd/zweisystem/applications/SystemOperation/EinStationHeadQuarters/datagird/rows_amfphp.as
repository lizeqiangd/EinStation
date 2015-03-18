package com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters.datagird
{
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.modules.datagird.BaseRow;
	import flash.events.MouseEvent;
	
	/**
	 * datagird
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class rows_amfphp extends BaseRow
	{
		
		public function rows_amfphp()
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
			eventDispatcher.dispatchEvent(new UnitEvent(UnitEvent.CLICK, tx_id.text))
		}
		
		private function onInitCompleted(e:UnitEvent):void
		{
			tx_description.text = data.description
			tx_id.text = data.id
			tx_name.text = data.name
		}
		//rows animation
		public function rowsAnimationInit()
		{
			tx_description.text = ""
			tx_id.text = ""
			tx_name.text = "";
			mc_background.alpha = 0
			AnimationManager.fade(mc_background, getRowsCurrentAlpha, getIsOdd ? 1 : 2)
		}
		
		public function rowsAnimation()
		{
			tx_description.text = data.description
			tx_id.text = data.id
			tx_name.text = data.name
			TextAnimation.Typing(tx_description)
			TextAnimation.Typing(tx_id)
			TextAnimation.Typing(tx_name)
		
		}
		//释放
		public function dispose()
		{
			removeRowsListener()
			tx_description = null
			tx_id = null
			tx_name = null
		}
	}

}