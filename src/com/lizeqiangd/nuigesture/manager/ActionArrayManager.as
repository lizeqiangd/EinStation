package com.lizeqiangd.nuigesture.manager
{
	import com.lizeqiangd.nuigesture.core.ActionAnalysis;
	import com.lizeqiangd.nuigesture.data.ActionArray;
	import com.lizeqiangd.nuigesture.data.action.ActionPoint;
	import com.lizeqiangd.nuigesture.event.NuiEvent;
	
	/*
	 * 动作序列管理器.目前只负责管理用户1和2的左右手,也就是4个序列.
	 * 同时决定是否将动作序列提交分析以触发后续操作.
	 */
	public class ActionArrayManager
	{
		private var AA:ActionAnalysis
		//public static var kinect:Kinect;
		private var _User1RightHandActionArray:ActionArray;
		private var _User1LeftHandActionArray:ActionArray;
		private var _User2RightHandActionArray:ActionArray;
		private var _User2LeftHandActionArray:ActionArray;
		//private static var user1id:uint 
		//private static var user2id:uint 
		private var analysisU1R:Boolean = false;
		private var analysisU1L:Boolean = false;
		private var analysisU2R:Boolean = false;
		private var analysisU2L:Boolean = false;
		
		private var inited:Boolean = false
		
		/*
		 * ActionArrayManager,需要主类提供ActionAnalysis
		 */
		public function init(AA:ActionAnalysis)
		{
			if (inited)
			{
				inited = true
				_User1RightHandActionArray = new ActionArray("u1r", AA, 3);
				_User1LeftHandActionArray = new ActionArray("u1l", AA, 3);
				_User2RightHandActionArray = new ActionArray("u2r", AA, 3);
				_User2LeftHandActionArray = new ActionArray("u2l", AA, 3);
			}
			else
			{
				trace("NuiGesture.ActionArrayManager:already inited")
			}
		}
		
		/*
		 * 设置具体需要提交分析的动作序列
		 * 目前只针对用户1的右手.!!!
		 */
		public function configAnalysis(u1r:Boolean = false, u1l:Boolean = false, u2r:Boolean = false, u2l:Boolean = false)
		{
			u1l = false
			u2r = false
			u2l = false
			if (u1r)
			{
				_User1RightHandActionArray.isAnalysis = true
			}
			else
			{
				_User1RightHandActionArray.isAnalysis = false
			}
			if (u1l)
			{
				_User1LeftHandActionArray.isAnalysis = true
			}
			else
			{
				_User1LeftHandActionArray.isAnalysis = false
			}
			if (u2r)
			{
				_User2RightHandActionArray.isAnalysis = true
			}
			else
			{
				_User2RightHandActionArray.isAnalysis = false
			}
			if (u2l)
			{
				_User2LeftHandActionArray.isAnalysis = true
			}
			else
			{
				_User2LeftHandActionArray.isAnalysis = false
			}
		}
		
		/*
		 * 返回用户1的右手动作序列
		 */
		public function get User1RightHandActionArray():ActionArray
		{
			//analysisU1R ? ActionAnalysis.analysis(_User1RightHandActionArray):null;
			return _User1RightHandActionArray;
		}
		
		/*
		 * 返回用户1的右手动作序列
		 */
		public function get User1LeftHandActionArray():ActionArray
		{
			//analysisU1L ? ActionAnalysis.analysis(_User1LeftHandActionArray):null;
			return _User1LeftHandActionArray;
		}
		
		/*
		 * 返回用户1的左手动作序列
		 */
		public function get User2RightHandActionArray():ActionArray
		{
			//analysisU2R ? ActionAnalysis.analysis(_User2RightHandActionArray):null;
			return _User2RightHandActionArray;
		}
		
		/*
		 * 返回用户2的右手动作序列
		 */
		public function get User2LeftHandActionArray():ActionArray
		{
			//analysisU2L ? ActionAnalysis.analysis(_User2LeftHandActionArray):null;
			return _User2LeftHandActionArray;
		}
		
		/*
		 * 返回用户2的左手动作序列
		 */
		public function dispose()
		{
			_User1RightHandActionArray.dispose();
			_User1LeftHandActionArray.dispose();
			_User2RightHandActionArray.dispose();
			_User2LeftHandActionArray.dispose();
			inited = false
		}
	}
}