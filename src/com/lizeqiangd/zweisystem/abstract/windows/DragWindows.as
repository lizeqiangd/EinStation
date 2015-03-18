package com.lizeqiangd.zweisystem.abstract.windows
{
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import flash.events.MouseEvent;
	
	/** DragWindows 程序可以被拖动。
	 * 2013.01.27修改了点击关系，修改了应用事件
	 * 2014.03.28修正bug,备注方法,修正路径.
	 */
	public class DragWindows extends AnimeWindows
	{
		private var dragAble:Boolean = true
		
		/**
		 *DragWindows 构造函数,添加2个侦听器:程序开始关闭,程序初始化完成.
		 */
		public function DragWindows()
		{
			this.addEventListener(ApplicationEvent.CLOSE, onDragWindowsCloseHangle);
			this.addEventListener(ApplicationEvent.INITED, onDragWindiowsInitedHandle);
		}
		
		/**
		 *当程序初始化完成的时候,对程序添加拖拽侦听
		 */
		private function onDragWindiowsInitedHandle(e:ApplicationEvent)
		{
			this.removeEventListener(ApplicationEvent.INITED, onDragWindiowsInitedHandle);
			
				this.sp_background.addEventListener(MouseEvent.MOUSE_DOWN, onDragWindowsStartDrag);
				stage.addEventListener(MouseEvent.MOUSE_UP, onDragWindowsStopDrag, false, 0, true);
					//stage.addEventListener(MouseEvent.RELEASE_OUTSIDE, onDragWindowsStopDrag, false, 0, true);
			
		}
		
		/**
		 *当程序开始关闭的时候,移除本抽象类的侦听器
		 */
		private function onDragWindowsCloseHangle(e:ApplicationEvent)
		{
			this.removeEventListener(ApplicationEvent.CLOSE, this.onDragWindowsCloseHangle);
			this.sp_background.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDragWindowsStartDrag);
			
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onDragWindowsStopDrag);
			//StageProxy.stage.removeEventListener(Event.MOUSE_LEAVE,onUIStopDrag);
		}
		
		/**
		 *当拖动开始的时候的操作.同时也是子类拖动用的方法.
		 */
		protected function onDragWindowsStartDrag(e:MouseEvent):void
		{
			if (dragAble)
			{
				this.startDrag();
			}
		}
		
		/**
		 *当拖动结束的时候,如果窗口已经飞离舞台,则重新让它回到舞台.
		 */
		protected function onDragWindowsStopDrag(e:MouseEvent):void
		{
			this.stopDrag();
			PositionUtility.setDisplayBackToStage(this)
		}
		
		/**
		 *设置背景色块的alpha属性
		 */
		public function set setBgAlpha(e:Number)
		{
			AnimationManager.fade(this.sp_background, e)
		}
		
		/**
		 *设置是否可以拖拽本窗口
		 */
		public function set setDragEnable(e:Boolean)
		{
			this.stopDrag();
			dragAble = e
		}
		
		/**
		 *获取当前窗口是否可以拖拽.
		 */
		public function get getDragEnable():Boolean
		{
			return dragAble
		}
	
	}
}