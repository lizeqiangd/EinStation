package com.lizeqiangd.zweitehorizont.data.message
{
	import com.lizeqiangd.zweitehorizont.data.object.User;
	
	/**
	 * ...
	 * @author lizeqiangd
	 */
	
	 
	public class MessageChannel
	{
		public var messages:Vector.<Message> = new Vector.<Message>
		public var users:Vector.<User> = new Vector.<User>
		public var channel_data:MessageData
		
		static public var MessageChannelArray:Vector.<MessageChannel> = new Vector.<MessageChannel>
		
		static public function Push(message_channel:MessageChannel)
		{
			for (var i:int = 0; i < MessageChannelArray.length; i++)
			{
				if (message_channel.channel_data.channel_id == MessageChannelArray[i].channel_data.channel_id)
				{
					return i;
				}
			}
			MessageChannelArray.push(message_channel)
			return MessageChannelArray.length - 1
		}
		
		static public function GetChannel(id:uint):MessageChannel
		{
			return MessageChannelArray[id]
		}
		
		static public function SearchChannel(type:String, value:String):MessageChannel
		{
			var i:int = 0
			switch (type)
			{
				case "channel_id": 
					for (i; i < MessageChannelArray.length; i++)
					{
						if (String(MessageChannelArray[i].channel_data.channel_id) == value)
						{
							return MessageChannelArray[i]
						}
					}
					break;
				default: 
			}return null
		}
	}
}