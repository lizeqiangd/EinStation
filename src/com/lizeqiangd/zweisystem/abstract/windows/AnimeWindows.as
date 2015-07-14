package com.lizeqiangd.zweisystem.abstract.windows
{
	import com.lizeqiangd.zweisystem.events.AnimationEvent;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.system.config.ESSetting;
	
	/** AnimeWindows 是窗口打开后有动画产生的窗口
	 * 2013.01.27 修改了函数名称，使得更容易理解，且修改了应用事件
	 * 2014.03.28 增加所有注释,更改代码路径.
	 */
	
	public class AnimeWindows extends BaseWindows
	{
		/**
		 * 默认开启动画效果和默认关闭动画效果分别是
		 * 淡入和模糊淡出.
		 */
		private var defaultOpeningAnimeType:String = ESSetting.AnimeWindowsDefaultOpeningAnimation
		private var defaultClosingAnimeType:String = ESSetting.AnimeWindowsDefaultClosingAnimation
		
		/**
		 * AnimeWindows的构造函数,添加事件侦听器,程序打开完成,程序开始关闭,动画打开结束,动画关闭结束.
		 */
		public function AnimeWindows()
		{
			//trace("AnimeWindows 构造函数");
			this.visible = false;
			this.alpha = 0;
			this.addEventListener(ApplicationEvent.INIT, onPassAnimation);
			this.addEventListener(ApplicationEvent.OPENED, onAnimeWindwosOpenedHangle);
			this.addEventListener(ApplicationEvent.CLOSE, onAnimeWindwosCloseHangle);
			this.addEventListener(AnimationEvent.OPENED, onAnimeOpened);
			this.addEventListener(AnimationEvent.CLOSED, onAnimeClosed);
		}
		
		/**
		 * 提供方法给直接跳过动画的.
		 * @param	e
		 */
		private function onPassAnimation(e:ApplicationEvent):void 
		{
			this.visible = true;
			this.alpha = 1;
		}
		
		/**
		 * 当AnimeWindows打开完成时调度,移除侦听器打开完成,同时调度AnimationManager.open作为开启动画.
		 * 用途是当程序初始化完成后,系统才能得知该窗口的具体大小,因此在此时执行动画为佳,同一帧的最后状态激活,第二帧开始动画.
		 */
		private function onAnimeWindwosOpenedHangle(e:ApplicationEvent):void
		{
			this.removeEventListener(ApplicationEvent.OPENED, onAnimeWindwosOpenedHangle);
			AnimationManager.open(this, defaultOpeningAnimeType);
		}
		
		/**
		 * 当程序开始关闭的时候的方法,启用AnimationManager.close
		 */
		private function onAnimeWindwosCloseHangle(e:ApplicationEvent):void
		{
			this.removeEventListener(ApplicationEvent.CLOSE, onAnimeWindwosCloseHangle);
			AnimationManager.close(this, defaultClosingAnimeType);
		}
		
		/**
		 * 当开启动画结束的时候调用.
		 */
		private function onAnimeOpened(e:AnimationEvent):void
		{
			this.removeEventListener(AnimationEvent.OPENED, onAnimeOpened);
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.INIT));
		}
		
		/**
		 * 当关闭动画结束的时候调用.
		 */
		private function onAnimeClosed(e:AnimationEvent):void
		{
			this.removeEventListener(AnimationEvent.CLOSED, onAnimeClosed);
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSED));
		}
		
		/**
		 * 设置开启动画的名称.需要在AnimationManager内注册
		 */
		public function set setOpeningAnimationType(s:String):void
		{
			defaultOpeningAnimeType = s;
		}
		
		/**
		 * 设置关闭动画的名称.需要在AnimationManager内注册
		 */
		public function set setClosingAnimationType(s:String):void
		{
			defaultClosingAnimeType = s;
		}
	}
}