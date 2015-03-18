package com.lizeqiangd.zweitehorizont.manager
{
	import com.lizeqiangd.zweitehorizont.system.ZweiteHorizontConfig;
	import com.lizeqiangd.zweitehorizont.events.UserEvent;
	import com.lizeqiangd.zweitehorizont.net.FMSProxy;
	import com.lizeqiangd.zweitehorizont.data.object.User;
	import com.lizeqiangd.zweitehorizont.system.ClientUtils;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import net.nshen.nfms.FMSEvent;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class UserManager
	{
		private var fp:FMSProxy
		private var userlist:Vector.<User>
		private var userIndex:uint
		private var eventDispatch:EventDispatcher
		
		private var inited:Boolean = false
		
		public function UserManager()
		{
			eventDispatch = new EventDispatcher
		}
	
		public function init(e:FMSProxy):void
		{
			if (inited)
			{
				return
			}
			inited = true
			
			userlist = new Vector.<User>
			fp = e
			fp.addConnectionEventListener("connected", onConnected)
			fp.addEventListener(ZweiteHorizontConfig.UserManagerGetOnlineUser, onGetUserList)
			fp.addEventListener(ZweiteHorizontConfig.UserManagerNotifyUserUserOffLine, onUserOffLine)
			fp.addEventListener(ZweiteHorizontConfig.UserManagerNotifyUserUpdateUsersInformation, onUpdateUsersInformation)
		
		}
		
		//用户管理器的侦听器
		public function addUserEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, userWeakReference:Boolean = false):void
		{
			eventDispatch.addEventListener(type, listener, useCapture, priority, userWeakReference)
		}
		
		public function removeUserEventListener(type:String, listener:Function):void
		{
			eventDispatch.removeEventListener(type, listener)
		}
		
		//连接成功后立刻获取当前用户列表
		private function onConnected(e:Event):void
		{
			fp.dispatch(ZweiteHorizontConfig.UserManagerGetOnlineUser)
		}
		
		//得到用户数据后调度
		private function onGetUserList(e:FMSEvent):void
		{
			userlist = new Vector.<User>
			for (var i:int = 0; i < e.data2.length; i++)
			{
				var u:User = new User
				u.cid = e.data2[i].cid
				u.description = e.data2[i].description
				u.display_name = e.data2[i].display_name
				u.sid = e.data2[i].sid
				u.uid = e.data2[i].uid
				u.user_type = e.data2[i].user_type
				userlist.push(u)
			}
			onUpdateUserIndex()
			//trace("GetUserList Complete,UserIndex:", userIndex)
			eventDispatch.dispatchEvent(new UserEvent(UserEvent.USERLIST_UPDATE, userlist))
			eventDispatch.dispatchEvent(new UserEvent(UserEvent.USER_EVENT, {type: UserEvent.USERLIST_UPDATE}))
		}
		
		//重新获取用户本身在数组中的索引
		private function onUpdateUserIndex():void
		{
			for (var i:int = 0; i < userlist.length; i++)
			{
				if (userlist[i].cid == ClientUtils.getClientCid)
				{
					userIndex = i
					ClientUtils.setClientSid = userlist[i].sid
					
				}
			}
		}
		
		//当用户更新自身信息的时候会接收到广播
		private function onUpdateUsersInformation(e:FMSEvent):void
		{
			/*	trace("uid:", e.data2.uid)
			   trace("cid:", e.data2.cid)
			   trace("sid:", e.data2.sid)
			   trace("user_type:", e.data2.user_type)
			   trace("display_name:", e.data2.display_name)
			 trace("description:", e.data2.description)*/
			
			for (var i:int = 0; i < userlist.length; i++)
			{
				if (userlist[i].cid == e.data2.cid)
				{
					userlist[i].sid = e.data2.sid
					userlist[i].uid = e.data2.uid
					userlist[i].user_type = e.data2.user_type
					userlist[i].description = e.data2.description
					userlist[i].display_name = e.data2.display_name
					eventDispatch.dispatchEvent(new UserEvent(UserEvent.USER_UPDATE, e.data2))
					eventDispatch.dispatchEvent(new UserEvent(UserEvent.USER_EVENT, {type: UserEvent.USER_UPDATE, user: e.data2}))
					return
				}
			}
			var u:User = new User
			u.sid = e.data2.sid
			u.uid = e.data2.uid
			u.cid = e.data2.cid
			u.description = e.data2.description
			u.display_name = e.data2.display_name
			u.user_type = e.data2.user_type
			userlist.push(u)
			eventDispatch.dispatchEvent(new UserEvent(UserEvent.USER_ONLINE, e.data2))
			eventDispatch.dispatchEvent(new UserEvent(UserEvent.USER_EVENT, {type: UserEvent.USER_ONLINE, user: e.data2}))
			return
		}
		
		//有用户下线时候调度
		private function onUserOffLine(e:FMSEvent):void
		{
			for (var i:int = 0; i < userlist.length; i++)
			{
				if (userlist[i].cid == e.data2.cid)
				{
					userlist.splice(i, 1)
					onUpdateUserIndex()
					eventDispatch.dispatchEvent(new UserEvent(UserEvent.USER_OFFLINE, e.data2))
					eventDispatch.dispatchEvent(new UserEvent(UserEvent.USER_EVENT, {type: UserEvent.USER_OFFLINE, user: e.data2}))
					return
				}
			}
		}
		
		//用户自更新自身数据，cid和sid改变不会被服务器受理
		public function updateUserInformation(e:User):void
		{
			fp.dispatch(ZweiteHorizontConfig.UserManagerUpdateUserInformation, e)
		}
		
		//获取在线列表
		public function get UserList():Vector.<User>
		{
			return userlist
		}
		
		//获取用户在用户列表的索引
		public function get UserIndex():uint
		{
			return userIndex
		}
		
		//获取用户自身
		public function get Users():User
		{
			return userlist[userIndex]
		}
	}

}