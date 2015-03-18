package com.lizeqiangd.zweitehorizont.manager
{
	import com.lizeqiangd.zweisystem.components.encode.DateTimeUtils;
	import com.lizeqiangd.zweitehorizont.data.message.Message;
	import com.lizeqiangd.zweitehorizont.data.message.MessageChannel;
	import com.lizeqiangd.zweitehorizont.data.message.MessageData;
	import com.lizeqiangd.zweitehorizont.data.object.User;
	import com.lizeqiangd.zweitehorizont.events.MessageChannelEvent;
	import com.lizeqiangd.zweitehorizont.system.ZweiteHorizontConfig;
	import com.lizeqiangd.zweitehorizont.net.FMSProxy;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import net.nshen.nfms.FMSEvent;
	
	/**
	 * ...
	 * @author lizeqiangd
	 */
	public class MessageChannelManager
	{
		private var eventDispatch:EventDispatcher
		private var fp:FMSProxy
		private var inited:Boolean = false
		
		public function MessageChannelManager()
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
			fp = e
			
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelFunctionCloseChannel, onCloseChannelHandle)
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelFunctionCreateChannel, onCreateChannelHandle)
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelFunctionJoinChannel, onJoinChannelHandle)
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelFunctionLeaveChannel, onLeaveChannelHandle)
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelSendMessage, onSendMessageHandle)
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelManagerChannelClose, onChannelClosedHandle)
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelManagerChannelUserUpdate, onChannelUserUpdateHandle)
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelManagerMessageUpdate, onMessageUpdateHandle)
			fp.addEventListener(ZweiteHorizontConfig.MessageChannelManagerGetChannels, onGetChannelsHandle)
		}
		
		public function addMessageChannelEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, userWeakReference:Boolean = false):void
		{
			eventDispatch.addEventListener(type, listener, useCapture, priority, userWeakReference)
		}
		
		public function removeMessageChannelEventListener(type:String, listener:Function):void
		{
			eventDispatch.removeEventListener(type, listener)
		}
		
		/**
		 * 搜索channel功能, type则是channel_data里面的东西,特殊功能all.
		 * value则是值
		 * 注意返回值:{channel:MessageChannel,user_count:int}
		 * @param	type
		 * @param	value
		 */
		public function GetChannels(_type:String, _value:String = null)
		{
			if (_type == "all")
			{
				_value = "0";
			}
			fp.dispatch(ZweiteHorizontConfig.MessageChannelManagerGetChannels, {type: _type, value: _value})
		}
		
		private function onGetChannelsHandle(e:FMSEvent)
		{
			var returnArr:Array = []
			for (var i:int = 0; i < e.data2.length; i++)
			{
				var mc:MessageChannel = new MessageChannel
				mc.channel_data = new MessageData
				mc.channel_data.channel_create_time = e.data2[i].channel_data.channel_create_time
				mc.channel_data.channel_creator = new User
				mc.channel_data.channel_creator.cid = e.data2[i].channel_data.channel_creator.cid
				mc.channel_data.channel_creator.description = e.data2[i].channel_data.channel_creator.description
				mc.channel_data.channel_creator.display_name = e.data2[i].channel_data.channel_creator.display_name
				mc.channel_data.channel_creator.sid = e.data2[i].channel_data.channel_creator.sid
				mc.channel_data.channel_creator.uid = e.data2[i].channel_data.channel_creator.uid
				mc.channel_data.channel_creator.user_type = e.data2[i].channel_data.channel_creator.user_type
				mc.channel_data.channel_description = e.data2[i].channel_data.channel_description
				mc.channel_data.channel_id = e.data2[i].channel_data.channel_id
				mc.channel_data.channel_mumber_limit = e.data2[i].channel_data.channel_mumber_limit
				mc.channel_data.channel_name = e.data2[i].channel_data.channel_name
				mc.channel_data.channel_security = e.data2[i].channel_data.channel_security
				mc.channel_data.channel_type = e.data2[i].channel_data.channel_type
				returnArr.push({channel: mc, user_count: e.data2[i].user_count})
			}
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.GET_CHANNELS, returnArr))
		}
		
		/**
		 * need channel_name, channel_description, channel_type, channel_security(int)
		 * @param	channel_data
		 */
		public function CreateChannel(channel_data:Object)
		{
			var o:Object = {}
			o.channel_name = channel_data.channel_name
			o.channel_description = channel_data.channel_description
			o.channel_type = channel_data.channel_type
			o.channel_create_time = DateTimeUtils.getDateTime()
			trace(o.channel_create_time)
			o.channel_security = channel_data.channel_security
			o.channel_member_limit = 10
			fp.dispatch(ZweiteHorizontConfig.MessageChannelFunctionCreateChannel, o)
		}
		
		private function onCreateChannelHandle(e:FMSEvent)
		{
			if (e.data2.type == "failed")
			{
				eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.CREATE_CHANNEL, -1))
				return
			}
			var mc:MessageChannel = new MessageChannel
			mc.channel_data = new MessageData
			trace("onCreateChannelHandle:",e.data2.channel.channel_data.channel_create_time)
			mc.channel_data.channel_create_time = e.data2.channel.channel_data.channel_create_time
			mc.channel_data.channel_creator = new User
			mc.channel_data.channel_creator.cid = e.data2.channel.channel_data.channel_creator.cid
			mc.channel_data.channel_creator.description = e.data2.channel.channel_data.channel_creator.description
			mc.channel_data.channel_creator.display_name = e.data2.channel.channel_data.channel_creator.display_name
			mc.channel_data.channel_creator.sid = e.data2.channel.channel_data.channel_creator.sid
			mc.channel_data.channel_creator.uid = e.data2.channel.channel_data.channel_creator.uid
			mc.channel_data.channel_creator.user_type = e.data2.channel.channel_data.channel_creator.user_type
			mc.channel_data.channel_description = e.data2.channel.channel_data.channel_description
			mc.channel_data.channel_id = e.data2.channel.channel_data.channel_id
			mc.channel_data.channel_mumber_limit = e.data2.channel.channel_data.channel_mumber_limit
			mc.channel_data.channel_name = e.data2.channel.channel_data.channel_name
			mc.channel_data.channel_security = e.data2.channel.channel_data.channel_security
			mc.channel_data.channel_type = e.data2.channel.channel_data.channel_type
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.CREATE_CHANNEL, MessageChannel.Push(mc)))
			///默认会自动加入频道.
			JoinChannel(e.data2.channel.channel_data.channel_id)
		}
		
		/**
		 * 加入频道
		 * 没有做权限审核机制. need channel_id (uint)
		 * @param	o
		 */
		public function JoinChannel(channel_id:uint)
		{
			var o:Object = {}
			o.channel_id = channel_id
			fp.dispatch(ZweiteHorizontConfig.MessageChannelFunctionJoinChannel, o)
		}
		
		private function onJoinChannelHandle(e:FMSEvent)
		{
			if (e.data2.type == "failed")
			{
				eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.JOIN_CHANNEL, -1))
				return
			}
			var mc:MessageChannel = new MessageChannel
			mc.channel_data = new MessageData
			mc.channel_data.channel_create_time = e.data2.channel.channel_data.channel_create_time
			mc.channel_data.channel_creator = new User
			mc.channel_data.channel_creator.cid = e.data2.channel.channel_data.channel_creator.cid
			mc.channel_data.channel_creator.description = e.data2.channel.channel_data.channel_creator.description
			mc.channel_data.channel_creator.display_name = e.data2.channel.channel_data.channel_creator.display_name
			mc.channel_data.channel_creator.sid = e.data2.channel.channel_data.channel_creator.sid
			mc.channel_data.channel_creator.uid = e.data2.channel.channel_data.channel_creator.uid
			mc.channel_data.channel_creator.user_type = e.data2.channel.channel_data.channel_creator.user_type
			mc.channel_data.channel_description = e.data2.channel.channel_data.channel_description
			mc.channel_data.channel_id = e.data2.channel.channel_data.channel_id
			mc.channel_data.channel_mumber_limit = e.data2.channel.channel_data.channel_mumber_limit
			mc.channel_data.channel_name = e.data2.channel.channel_data.channel_name
			mc.channel_data.channel_security = e.data2.channel.channel_data.channel_security
			mc.channel_data.channel_type = e.data2.channel.channel_data.channel_type
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.JOIN_CHANNEL, MessageChannel.Push(mc)))
		}
		
		/**
		 * 离开频道
		 * 没有做权限审核机制. need channel_id (uint)
		 * @param	o
		 */
		public function LeaveChannel(channel_id:uint)
		{
			//trace("MessageChannelManager.LeaveChannel")
			var o:Object = {}
			o.channel_id = channel_id
			fp.dispatch(ZweiteHorizontConfig.MessageChannelFunctionLeaveChannel, o)
		}
		
		private function onLeaveChannelHandle(e:FMSEvent)
		{
			//trace("MessageChannelManager.onLeaveChannelHandle")
			if (e.data2.type == "failed")
			{
				eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.LEAVE_CHANNEL, -1))
				return
			}
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.LEAVE_CHANNEL, e.data2.channel.channel_data.channel_id))
		}
		
		/**
		 * 没有做任何权限机制,需要输入master key!
		 * need channel_id message masterkey
		 */
		public function CloseChannel(channel_id:uint, message:String, masterkey:String)
		{
			//trace("MessageChannelManager.CloseChannel")
			var o:Object = {}
			o.channel_id = channel_id
			o.message = message
			o.masterkey = masterkey
			fp.dispatch(ZweiteHorizontConfig.MessageChannelFunctionCloseChannel, o)
		}
		
		private function onCloseChannelHandle(e:FMSEvent)
		{
			//trace("MessageChannelManager.onCloseChannelHandle")
			if (e.data2.type == "failed")
			{
				eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.CLOSE_CHANNEL, -1))
				return
			}
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.CLOSE_CHANNEL, e.data2.channel_id))
		}
		
		private function onChannelClosedHandle(e:FMSEvent):void
		{
			//	trace("MessageChannelManager.onChannelClosedHandle")
			var o:Object = {}
			o.message = e.data2.message
			o.channel_id = e.data2.channel_id
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.CHANNEL_CLOSE, o))
		}
		
		public function HackChannel()
		{
		}
		
		public function SendMessage(m:Message, c_id:uint)
		{
			//trace("MessageChannelManager.SendMessage")
			var o:Object = {}
			o.message_type = m.message_type
			o.message_date = m.message_date
			o.message_content = m.message_content
			o.channel_id = c_id
			fp.dispatch(ZweiteHorizontConfig.MessageChannelSendMessage, o)
		}
		
		private function onSendMessageHandle(e:FMSEvent)
		{
			//	trace("MessageChannelManager.onSendMessageHandle",e.data2.channel_id)
			if (e.data2.type == "failed")
			{
				eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.SEND_MESSAGE, -1))
				return
			}
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.SEND_MESSAGE, e.data2.channel_id))
		}
		
		private function onMessageUpdateHandle(e:FMSEvent)
		{
			//	trace("MessageChannelManager.onMessageUpdateHandle",e.data2.message.message_content)
			var o:Object = {}
			o.channel_id = e.data2.channel_id
			o.message
			var m:Message = new Message
			m.message_content = e.data2.message.message_content
			m.message_date = e.data2.message.message_date
			m.message_type = e.data2.message.message_type
			m.message_user_display_name = e.data2.message.message_user_display_name
			o.message = m
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.MESSAGE_UPDATE, o))
		}
		
		///{channel_id:channel_id,type:"out",message_id:3,message:"an user leave channel",user:user}
		private function onChannelUserUpdateHandle(e:FMSEvent)
		{
			//trace("MessageChannelManager.onChannelUserUpdateHandle")
			eventDispatch.dispatchEvent(new MessageChannelEvent(MessageChannelEvent.USER_UPDATE, e.data2))
		}
		
		public function KickUser()
		{
		}
	}
}