package com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters.datagird
{
	import flash.events.MouseEvent;
	
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.modules.datagird.BaseRow;
	
	/**
	 * DataGirdRows 请配合模板使用。
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class rows_users extends BaseRow
	{
		
		public function rows_users()
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
		
		private function onInitCompleted(e:UnitEvent=null):void
		{
			//trace("test user rows",data.cid)
			//data
			tx_cid.text = data.cid+""
			tx_uid.text = data.uid+""
			tx_sid.text = data.sid+""
			tx_display_name.text = data.display_name+""
			tx_user_type.text = data.user_type+""
		}
		
		//rows animation
		public function rowsAnimationInit()
		{
			tx_cid.text = ""
			tx_uid.text =""
			tx_sid.text = ""
			tx_display_name.text = ""
			tx_user_type.text =""
			mc_background.alpha = 0
			AnimationManager.fade(mc_background, getRowsCurrentAlpha, getIsOdd ? 1 : 2)
		}
		
		public function rowsAnimation()
		{
			onInitCompleted()
			TextAnimation.Typing(tx_cid)
			TextAnimation.Typing(tx_uid)
			TextAnimation.Typing(tx_sid)
			TextAnimation.Typing(tx_display_name)
			TextAnimation.Typing(tx_user_type)
		}
		
		//释放
		public function dispose()
		{
			removeRowsListener()
			tx_uid = null
			tx_cid = null
			tx_display_name = null
			tx_sid = null
			tx_user_type = null
		}
	}
}