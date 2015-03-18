package com.lizeqiangd.zweisystem.modules.datagird
{
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	/**
	 * 作为DataGird的基础类,用户可以继承该类制作自己的数据条.用于自定义DataGird
	 * 使用方法:
	 * 所有设计好的BaseRow的子类应该拥有一个MovieClip名为 mc_bg.作为颜色渐变对象.
	 * 然后在你的子类里面侦听UnitEvent.UNIT_COMPLETED事件,当触发的时候您就可以将data的资料赋予你的文本框.
	 * 记得销毁你的部件.
	 *
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class BaseRow extends Sprite
	{
		private static const _mc_bg:String = "mc_bg";
		public var mc_background:DisplayObject
		public var rows_id:int = 0
		public var data:Object
		public var oddAlpha:Number = 0.3
		public var evenAlpha:Number = 0.5
		public var eventDispatcher:EventDispatcher
		
		/**
		 * 构造函数.添加侦听器,作为非同步处理数据
		 */
		public function BaseRow()
		{
			this.addEventListener(UnitEvent.UNIT_COMPLETED, onInitCompleted)
			try
			{
				mc_background = getChildByName(BaseRow._mc_bg)
			}
			catch (e:*)
			{
				trace("BaseRow配置错误，找不到需要的实例，请检查mc_bg是否存在。");
			}
			
		}
		
		/**
		 * 当本Row得到UnitEvent.UNIT_COMPLETE事件时,会将文本框的mouseEnabled设为false
		 * 同时修改背景alpha数值.(之后会交给DataGird管理)
		 */
		private function onInitCompleted(e:UnitEvent):void
		{
			this.removeEventListener(UnitEvent.UNIT_COMPLETED, onInitCompleted)
			for (var i:int = 0; i < this.numChildren; i++)
			{
				if (this.getChildAt(i) is TextField)
				{
					TextField(getChildAt(i)).mouseEnabled = false
				}
			}
			mc_background.alpha = getRowsCurrentAlpha
		}
		
		/**
		 * 当本Row通过 .dataProvider属性!  获取Object数据时,本Row会抛出UnitEvent.UNIT_COMPLETE事件作为提示.
		 * 同时该提示会让子类得知自己已经获取数据并初始化模块和外观样式.
		 */
		public function set dataProvider(e:Object)
		{
			data = e
			dispatchEvent(new UnitEvent(UnitEvent.UNIT_COMPLETED))
		}
		/**
		 * 获取本条当前应该的Alpha值
		 */
		public function get getRowsCurrentAlpha():Number
		{
			return rows_id % 2 ? oddAlpha : evenAlpha
		}
		
		/**
		 * 获取本Row是否为奇数条.
		 */
		public function get getIsOdd():Boolean
		{
			return rows_id % 2 ? false : true
		}
		
		/**
		 * 设置本row为标题模式,也就是DataGird中的第一行.
		 */
		public function titleMode()
		{
			mc_background.alpha = (oddAlpha + evenAlpha) / 2
		}
	}

}