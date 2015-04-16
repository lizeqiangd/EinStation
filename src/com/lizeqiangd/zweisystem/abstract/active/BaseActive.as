package com.lizeqiangd.zweisystem.abstract.active
{
	import com.lizeqiangd.zweisystem.abstract.active.ActiveManager
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.interfaces.baseunit.BaseUI;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * BaseActive是所有active的基类,是一个抽象类,
	 * 2014.03.24 更新备注 并继承movieclip.所有在flash pro绘制的active都继承本类
	 * 2015.04.10 转为完全as3模式.
	 * @author:Lizeqiangd
	 */
	public class BaseActive extends BaseUI
	{
		///固定抬头大小,记得所有内部元件要有20px的下位移
		public const title_board:int = 20;
		
		private var _ActiveName:String;
		private var _ActiveTitle:String = 'untitled';
		
		private var tx_title:TextField
		
		private var _AM:ActiveManager;
		private var _contenter:*
		private var _nowPosition:String;
		
		/**
		 * BaseActive构造函数,需要参数为本Active名字
		 */
		public function BaseActive(active_name:String = "")
		{
			_ActiveName = active_name;
			active_name == "" ? trace("BaseActive:no ActiveName find! -", this) : null;
			tx_title = new TextField
			tx_title.defaultTextFormat = new TextFormat('微软雅黑', 12, 0xffffff)
			tx_title.text = _ActiveTitle
			tx_title.height = 20
			tx_title.mouseEnabled = false
			//sp_frame.mouseEnabled = false
			
			addChild(tx_title)
		}
		
		/**
		 * 设置active的大小.会自动创建框体.
		 * @param	_w
		 * @param	_h
		 */
		public function config(_w:Number, _h:Number):void
		{
			this.configBaseUi(_w, _h);
			tx_title.width = getUiWidth
		}
		
		/**
		 * 创建框体.   可选是否使用阴影.
		 * @param	value
		 */
		override public function createFrame(value:Boolean = true):void
		{
			super.createFrame(value)
			sp_frame.graphics.beginFill(getFrameColor, 1)
			sp_frame.graphics.drawRect(0, 0, getUiWidth, 20)
			sp_frame.graphics.endFill();
			this.setChildIndex(sp_frame, numChildren - 1)
			this.setChildIndex(tx_title, numChildren - 1)
		}
		
		/**
		 * 从ActiveManager中获取同级的其他Active,需要目标ActiveName,返回iActive
		 */
		public function getActive(active_name:String):iActive
		{
			return _AM.Active(active_name)
		}
		
		/**
		 * 设置active的名字.
		 */
		public function set setActiveTitle(e:String):void
		{
			_ActiveTitle = e
			tx_title.text = _ActiveTitle
		}
		
		public function get getActiveTitle():String
		{
			return _ActiveTitle
		}
		
		/**
		 * 获取Active名字.
		 */
		public function get ActiveName():String
		{
			return _ActiveName
		}
		
		/**
		 * 重新设置Active名字
		 */
		public function set setActiveName(e:String):void
		{
			_ActiveName = e
		}
		
		/**
		 * 设置当前Active的管理器ActiveManager
		 */
		public function set setAcitveManager(e:ActiveManager):void
		{
			_AM = e;
		}
		
		/**
		 * 获取本active的ActiveManager
		 */
		public function get getAcitveManager():ActiveManager
		{
			return _AM;
		}
		
		/**
		 * 通过ActiveManager访问输入当前位置.
		 */
		public function set setPositionName(e:String):void
		{
			_nowPosition = e;
		}
		
		/**
		 * 获取当前Active的位置.
		 */
		public function get getPositionName():String
		{
			return _nowPosition;
		}
		
		/**
		 * 设置本Active的宿主程序.
		 */
		public function set host(e:*):void
		{
			_contenter = e;
		}
		
		/**
		 * 获取本Active的宿主程序.
		 */
		public function get host():iApplication
		{
			return iApplication(_contenter);
		}
	}
}