package com.lizeqiangd.nuigesture.core
{
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	
	/*
	 * 手部计算的主要计算类.没有进行优化,有可能导致cpu消耗过大.
	 * update@20140309 修改为非静态类
	 */
	public class HandDistand
	{
		private  var _leftHandDistand:Number;
		private  var _rightHandDistand:Number;
		
		/*
		 * 输入需要计算的人物(用户类是as3nui的)
		 */
		public  function set user(e:User)
		{
			//trace("HandDistand:user 已经收到正在计算");
			calculating(e.head.position.world, e.leftShoulder.position.world, e.rightShoulder.position.world, e.leftHand.position.world, e.rightHand.position.world);
		
		}
		
		/*
		 * 计算方法.
		 * 获得用户的头\左右手\左右肩膀的数据进行计算
		 * 头和肩膀的中间作为人物的中心线.但是这个中心线是倾斜的.所以人物手的具体距离就是距离这个线的距离.
		 * 不难理解吧.
		 *
		 */
		private  function calculating(head:Vector3D, left:Vector3D, right:Vector3D, leftHand:Vector3D, rightHand:Vector3D)
		{
			/*var k:Number =(head.y-((left.y + right.y)/2))/(head.z-((left.z + right.z)/2));
			   var b:Number = head.y - head.x * k;
			   tx_calculating.text = "y=" + k + "z+" + b;
			   tx_calculating.text +="\nY:"+(head.y-((left.y + right.y)/2));
			   tx_calculating.text +="\nZ:"+(head.z-((left.z + right.z)/2));
			   var b2:Number = rightHand.y - rightHand.x * k;
			   //Math.PI/2-Math.atan(k)
			   var angle:Number = Math.PI / 2 - Math.atan(k);
			   var realangle:Number = angle / Math.PI * 180;
			   tx_calculating.text +=  "\n补角:" + realangle;
			   var hand:Number = (b - b2) * Math.sin(angle);
			   tx_calculating.text +=  "\nHand:" + hand;
			 tx_calculating.text = "";*/
			var p1:Point = new Point(head.z, head.y);
			var p2:Point = new Point((left.z + right.z) / 2, (left.y + right.y) / 2);
			//trace(p1,p2)
			var k:Number = (p1.y - p2.y) / (p1.x - p2.x);
			var b:Number = p1.y - p1.x * k;
			//trace("y="+k+"x+("+b+")");
			var p3:Point = new Point(rightHand.z, rightHand.y);
			var b3:Number = p3.y - p3.x * k;
			_rightHandDistand = Math.sin(Math.PI / 2 - Math.atan(k)) * Math.abs(b - b3);
			_rightHandDistand = Math.round(_rightHandDistand);
			var p4:Point = new Point(leftHand.z, leftHand.y);
			var b4:Number = p4.y - p4.x * k;
			_leftHandDistand = Math.sin(Math.PI / 2 - Math.atan(k)) * Math.abs(b - b4);
			_leftHandDistand = Math.round(_leftHandDistand);
			//tx_calculating.text = "y=" + k + "z+" + b;
			//tx_calculating.text +=  "\nHand:" + distand;
			//trace("HandDistand:l:"+_leftHandDistand+" r:"+_rightHandDistand);
		
		}
		
		/*
		 * 反馈用户的左手到人的距离
		 */
		public  function get leftHandDistand():Number
		{
			return _leftHandDistand;
		}
		
		/*
		 * 反馈用户的右手到人的距离
		 */
		public  function get rightHandDistand():Number
		{
			return _rightHandDistand;
		}
	}
}