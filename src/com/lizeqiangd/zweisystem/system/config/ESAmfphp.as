package com.lizeqiangd.zweisystem.system.config
{
	
	/**
	 * ...
	 * @author lizeqiangd
	 */
	public class ESAmfphp
	{
		///for Guestbook 
		public static const Guestbook_getAllComment:String = "EinStationServices/getGuestbookList"
		public static const Guestbook_deleteComment:String = "EinStationServices/deleteGuestbook"
		public static const Guestbook_replyComment:String = "EinStationServices/replyGuestbook"
		public static const Guestbook_publishComment:String = "EinStationServices/sendGusetbook"
	
		
		///for lovelive		
		public static const LoveLive_increaseCount :String = "LoveLive/increaseCount"
		public static const LoveLive_increaseCount2 :String = "LoveLive/increaseCount2"
	}

}