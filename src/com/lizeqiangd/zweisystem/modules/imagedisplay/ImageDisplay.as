package com.lizeqiangd.zweisystem.modules.imagedisplay
{
	
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.events.NetEvent;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.junkbyte.console.Cc;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	/**
	 *ImageDisplay,通过简易方法封装ImageLoader.其次加入了Console进行错误反馈.
	 * 使用方法:
	 * var id:ImageDisplay=new ImageDisplay()
	 * addChild(id)
	 * id.proportionalOutside(80,80)
	 * id.load("1.jpg")
	 *
	 * @author:Lizeqiangd
	 * @update
	 * 2014.03.29 删除多余方法,更改路径,增加注释
	 */
	public class ImageDisplay extends Sprite
	{
		private var mc_mask:Shape;
		private var _loader:ImageLoader;
		private var state:String = "ready";
		private var _config:Object;
		private var _code:int;
		private var _url:String;
		private var _useMask:Boolean;
		//拉伸
		public static const stretch:String = "stretch";
		//原图
		public static const none:String = "none";
		//按照宽决定缩放
		public static const widthOnly:String = "widthOnly";
		//按照高决定缩放
		public static const heightOnly:String = "heightOnly";
		//取决于图最突出的部分在外
		public static const proportionalOutside:String = "proportionalOutside";
		//取决于图最突出的部分在内
		public static const proportionalInside:String = "proportionalInside";
		
		/**
		 * 构造函数.生成本图片的一个随机ID.然后建立本图片的一个遮罩层.
		 */
		public function ImageDisplay()
		{
			_code = Math.round(Math.random() * 1000);
			
			//遮罩
			mc_mask = new Shape;
			mc_mask.graphics.beginFill(0xffffff, 0);
			mc_mask.graphics.drawRect(0, 0, 10, 10);
			mc_mask.x = 0;
			mc_mask.y = 0;
			addChild(mc_mask);
			
			configNone();
			state = "ready";
		}
		
		/**
		 * 读取图片,需要图片url.不支持多重跳转
		 */
		public function load(url:String):void
		{
			if (state != "ready")
			{
				unload();
			}
			_url = url;
			Cc.log("ImageDisplay" + _code + ":Loading image url:", url);
			_loader = new ImageLoader(url, _config);
			_loader.load(true);
			state = "loading";
		}
		
		/**
		 * 卸载图片,调用loader的unload()
		 */
		public function unload():void
		{
			if (state !== "ready")
			{
				state = "unload";
				_loader.unload();
			}
		}
		
		/**
		 * 设置图片的长宽以及缩放模式.默认为:100x100,proportionalOutside模式
		 */
		public function config(_Width:Number = 100, _Height:Number = 100, _scaleMode:String = "proportionalOutside"):void
		{
			_config = {name: "content", estimatedBytes: 3000, width: _Width, height: _Height, scaleMode: _scaleMode, hAlign: "center", vAlign: "center", onProgress: onProgressHandler, onError: onErrorHandler, onComplete: onCompleteHandler};
		}
		
		/**
		 * proportionalOutside模式下,设置图片的长宽,同时询问是否要遮罩.默认为:100x100,
		 */
		public function configProportionalOutside(_Width:Number = 100, _Height:Number = 100, _useMask:Boolean = false):void
		{
			_config = {name: "content", estimatedBytes: 3000, width: _Width, height: _Height, scaleMode: "proportionalOutside", hAlign: "center", vAlign: "center", onProgress: onProgressHandler, onError: onErrorHandler, onComplete: onCompleteHandler};
			this._useMask = _useMask;
			mc_mask.width = _Width;
			mc_mask.height = _Height;
		}
		
		/**
		 * widthOnly模式下,设置图片的宽度.
		 */
		public function configWidthOnly(_Width:Number = 100):void
		{
			_config = {name: "content", estimatedBytes: 3000, width: _Width, scaleMode: "widthOnly", hAlign: "center", vAlign: "center", onProgress: onProgressHandler, onError: onErrorHandler, onComplete: onCompleteHandler};
		}
		
		/**
		 * heightOnly模式下,设置图片的高度
		 */
		public function configHeightOnly(_Height:Number = 100):void
		{
			_config = {name: "content", estimatedBytes: 3000, height: _Height, scaleMode: "heightOnly", hAlign: "center", vAlign: "center", onProgress: onProgressHandler, onError: onErrorHandler, onComplete: onCompleteHandler};
		}
		
		/**
		 * none模式,原图加载.你什么都不用管
		 */
		public function configNone():void
		{
			_config = {name: "content", estimatedBytes: 3000, scaleMode: "none", hAlign: "center", vAlign: "center", onProgress: onProgressHandler, onError: onErrorHandler, onComplete: onCompleteHandler};
		}
		
		/**
		 * 销毁本ImageDisplay
		 */
		public function dispose():void
		{
			if (_loader)
			{
				_loader.dispose(true);
			}
		}
		
		/**
		 * 加载图片的时候将progress数值发出
		 */
		private function onProgressHandler(e:LoaderEvent):void
		{
			dispatchEvent(new NetEvent(NetEvent.PROGRESSING, e.target.progress));
			//trace("ImageDisplay"+_code+":" +e.target.progress);
		}
		
		/**
		 * 加载错误的时候的事件
		 */
		private function onErrorHandler(e:LoaderEvent):void
		{
			Cc.error("ImageDisplay" + _code + ": load url(" + _url + ") fault!");
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			state = "fault";
		}
		
		/**
		 * 完成加载的时候,调度Event.Complete事件,同时显示图片
		 */
		private function onCompleteHandler(e:LoaderEvent):void
		{
			this.addChildAt(_loader.content, 0);
			state = "complete";
			dispatchEvent(new Event(Event.COMPLETE));
			if (_useMask)
			{
				//mc_mask.mask = _loader.content;
				_loader.content.mask = mc_mask;
			}
		}
		
		/**
		 * 返回加载的url地址
		 */
		public function get url():String
		{
			return this._url;
		}
		
		/**
		 * 返回加载核心 GreenSock的Loader
		 */
		public function get loader():ImageLoader
		{
			return _loader
		}
	
	}
}