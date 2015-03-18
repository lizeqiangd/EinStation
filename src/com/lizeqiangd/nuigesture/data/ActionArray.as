package com.lizeqiangd.nuigesture.data
{
	import com.lizeqiangd.nuigesture.core.ActionAnalysis;
	import com.lizeqiangd.nuigesture.data.action.ActionPoint;
	
	/*
	 * 本类只是一个实例 用于存储数个手部位置和中心点位置.
	 */
	public class ActionArray
	{
		public var isAnalysis:Boolean = false;
		private var _ActionArrayNodeName:String;
		private var _ActionArrayLength:uint = 3;
		private var _UserNodeId:uint;
		private var _CentrePoint:ActionPoint;
		private var _CentrePoint1:ActionPoint;
		private var _CentrePoint2:ActionPoint;
		private var _CentrePoint3:ActionPoint;
		private var _nowCount:uint = 0;
		private var _ActionPoint1:ActionPoint;
		private var _ActionPoint2:ActionPoint;
		private var _ActionPoint3:ActionPoint;
		private var _SelectPoint:uint;
		private var _Inited:Boolean = false;
		private var _z:int = 0;
		private var AA:ActionAnalysis
		
		/*
		 * 构造函数,动作序列节点名称. 长度目前固定是3个.
		 * 需要从ActionArrayManager输入ActionAnalysis
		 */
		public function ActionArray(ActionArrayNodeName:String, aa:ActionAnalysis, ActionArrayLength:uint = 3)
		{
			AA = aa
			_ActionArrayNodeName = ActionArrayNodeName;
			_ActionArrayLength = ActionArrayLength;
			_SelectPoint = 0;
			_z = 0;
		}
		
		/*
		 * 添加新的动作给动作序列.
		 * action:ActionPoint 目标位置动作点添加.
		 * centrepoint:ActionPoint 中心基准参照点
		 *
		 * 同时如果ActionArrayManager提交允许分析的话,这里会触发后续动作分析.
		 */
		public function capture(action:ActionPoint, centrepoint:ActionPoint)
		{
			if (!_Inited)
			{
				//trace("ActionArray["+_ActionArrayNodeName+"]initing...")
				_ActionPoint1 = action;
				_ActionPoint2 = action;
				_ActionPoint3 = action;
				addCentrePoint(centrepoint);
				addCentrePoint(centrepoint);
				addCentrePoint(centrepoint);
				_Inited = true;
			}
			addCentrePoint(centrepoint);
			_nowCount == 3 ? _nowCount = 1 : _nowCount++;
			this["_ActionPoint" + _nowCount] = action;
			calculateCenterPoint();
			calculateZ();
			isAnalysis ? analysis() : null
			//_eventDispatch.dispatchEvent(new NuiEvent (NuiEvent.ACTION_CAPTURED,this));
		
		}
		
		/*
		 * 提交分析当前队列.
		 */
		private function analysis()
		{
			AA.analysis(this)
		}
		
		/*
		 * 添加中心点
		 */
		private function addCentrePoint(e:ActionPoint)
		{
			_SelectPoint == 3 ? _SelectPoint = 1 : _SelectPoint++;
			this["_CentrePoint" + _SelectPoint] = e;
		}
		
		/*
		 * 通过三次中心点计算出平均中心点坐标.
		 */
		private function calculateCenterPoint()
		{
			var az:Number = 0; // _CentrePoint1.az + _CentrePoint2.az + _CentrePoint3.az;
			var rx:Number = _CentrePoint1.rgbX + _CentrePoint2.rgbX + _CentrePoint3.rgbX;
			var ry:Number = _CentrePoint1.rgbY + _CentrePoint2.rgbY + _CentrePoint3.rgbY;
			var wx:Number = _CentrePoint1.worldX + _CentrePoint2.worldX + _CentrePoint3.worldX;
			var wy:Number = _CentrePoint1.worldY + _CentrePoint2.worldY + _CentrePoint3.worldY;
			var wz:Number = _CentrePoint1.worldZ + _CentrePoint2.worldZ + _CentrePoint3.worldZ;
			_CentrePoint = new ActionPoint(az / 3, rx / 3, ry / 3, wx / 3, wy / 3, wz / 3);
			//trace("ActionArray["+_ActionArrayNodeName+"]CentrePoint")
			//trace(_CentrePoint.toString ())
			//trace("***********END**************")
		}
		
		/*
		 * 计算平均Z轴距离.
		 */
		private function calculateZ()
		{
			_z = (_ActionPoint1.az + _ActionPoint2.az + _ActionPoint3.az) / 3;
		}
		
		/*
		 * 按顺序获得当前动作.1为最新 3为最旧.会动态改变.
		 */
		public function getActionPoint(i:uint):ActionPoint
		{
			if (i == 3)
			{
				return this["_ActionPoint" + _nowCount];
			}
			if (i == 1)
			{
				if (_nowCount == 3)
				{
					return _ActionPoint1;
				}
				if (_nowCount == 2)
				{
					return _ActionPoint3;
				}
				if (_nowCount == 1)
				{
					return _ActionPoint2;
				}
			}
			if (i == 2)
			{
				if (_nowCount == 3)
				{
					return _ActionPoint2;
				}
				if (_nowCount == 2)
				{
					return _ActionPoint1;
				}
				if (_nowCount == 1)
				{
					return _ActionPoint3;
				}
			}
			return new ActionPoint(0);
		}
		
		/*
		 * 获得当前Z轴距离
		 */
		public function get z():int
		{
			return _z;
		}
		
		/*
		 * 获得中心基准点.
		 */
		public function get centrePoint():ActionPoint
		{
			return _CentrePoint;
		}
		
		/*
		 * 销毁本序列
		 */
		public function dispose()
		{
			_CentrePoint = null;
			_CentrePoint1 = null;
			_CentrePoint2 = null;
			_CentrePoint3 = null;
			_ActionPoint1 = null;
			_ActionPoint2 = null;
			_ActionPoint3 = null;
		}
	}
}