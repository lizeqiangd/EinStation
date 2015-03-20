package com.lizeqiangd.zweisystem.modules.imagedisplay
{
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.events.NetEvent;
	import com.lizeqiangd.zweisystem.events.AnimationEvent;
	import com.lizeqiangd.zweisystem.system.config.ESSetting;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.setTimeout
	
	/**
	 * 扩展ImageDisplay用于单一画面多个图片切换,一个MutilImageDisplay拥有2个ImageDisplay实例
	 * 通过切换2个实例来制作无缝画面转换.
	 * @author:Lizeqiangd
	 * update 2014.03.29 增加注释.
	 * 2014.05.17 修正大小居中问题.
	 */
	public class MutilImageDisplay extends Sprite
	{
		private var im1:ImageDisplay;
		private var im2:ImageDisplay;
		private var state:String = "init";
		private var _nowUsingCore:uint = 0;
		
		/**
		 * 构造函数,初始化2个ImageDisplay
		 */
		public function MutilImageDisplay():void
		{
			im1 = new ImageDisplay;
			im2 = new ImageDisplay;
			/*im1.visible = false;
			 im2.visible = false;*/
			addChild(im1);
			//addChild(im2);
			addUiListener();
		}
		
		/**
		 * 添加MutilImageDisplay的侦听器用
		 */
		private function addUiListener():void
		{
			im1.addEventListener(Event.COMPLETE, onCompleteHandler);
			im2.addEventListener(Event.COMPLETE, onCompleteHandler);
			im1.addEventListener(NetEvent.PROGRESSING, onProgress);
			im2.addEventListener(NetEvent.PROGRESSING, onProgress);
			im1.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			im2.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		
		/**
		 * 移除MutilImageDisplay所有侦听器用
		 */
		private function removeUiLIstener():void
		{
			im1.removeEventListener(Event.COMPLETE, onCompleteHandler);
			im2.removeEventListener(Event.COMPLETE, onCompleteHandler);
			im1.removeEventListener(NetEvent.PROGRESSING, onProgress);
			im2.removeEventListener(NetEvent.PROGRESSING, onProgress);
			im1.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			im2.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
		}
		
		/**
		 * 自动切换2个核心.
		 */
		public function load(_url:String):void
		{
			if (_nowUsingCore == 0)
			{
				im1.load(_url);
			}
			if (_nowUsingCore == 1)
			{
				im2.load(_url);
			}
			if (_nowUsingCore == 2)
			{
				im1.load(_url);
			}
			state = "loading" + _nowUsingCore;
		
		}
		
		/**
		 * 调度progessing事件,并反馈数值
		 */
		private function onProgress(e:NetEvent):void
		{
			dispatchEvent(new NetEvent(NetEvent.PROGRESSING, e.data));
		}
		
		/**
		 * 当加载失败的时候,会反馈信息.
		 */
		private function onIOErrorHandler(e:IOErrorEvent):void
		{
			dispatchEvent(e);
		}
		
		/**
		 * 当第一个加载好的时候,会自动调用AnimationManager.fate_in()方法进行无缝切换
		 */
		private function onCompleteHandler(e:Event):void
		{
			dispatchEvent(e);
			if (_nowUsingCore == 0)
			{
				AnimationManager.fade_in(im1);
				state = "complete" + _nowUsingCore;
				_nowUsingCore = 1;
				return;
			}
			if (_nowUsingCore == 1)
			{
				addChild(im2)
				AnimationManager.fade_out(im1);
				AnimationManager.fade_in(im2);
				setTimeout(onAnimeDone, ESSetting.AnimationManagerTime + 0.1)
				_nowUsingCore = 2;
				return;
			}
			if (_nowUsingCore == 2)
			{
				addChild(im1)
				AnimationManager.fade_in(im1);
				AnimationManager.fade_out(im2);
				setTimeout(onAnimeDone, ESSetting.AnimationManagerTime + 0.1)
				_nowUsingCore = 1;
				return;
			}
			im1.x = 0
			im2.x = 0
			im1.y = 0
			im2.y = 0
		
		}
		
		private function onAnimeDone():void
		{
			if (_nowUsingCore == 1)
			{
				removeChild(im2)
				return;
			}
			if (_nowUsingCore == 2)
			{
				removeChild(im1)
				return;
			}
			im1.x = 0
			im2.x = 0
			im1.y = 0
			im2.y = 0
		}
		
		/**
		 * 销毁本实例..
		 */
		public function dispose():void
		{
			removeUiLIstener();
			im1.dispose();
			im2.dispose();
			im1 = null;
			im2 = null;
		}
		
		/**
		 * 设置图片的长宽以及缩放模式.默认为:100x100,proportionalOutside模式
		 */
		public function config(_Width:Number = 100, _Height:Number = 100, _scaleMode:String = "proportionalOutside"):void
		{
			im1.config(_Width, _Height, _scaleMode)
			im2.config(_Width, _Height, _scaleMode)
		}
		
		/**
		 * proportionalOutside模式下,设置图片的长宽,同时询问是否要遮罩.默认为:100x100,
		 */
		public function configProportionalOutside(_Width:Number = 100, _Height:Number = 100, _useMask:Boolean = false):void
		{
			im1.configProportionalOutside(_Width, _Height, _useMask)
			im2.configProportionalOutside(_Width, _Height, _useMask)
		}
		
		/**
		 * widthOnly模式下,设置图片的宽度.
		 */
		public function configWidthOnly(_Width:Number = 100):void
		{
			im1.configWidthOnly(_Width)
			im2.configWidthOnly(_Width)
		}
		
		/**
		 * heightOnly模式下,设置图片的高度
		 */
		public function configHeightOnly(_Height:Number = 100):void
		{
			im1.configHeightOnly(_Height)
			im2.configHeightOnly(_Height)
		}
		
		/**
		 * none模式,原图加载.你什么都不用管
		 */
		public function configNone():void
		{
			im1.configNone()
			im2.configNone()
		}
	}
}