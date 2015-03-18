package com.lizeqiangd.zweisystem.abstract.active
{
	import com.lizeqiangd.zweisystem.abstract.active.ActiveManager
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import flash.display.MovieClip;
	
	/**
	 * BaseActive是所有active的基类,是一个抽象类,并继承movieclip.所有在flash pro绘制的active都继承本类
	 * 2014.03.24 更新备注
	 * @author:Lizeqiangd
	 */
	public class BaseActive extends MovieClip
	{
		private var _ActiveName:String;
		private var _AM:ActiveManager;
		private var _VM:ViewManager
		private var _contenter:*
		private var _nowPosition:String;
		/**
		 * BaseActive构造函数,需要参数为本Active名字
		 */
		public function BaseActive(active_name:String = "")
		{
			_ActiveName = active_name;
			active_name == "" ? trace("BaseActive:no ActiveName find! -", this) : null;
		}
		/**
		 * 获取Active名字.
		 */
		public function get ActiveName():String
		{
			return _ActiveName
		}
		/**
		 * 设置当前Active的管理器ActiveManager
		 */
		public function set AM(e:ActiveManager)
		{
			_AM = e;
		}
		/**
		 * 设置当前Active的ViewManager
		 */
		public function set VM(e:ViewManager)
		{
			_VM = e;
		}
		/**
		 * 获取本active的ActiveManager 
		 */
		public function get getAcitveManager():ActiveManager
		{
			return _AM;
		}
		/**
		 * 获取本active的ViewManager
		 */
		public function get getViewManager():ViewManager
		{
			return _VM;
		}
		/**
		 * 从ActiveManager中获取同级的其他Active,需要目标ActiveName,返回iActive
		 */
		public function getActive(active_name:String):iActive
		{
			return _AM.Active(active_name)
		}
		/**
		 * 通过ActiveManager访问输入当前位置.
		 */
		public function set nowPosition(e:String)
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
		public function set host(e:*)
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