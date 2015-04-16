package com.lizeqiangd.zweisystem.abstract.active
{
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/***
	 * EinStation 亮点应用。用于模块化应用。让模块在应用中有特殊动画效果表现
	 * @author Lizeqiangd
	 * 2013.02.12 接纳View为特殊Active模式。
	 * 2014.03.24 重新审查代码
	 * 2015.04.10 为纯as3化做准备.
	 */
	public class ActiveManager extends Sprite
	{
		public static const TweenTime:int = 1;
		public static const TweenDistence:int = 100;
		protected var _host:iApplication;
		protected var _ActiveArray:Array;
		private var _regPointArray:Array;
		
		/**
		 * 构造方法,将宿主程序当作参数输入.需要的是继承iApplication接口的.
		 */
		public function ActiveManager(hostApp:iApplication = null)
		{
			if (!hostApp)
			{
				trace("ActiveManager没有定义宿主程序.")
			}
			else
			{
				_ActiveArray = new Array;
				_regPointArray = new Array;
				_host = hostApp;
			}
		}
		
		/**
		 * 将多个active class导入进去管理.
		 * @param	... args
		 */
		public function addActiveByClass(... args):void
		{
			for each (var cls:Class in args)
			{
				var active:* = new cls;
				active.setAcitveManager = this;
				active.host = _host;
				_ActiveArray.push(active);
					//return iActive(active)
			}
		}
		
		/**
		 * 自动初始化.懒人方法.自动搜索宿主程序下元件名为 active开头的元件并执行注册方法.
		 */
		//private function autoInit(e:iApplication):void
		//{
		////_host = e;
		////try
		////{
		//////this.mask = Sprite(DisplayObjectContainer(e).getChildByName(ActiveManager.mc_am_mask));
		////}
		////catch (e:*)
		////{
		////trace("没有找到ActiveManager用遮罩：" + mc_am_mask);
		////}
		////DisplayObjectContainer(e).addChild(this);
		////for (var i:int = 0; i < DisplayObjectContainer(e).numChildren; i++)
		////{
		////if (DisplayObjectContainer(e).getChildAt(i).name.slice(0, 6).toLowerCase() == "active")
		////{
		////registerActive(BaseActive(DisplayObjectContainer(e).getChildAt(i)));
		////i -= 1;
		////}
		////}
		//}
		
		///**
		//* 通过active的坐标注册坐标点.(新方法,好用很多..)
		//*/
		//public function registerPointByActive(active:BaseActive, activePointName:String):void
		//{
		//var o:Object = new Object;
		//o.name = activePointName;
		//o.x = active.x;
		//o.y = active.y;
		//_regPointArray.push(o);
		//}
		
		/**
		 * 注册Point通过输入坐标数据
		 */
		public function registerPointByXY(_X:Number, _Y:Number, activePointName:String):void
		{
			var o:Object = new Object;
			o.name = activePointName;
			o.x = _X;
			o.y = _Y;
			_regPointArray.push(o);
		}
		
		/**
		 * 将已经实例化过的active纳入管理器进行操作.
		 * 注册active.将active当作参数输入则会从宿主程序remove掉,在am中加载,并录入管理器.
		 */
		public function registerActive(active:BaseActive):void
		{
			//trace("registerActive",active);
			active.setAcitveManager = this;
			active.host = _host;
			_ActiveArray.push(active);
			DisplayObjectContainer(_host).removeChild(active);
		}
		
		/**
		 * 移入active名的active,并告知移动方向.  有bug,只会移除该点第一个注册的坐标.
		 */
		public function movein(activename:String, pointname:String, direction:String = "fade"):BaseActive
		{
			var i:BaseActive = searchActive(activename);
			if (!i)
			{
				return null
			}
			i.alpha = 1;
			i.x = getPoint(pointname).x;
			i.y = getPoint(pointname).y;
			switch (direction)
			{
				case "up": 
					TweenLite.from(i, TweenTime, {y: i.y - TweenDistence - i.height, alpha: 0, onInit: showActive, onInitParams: [i], onComplete: showActiveComplete, onCompleteParams: [i]});
					break;
				case "down": 
					TweenLite.from(i, TweenTime, {y: i.y + TweenDistence + i.height, alpha: 0, onInit: showActive, onInitParams: [i], onComplete: showActiveComplete, onCompleteParams: [i]});
					break;
				case "left": 
					TweenLite.from(i, TweenTime, {x: i.y - TweenDistence - i.width, alpha: 0, onInit: showActive, onInitParams: [i], onComplete: showActiveComplete, onCompleteParams: [i]});
					break;
				case "right": 
					TweenLite.from(i, TweenTime, {x: i.y + TweenDistence + i.width, alpha: 0, onInit: showActive, onInitParams: [i], onComplete: showActiveComplete, onCompleteParams: [i]});
					break;
				case "fade": 
				default: 
					TweenLite.from(i, TweenTime, {alpha: 0, onInit: showActive, onInitParams: [i], onComplete: showActiveComplete, onCompleteParams: [i]});
					break;
			}
			i.setPositionName = pointname;
			
			return i;
		}
		
		/**
		 * 将active移动到目标点位置.
		 */
		public function moveto(activename:String, pointname:String):BaseActive
		{
			var i:BaseActive = searchActive(activename);
			if (!i)
			{
				return null
			}
			TweenLite.to(i, TweenTime, {x: getPoint(pointname).x, y: getPoint(pointname).y});
			
			i.setPositionName = pointname;
			return i;
		}
		
		/**
		 * 移除active名的active,并告知移动方向.  有bug,只会移除该点第一个注册的坐标.
		 */
		public function moveout(activename:String, direction:String = "fade"):BaseActive
		{
			var i:BaseActive = searchActive(activename);
			if (!i)
			{
				return null
			}
			switch (direction)
			{
				case "up": 
					TweenLite.to(i, TweenTime, {y: i.y - TweenDistence - i.height, alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
					break;
				case "down": 
					TweenLite.to(i, TweenTime, {y: i.y + TweenDistence + i.height, alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
					break;
				case "left": 
					TweenLite.to(i, TweenTime, {x: i.y - TweenDistence - i.width, alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
					break;
				case "right": 
					TweenLite.to(i, TweenTime, {x: i.y + TweenDistence + i.width, alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
					break;
				case "fade": 
				default: 
					TweenLite.to(i, TweenTime, {alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
					break;
			}
			i.setPositionName = "";
			return i;
		}
		
		/**
		 * 移除点位置的active,并告知移动方向.  有bug,只会移除该点第一个注册的坐标.
		 */
		public function moveOutActiveByPoint(point:String, direction:String = "fade"):BaseActive
		{
			var i:BaseActive = searchActiveAtPoint(point);
			if (i)
			{
				switch (direction)
				{
					case "up": 
						TweenLite.to(i, TweenTime, {y: i.y - TweenDistence - i.height, alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
						break;
					case "down": 
						TweenLite.to(i, TweenTime, {y: i.y + TweenDistence + i.height, alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
						break;
					case "left": 
						TweenLite.to(i, TweenTime, {x: i.y - TweenDistence - i.width, alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
						break;
					case "right": 
						TweenLite.to(i, TweenTime, {x: i.y + TweenDistence + i.width, alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
						break;
					case "fade": 
					default: 
						TweenLite.to(i, TweenTime, {alpha: 0, onInit: hideActive, onInitParams: [i], onComplete: hideActiveComplete, onCompleteParams: [i]});
						break;
				}
				i.setPositionName = "";
				return i;
			}
			else
			{
				return null
			}
		}
		
		/**
		 * 显示active.直接addchild.
		 */
		private function showActive(active:BaseActive):void
		{
			try
			{
				addChild(active);
			}
			catch (e:*)
			{
				
			}
		}
		
		/**
		 * 动画类事件反馈,当显示动画完成时调度,用于remove.
		 */
		private function showActiveComplete(active:BaseActive):void
		{
			active.dispatchEvent(new ActiveEvent(ActiveEvent.IN));
		}
		
		/**
		 * 激活隐藏active,将事件流放入active中调度.
		 */
		private function hideActive(active:BaseActive):void
		{
			active.dispatchEvent(new ActiveEvent(ActiveEvent.OUT));
		}
		
		/**
		 * 动画类事件反馈,当消失动画完成时调度,用于remove.
		 */
		private function hideActiveComplete(active:BaseActive):void
		{
			try
			{
				removeChild(active);
			}
			catch (e:*)
			{
				//Cc.error("ActiveManager"+_host+":Active"+active+" already remove form stage!");
			}
		}
		
		/**
		 * 通过pointname搜索初始化的坐标,并返回一个{name:"pn",x:0,y:0}的object
		 */
		private function getPoint(_Name:String):Object
		{
			for (var i:int = 0; i < _regPointArray.length; i++)
			{
				if (_regPointArray[i].name == _Name)
				{
					var o:Object = new Object;
					o.name = _regPointArray[i].name;
					o.x = _regPointArray[i].x;
					o.y = _regPointArray[i].y;
					return o;
				}
			}
			return null;
		}
		
		/**
		 * 通过active名字去搜索active,并返回baseactive
		 */
		private function searchActive(activename:String):BaseActive
		{
			for (var i:int = 0; i < _ActiveArray.length; i++)
			{
				if (_ActiveArray[i].ActiveName == activename)
				{
					return _ActiveArray[i];
				}
			}
			trace("没找到active:" + activename);
			return null;
		}
		
		/**
		 * 在本am的宿主程序可以通过am.Active("active名字")返回要找的active
		 */
		public function Active(activename:String):iActive
		{
			for (var i:int = 0; i < _ActiveArray.length; i++)
			{
				if (_ActiveArray[i].ActiveName == activename)
				{
					return _ActiveArray[i];
				}
			}
			trace("没找到active:" + activename);
			return null;
		}
		
		/**
		 * 根据定点名查询iActive..有bug.当有多个active在一个点时,只会反馈数组前面的点
		 * 需要PointName.
		 * 返回iActive
		 */
		public function ActiveAtPoint(point:String):iActive
		{
			for (var i:int = 0; i < _ActiveArray.length; i++)
			{
				if (_ActiveArray[i].getPositionName == point)
				{
					return _ActiveArray[i];
				}
			}
			trace("没找到point上的active:" + point);
			return null;
		}
		
		/**
		 * 内部方法
		 * 根据PointName返回当前位置的active. 有bug.当有多个active在一个点时,只会反馈数组前面的点
		 */
		private function searchActiveAtPoint(point:String):BaseActive
		{
			for (var i:int = 0; i < _ActiveArray.length; i++)
			{
				if (_ActiveArray[i].getPositionName == point)
				{
					return _ActiveArray[i];
				}
			}
			//trace("没找到point上的active:" + point);
			return null;
		}
		
		/**
		 * 销毁该部件,同时remove掉所有该am所管理的active.同时执行所有active的dispose方法.
		 * 最后将所有active为null
		 */
		public function dispose():void
		{
			this.removeChildren()
			for (var i:int = 0; i < _ActiveArray.length; i++)
			{
				iActive(_ActiveArray[i]).dispose();
				_ActiveArray[i] = null;
			}
			_ActiveArray = null;
		}
	}
}