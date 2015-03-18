package com.zweisystem.applications.GraduationHelper.actives
{
	
	/**
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.events.ActiveEvent;
	import com.zweisystem.modules.notification.SystemStatusNotification;
	import com.zweisystem.net.AMFPHP;
	
	import com.zweisystem.system.applications.message.Message;
	import flash.events.MouseEvent;
	
	public class ManagerActive extends BaseActive implements iActive
	{
		private var ssn:SystemStatusNotification
		private var isLogin:Boolean = false
		private var commanClass:String = "军事理论 大学英语(1) 大学英语(2) 大学英语(3) 大学英语(4) 思想道德修养与法律基础(含廉洁修身) 文史哲通论 中国近现代史纲要 毛泽东思想和中国特色社会主义理论体系概论1 毛泽东思想和中国特色社会主义理论体系概论2 马克思主义基本原理 形势与政策 羽毛球俱乐部 游泳俱乐部  足球俱乐部 篮球俱乐部 排球俱乐部 垒球俱乐部 羽毛球俱乐部 毽球俱乐部 网球俱乐部 乒乓球俱乐部 太极养生俱乐部 体育舞蹈俱乐部 女子形体俱乐部 有氧舞蹈俱乐部 太极俱乐部 跆拳道俱乐部 健身俱乐部 高尔夫俱乐部 定向越野俱乐部 保龄球俱乐部 女子篮球俱乐部 女子艺术健身操俱乐部 壁球俱乐部 围棋中级俱乐部 女子健身俱乐部 啦啦操俱乐部 拓展训练俱乐部 "
		
		public function ManagerActive()
		{
			super("ManagerActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			ssn = new SystemStatusNotification
			ssn.init(0, 20, 600, 60)
			addChild(ssn)
			
			tx_password.text = ""
			tx_name.text = ""
			tx_zybx.text = ""
			tx_zyxx.text = ""
			tx_zhbx.text = ""
			tx_need_zhbx.text = "0"
			tx_need_zybx.text = "0"
			tx_need_zyxx.text = "0"
			tx_need_ggxx.text = "0"
		
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			ssn.clean()
			tx_password.text = ""
			tx_name.text = ""
			tx_zybx.text = ""
			tx_zyxx.text = ""
			tx_zhbx.text = ""
			isLogin = false
			addUiListener()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			
			removeUiListener()
		}
		
		private function addUiListener()
		{
			btn_update.addEventListener(MouseEvent.CLICK, onUpdateClick)
			btn_create.addEventListener(MouseEvent.CLICK, onCreateClick)
			btn_load.addEventListener(MouseEvent.CLICK, onLoadClick)
			btn_delete.addEventListener(MouseEvent.CLICK, onDeleteClick)
			btn_addClass.addEventListener(MouseEvent.CLICK, onAddClassClick)
		}
		
		private function onAddClassClick(e:MouseEvent):void
		{
			tx_zhbx.text = commanClass + tx_zhbx.text
		}
		
		private function onCreateClick(e:MouseEvent):void
		{
			if (tx_name.text == "")
			{
				return
			}
			ssn.anime("warning.Error_hostNotFound")
			ssn.getAnime.tx_text.text = "请等待确认"
			var o:Array = []
			o.name = tx_name.text + ""
			o.password = tx_password.text + ""
			AMFPHP.callResult("GraduationHelper/createModule", onCreateResult, o)
		}
		
		private function onCreateResult(e:Object):void
		{
			if (e.state == "success")
			{
				ssn.getAnime.tx_text.text = "创建条目成功，请继续操作。"
				isLogin = true
			}
			if (e.state == "failed")
			{
				Message.GraduationHelper_Failed("创建失败，存在重复名字")
				ssn.clean()
			}
		
		}
		
		private function onLoadClick(e:MouseEvent):void
		{
			if (tx_name.text == "")
			{
				return
			}
			ssn.anime("warning.Error_hostNotFound")
			ssn.getAnime.tx_text.text = "请等待确认"
			var o:Array = []
			o.name = tx_name.text + ""
			o.password = tx_password.text + ""
			
			AMFPHP.callResult("GraduationHelper/loadModule", onLoadResult, o)
		}
		
		private function onLoadResult(e:Object)
		{
			
			if (e.state == "success")
			{
				isLogin = true
				ssn.getAnime.tx_text.text = "条目读取成功。"
				tx_zybx.text = e.data["zybx"]
				tx_zyxx.text = e.data["zyxx"]
				tx_zhbx.text = e.data["zhbx"]
				var arr:Array = String(e.data['point']).split(" ")
				tx_need_zhbx.text = arr[0]
				tx_need_zybx.text = arr[1]
				tx_need_zyxx.text = arr[2]
				tx_need_ggxx.text = arr[3]
			}
			if (e.state == "failed")
			{
				Message.GraduationHelper_Failed("密码错误或不存在该模板，请检查后重试，或者重新建立模板。" + e.message)
				ssn.clean()
			}
		
		}
		
		private function onDeleteClick(e:MouseEvent):void
		{
			if (tx_name.text == "")
			{
				return
			}
			Message.GraduationHelper_Warning(onDeleteConfrim, "您现在将要删除原来的课程模板，删除后无法复原，请确认无误后按确认")
		}
		
		private function onDeleteConfrim()
		{
			ssn.anime("warning.Error_hostNotFound")
			ssn.getAnime.tx_text.text = "请等待确认"
			var o:Array = []
			o.name = tx_name.text + ""
			o.password = tx_password.text + ""
			AMFPHP.callResult("GraduationHelper/deleteModule", onDeleteResult, o)
		}
		
		private function onDeleteResult(e:Object)
		{
			ssn.clean()
			if (e.state == "success")
			{
				Message.GraduationHelper_Message("删除模板成功。请重新建立新的模板")
				
			}
			if (e.state == "failed")
			{
				Message.GraduationHelper_Failed("操作失败，原因：" + e.message)
				
			}
		}
		
		private function onUpdateClick(e:MouseEvent):void
		{
			if (tx_name.text == "")
			{
				return
			}
			if (isLogin)
			{
				Message.GraduationHelper_Warning(onUpdateConfirm, "您现在将要覆盖原来的课程模板，覆盖后无法复原，请确认无误后按确认")
			}
		}
		
		private function onUpdateConfirm()
		{
			var o:Array = []
			o.name = tx_name.text + ""
			o.password = tx_password.text + ""
			o.zhbx = tx_zhbx.text
			o.zyxx = tx_zyxx.text
			o.zybx = tx_zybx.text
			o.point = tx_need_zhbx.text + " " + tx_need_zybx.text + " " + tx_need_zyxx.text + " " + tx_need_ggxx.text
			AMFPHP.callResult("GraduationHelper/editModule", onUpdateResult, o)
		}
		
		private function onUpdateResult(e:Object):void
		{
			if (e.state == "success")
			{
				Message.GraduationHelper_Message("模板更新成功。您可以在左边进行使用。")
			}
			if (e.state == "failed")
			{
				Message.GraduationHelper_Failed("操作失败，原因：" + e.message)
			}
		}
		
		private function removeUiListener()
		{
			
			btn_update.removeEventListener(MouseEvent.CLICK, onUpdateClick)
			btn_create.removeEventListener(MouseEvent.CLICK, onCreateClick)
			btn_load.removeEventListener(MouseEvent.CLICK, onLoadClick)
			btn_delete.removeEventListener(MouseEvent.CLICK, onDeleteClick)
			btn_addClass.removeEventListener(MouseEvent.CLICK, onAddClassClick)
		}
		
		public function activeMessage(msg:Object)
		{
			switch (msg)
			{
				case "": 
					break;
				default: 
					break;
			}
		
		}
		
		public function dispose()
		{
			removeUiListener()
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}