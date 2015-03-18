package com.lizeqiangd.zweisystem.modules.datagird
{
	
	/**
	 * 该接口是所有最终继承BaseRow的接口,方便编程者记得必要方法.
	 * @author lizeqiangd
	 * @update 2014.03.30 创建
	 */
	public interface iDataGirdRow
	{
		private function addRowsListener():void
		private function onInitCompleted():void
		public function rowsAnimationInit():void
		public function rowsAnimation():void		
		public function dispose():void
	
	}

}