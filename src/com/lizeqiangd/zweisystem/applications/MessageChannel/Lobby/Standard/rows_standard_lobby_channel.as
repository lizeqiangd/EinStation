package com.lizeqiangd.zweisystem.applications.MessageChannel.Lobby.Standard
{
	
	import com.lizeqiangd.zweitehorizont.data.message.MessageChannel;
	import flash.events.MouseEvent;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.modules.datagird.BaseRow;
	import com.lizeqiangd.zweisystem.modules.datagird.iDataGirdRow;
	
	/**
	 * DataGirdRows
	 * @author lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website $(DefaultSite)
	 */
	public class rows_standard_lobby_channel extends BaseRow
	{
		
		public function rows_standard_lobby_channel()
		{
			this.oddAlpha = 0.3
			this.evenAlpha = 0.5
			addRowsListener()
		}
		
		/**
		 * 添加本Row的全部侦听器
		 */
		private function addRowsListener():void
		{
			mc_background.addEventListener(MouseEvent.CLICK, onRowsClicked)
			this.addEventListener(UnitEvent.UNIT_COMPLETED, onInitCompleted)
		}
		
		/**
		 * 移除本Row的全部侦听器
		 */
		private function removeRowsListener():void
		{
			this.removeEventListener(UnitEvent.UNIT_COMPLETED, onInitCompleted)
			mc_background.removeEventListener(MouseEvent.CLICK, onRowsClicked)
		}
		
		/**
		 * 当背景按钮被点击的时候,作为一般Row默认的方法,可以随意更改.接口没有声明此方法.该方法使用的eventDisplatch是在DataGird里面的,因此记得传递参数
		 */
		private function onRowsClicked(e:MouseEvent):void
		{
			this.eventDispatcher.dispatchEvent(new UnitEvent(UnitEvent.CLICK,data))
		}
		
		/**
		 * 当初始化结束后,应该在此方法内将内容填充到各个文本框中等操作.
		 */
		private function onInitCompleted(e:UnitEvent = null):void
		{
			var mc:MessageChannel = data.channel
			tx_id.text = mc.channel_data.channel_id + ""
			tx_channel_name.text = mc.channel_data.channel_name
			tx_channel_creator_display_name.text = mc.channel_data.channel_creator.display_name
			tx_channel_type.text = mc.channel_data.channel_type
			tx_user_count.text = data.user_count
		}
		
		/**
		 * 这是本Row的 动画初始化 方法,也就是动画开始的第一帧所要表现的状态.
		 */
		public function rowsAnimationInit()
		{
			
			mc_background.alpha = 0
			AnimationManager.fade(mc_background, getRowsCurrentAlpha, getIsOdd ? 1 : 2)
		}
		
		/**
		 * 这是本Row 动画被激活 的状态,由各个Row自己执行自己的动画表现效果.DataGird只会一帧帧宣布到谁执行了.
		 * 不会处理其他内容.
		 */
		public function rowsAnimation()
		{
			TextAnimation.Typing(tx_channel_name)
			TextAnimation.Typing(tx_channel_creator_display_name)
			TextAnimation.Typing(tx_channel_type)
		
		}
		
		/**
		 * 销毁本类
		 */
		public function dispose()
		{
			removeRowsListener()
			data = null
		}
	}
}