package com.lizeqiangd.zweisystem.components.banword
{
	
	/**
	 * 使用方法:
	 * SensitiveWordFilter.regSensitiveWords(SensitiveWordFilter.negativeList+SensitiveWordFilter.mark+SensitiveWordFilter.googleBanList)
	 * var s:String =SensitiveWordFilter.findSensitiveWordsIn("Android就是屎啊.")
	 * trace(s) // "@[屎]"
	 * 2012-8-25 16:25:47
	 * @author General_Clarke
	 * @editBy Lizeqiangd
	 * @createDate 2013.01.26
	 * update 20140330 修改禁词 更改逻辑 增加注释
	 *
	 */
	public class SensitiveWordFilter
	{
		private static var treeRoot:TreeNode;
		private static var inited:Boolean = false
		private static var returnStr:String = "";
		public static const googleBanList:String = "自由光诚~光诚~沂南~使馆~职称英语~薄瓜瓜~海伍德~尼尔伍德~heywood~政变~枪声~戒严~薄督~谷开来~重庆~~连承敏~杨杰~陈刚~山水文园~跑官~十年兴衰~陈坚~戴坚~冯珏~罗川~马力~盛勇~谢岷~谢文~杨希~叶兵~张斌~陈瑞卿~高念书~华如秀~鲁向东~曲乃杰~孙静晔~涂志森~于剑鸣~张晓明~赵志强~郑建源~先皇~丘小雄~公诉~右派~增城~暴动~西乌旗~方滨兴~moli~突尼斯~茉莉~齐鲁银行~公开信~高考时间~诺贝尔和平奖~被就业~小屋~鲁昕~天安~1989~八九~六 四~平反64~5月35号~89动乱~学生动乱~镇压~64memo~tiananmen~8964~学潮~罢课~民运~学运~学联~学自联~高自联~工自联~民联~民阵~中国民主党~中国民主正义党~中国民主运动~世纪中国基金会~坦克人~挡坦克~tankman~木犀地~维园晚会~blood is on the square~姜维平~艾未未~艾末末~路青~发课~余杰~辛子陵~茅于轼~铁流~蟹农场~陈西~谭作人~高智晟~冯正虎~丁子霖~唯色~焦国标~何清涟~耀邦~紫阳~方励之~严家其~鲍彤~鮑彤~鲍朴~柴玲~乌尔凯西~封从德~炳章~苏绍智~陈一谘~韩东方~辛灏年~曹长青~陈破空~盘古乐队~盛雪~伍凡~魏京生~司徒华~黎安友~防火长城~国家防火墙~翻墙~hotspot~无界~ultrasurf~freenet~safeweb~撸管~动态网~花园网~cache~阅后即焚~法轮~falun~明慧~minghui~退党~三退~九评~gfn~nine commentaries~洪吟~神韵艺术~神韵晚会~人民报~renminbao~纪元~dajiyuan~epochtimes~新唐人~ntdtv~ndtv~新生网~xinsheng~正见网~zhengjian~追查国际~真善忍~法会~正念~经文~天灭~天怒~讲真相~马三家~善恶有报~活摘器官~群体灭绝~中功~张宏堡~地下教会~冤民大同盟~达赖~藏独~freetibet~雪山狮子~西藏流亡政府~民进党~洪哲胜~台湾~新疆~东土耳其斯坦~迪里夏提~美国之音~自由亚洲电台~记者无疆界~维基解密~facebook~twitter~推特~新京报~世界经济导报~中国数字时代~ytht~新语丝~creaders~tianwang~禁闻~阿波罗网~阿波罗新闻~大参考~bignews~多维~看中国~博讯~boxun~peacehall~hrichina~独立中文笔会~华夏文摘~开放杂志~大家论坛~华夏论坛~中国论坛~木子论坛~争鸣论坛~大中华论坛~反腐败论坛~新观察论坛~新华通论坛~正义党论坛~热站政论网~华通时事论坛~华语世界论坛~华岳时事论坛~两岸三地论坛~南大自由论坛~人民之声论坛~万维读者论坛~你说我说论坛~东西南北论坛~东南西北论谈~知情者~红太阳的陨落~和谐拯救危机~血房~一个孤僻的人~零八宪章~八宪章~08县长~淋巴县长~我的最后陈述~我没有敌人~河殇~天葬~黄祸~历史的伤口~prisoner of the state~改革年代的政治斗争~改革年代政治斗争~关键时刻~超越红墙~梦萦未名湖~一寸山河一寸血~政治局常委内幕~北国之春~北京之春~中国之春~东方红时空~纳米比亚~婴儿汤~泄题~罢餐~月月~钓鱼岛~^triangle~女保镖~玩ps~玩photoshop~chinese people eating babies~迫害~酷刑~邪恶~洗脑~网特~内斗~党魁~文字狱~一党专政~一党独裁~新闻封锁~老人政治~freedom~freechina~反社会~维权人士~维权律师~异见人士~异议人士~地下刊物~高瞻~共产~共铲党~共残党~共惨党~共匪~赤匪~中共~中宣~真理部~十八大~18大~上海帮~团派~北京当局~裆中央~九常委~九长老~锦涛~近平~回良玉~汪洋~张高丽~俞正声~徐才厚~郭伯雄~熙来~梁光烈~孟建柱~戴秉国~马凯~令计划~韩正~章沁生~陈世炬~泽民~邓小平~庆红~罗干~假庆淋~hujin~wenjiabao~xijinping~likeqiang~zhouyongkang~lichangchun~wubangguo~heguoqiang~jiaqinglin~jiangzemin~xjp~jzm~tits~boobs"
		public static const negativeList:String = "尿~屎~粪~一生平安~色情~傻逼~弱智~脑残~SB~sb~2b~低能~艹~操~你妈~屮~肏~屌~叼~日~蛋疼~缩卵~鄙视~我去~次奥~傻B~贼~郁闷~难受~恶心"
		public static const mark:String = "~"
		public static const findMark:String ="@"
		
		/**
		 * 输入要被禁的词列表,用~分隔.只能初始化一次,请在使用前初始化该类..注意会消耗大量的cpu去建立树状图.
		 * 使用方法:
		 * SensitiveWordFilter.regSensitiveWords(SensitiveWordFilter.negativeList+SensitiveWordFilter.mark+SensitiveWordFilter.googleBanList)
		 * @param	sensitiveWords
		 */
		public static function regSensitiveWords(sensitiveWords:String = ""):void
		{
			var words:Array = (sensitiveWords).split("~")
			//这是一个预处理步骤，生成敏感词索引树，功耗大于查找时使用的方法，但只在程序开始时调用一次。
			treeRoot = new TreeNode();
			treeRoot.value = "";
			var words_len:int = words.length;
			for (var i:int = 0; i < words_len; i++)
			{
				var word:String = words[i];
				var len:int = word.length;
				var currentBranch:TreeNode = treeRoot;
				for (var c:int = 0; c < len; c++)
				{
					currentBranch.isLeaf = false;
					var char:String = word.charAt(c);
					var tmp:TreeNode = currentBranch.getChild(char);
					if (tmp)
					{
						if (tmp.isLeaf)
						{
							//trace("长词在短词后被注册。已经有以(" + tmp.getFullWord() + ")开头的敏感词存在,当前正在注册第" + i + "个词(" + word + ")")
							
							throw new Error("长词在短词后被注册。已经有以(" + tmp.getFullWord() + ")开头的敏感词存在,当前正在注册第" + i + "个词(" + word + ")");
							
							currentBranch = tmp;
						}
						else
						{
							currentBranch = currentBranch.setChild(char);
						}
						if (!currentBranch.isLeaf)
						{
							{
								
								//trace("短词在长词后被注册。已经有以(" + word + ")开头的敏感词存在,当前正在注册第" + i + "个词")
								
								throw new Error("短词在长词后被注册。已经有以(" + word + ")开头的敏感词存在,当前正在注册第" + i + "个词");
							}
						}
					}
					inited = true
					trace("广播:SensitiveWordFilter已经初始化完毕。共有" + words.length + "个词导入.")
				}
			}
		}
		
		/**
		 * 需要检测的段落.
		 * SensitiveWordFilter.regSensitiveWords(SensitiveWordFilter.negativeList+SensitiveWordFilter.mark+SensitiveWordFilter.googleBanList)
		 * var s:String =SensitiveWordFilter.findSensitiveWordsIn("Android就是屎啊.")
		 * trace(s) // "@[屎]"
		 * @param	og
		 * @return
		 */
		public static function findSensitiveWordsIn(og:String):String
		{
			returnStr = ""
			if (!inited)
			{
				trace("SensitiveWordFilter.findSensitiveWordsIn: not init yet.")
				return returnStr
			}
			var ptrs:Array = new Array //嫌疑列表，但凡前几个字匹配成功的节点都放在这里
			var len:int = og.length;
			var tmp:TreeNode;
			for (var c:int = 0; c < len; c++)
			{
				var char:String = og.charAt(c);
				//如果嫌疑列表内有数据，先对其进行检验，检查char是否是嫌疑列表中某节点的下一个字
				var p:int = ptrs.length;
				while (p--)
				{
					var node:TreeNode = ptrs.shift();
					tmp = node.getChild(char);
					if (tmp)
					{
						if (tmp.isLeaf)
						{
							///源代码到此就输出结果了. 而我则增加了一个字符串列表.输出一共又多少处敏感词.
							returnStr += tmp.getFullWord() + " @[" + c + "] "
						}
						ptrs.push(tmp);
					}
				}
				tmp = treeRoot.getChild(char);
				if (tmp)
				{
					if (tmp.isLeaf)
					{
						returnStr += tmp.getFullWord() +" "+findMark +"[" + c + "] "
					}
					//如果是一个字的敏感词，直接返回
					ptrs.push(tmp);
					//如果匹配上了非单字敏感词的第一个字，那么将其加入嫌疑列表
				}
			}
			return returnStr;
		}	
	}
}