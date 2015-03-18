package com.lizeqiangd.zweitehorizont.system 
{
	
	/**
	 * 本类记载着服务器方法.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class ZweiteHorizontConfig 
	{
		public static const UserManagerUpdateUserInformation:String ="UserManagerUpdateUserInformation"
		public static const UserManagerGetOnlineUser:String ="UserManagerGetOnlineUser"
		public static const UserManagerNotifyUserUpdateUsersInformation:String ="UserManagerNotifyUserUpdateUsersInformation"
		public static const UserManagerNotifyUserUserOffLine:String ="UserManagerNotifyUserUserOffLine"

		public static const ObjectManagerCreateObject:String="ObjectManagerCreateObject"
		public static const ObjectManagerUpdateObjectInformation:String="ObjectManagerUpdateObjectInformation"
		public static const ObjectManagerUpdateObjectLocation:String="ObjectManagerUpdateObjectLocation"
		public static const ObjectManagerRemoveObject:String = "ObjectManagerRemoveObject"
		
		public static const ObjectManagerRequestLocationUpdate:String="ObjectManagerRequestLocationUpdate"
		public static const ObjectManagerRequestObjectPool:String = "ObjectManagerRequestObjectPool"
		
		public static const ObjectManagerNotifyUserUpdateObject:String = "ObjectManagerNotifyUserUpdateObject"
		public static const ObjectManagerNotifyUserRemoveObject:String = "ObjectManagerNotifyUserRemoveObject"
		
		///MessageChannelFunction
		public static const MessageChannelFunctionCreateChannel:String="MessageChannelFunctionCreateChannel"		
		public static const MessageChannelFunctionJoinChannel:String="MessageChannelFunctionJoinChannel"
		public static const MessageChannelFunctionLeaveChannel:String="MessageChannelFunctionLeaveChannel"
		public static const MessageChannelFunctionCloseChannel:String = "MessageChannelFunctionCloseChannel"
		///MessageChannel
		public static const MessageChannelSendMessage:String = "MessageChannelSendMessage"
		///MessageChannelManager
		public static const MessageChannelManagerChannelClose:String="MessageChannelManagerChannelClose"
		public static const MessageChannelManagerChannelUserUpdate:String="MessageChannelManagerChannelUserUpdate"
		public static const MessageChannelManagerMessageUpdate:String = "MessageChannelManagerMessageUpdate"
		public static const MessageChannelManagerGetChannels:String = "MessageChannelManagerGetChannels"
		
		
	}
	
}