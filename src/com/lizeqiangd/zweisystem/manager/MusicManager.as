package com.lizeqiangd.zweisystem.manager
{
	
	import com.lizeqiangd.zweisystem.data.media.Music;
	import com.lizeqiangd.zweisystem.data.media.PlayList;
	import com.lizeqiangd.zweisystem.events.MusicEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	
	/**
	 * MusicManager背景音乐管理器..用于全网站的音乐播放管理.
	 * 用户可以开发播放器并调用本管理器控制.这样用户只需要侧重于界面的制作.
	 * 本类可以输入com.lizeqiangd.zweisystem.data.media.Music的音乐进行播放,同时也提供url的直接播放功能.
	 * 拥有方法:play pause stop volume
	 * 拥有属性:position 当前music实例
	 * 特别注意 本类不能控制左右声道,如果要做特效,请出门左转SEManager
	 * 音乐是外部的widget或者其他player控制的.本类只负责音乐核心部分的处理.
	 * 2014.05.16:完善可用.
	 *
	 */
	public class MusicManager
	{
		private static var _eventDispatcher:EventDispatcher;
		private static var _s:Sound;
		private static var _st:SoundTransform;
		private static var _sc:SoundChannel;
		private static var _nowPlayingMusic:Music;
		
		private static var _targetVolume:Number = 1;
		private static var _beforeMuteVolume:Number = 1;
		private static var _nowPosition:uint = 0;
		
		private static var _isPlaying:Boolean = false;
		
		/**
		 * 初始化该管理器,默认是5秒缓存.
		 */
		public static function init():void
		{
			_s = new Sound();
			//_nowPlayingMusic = new Music();
			_eventDispatcher = new EventDispatcher();
			_st = new SoundTransform()
			_sc = new SoundChannel()
			SoundMixer.bufferTime = 5
			_nowPlayingMusic = new Music
			_s.addEventListener(Event.COMPLETE, onSoundEvent)
		}
		
		/**
		 * 音乐事件类的封装转发.
		 * @param	e
		 */
		static private function onSoundEvent(e:Event):void
		{
			switch (e.type)
			{
				case Event.COMPLETE: 
					_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.MUSIC_LOADED))
					break;
				case Event.ID3: 
					break;
				case IOErrorEvent.IO_ERROR: 
					_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.MUSIC_ERROR))
					break;
				case Event.OPEN: 
					_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.MUSIC_OPEN))
					break;
				case ProgressEvent.PROGRESS: 
					_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.PROGRESS, {estimatedLength: Math.ceil(_s.length / (_s.bytesLoaded / _s.bytesTotal)), bytesLoaded: _s.bytesLoaded, bytesTotal: _s.bytesTotal}))
					break;
				case Event.SOUND_COMPLETE: 
					_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.MUSIC_COMPLETE))
					break;
			}
		}
		
		public static function addEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.addEventListener(type, listener, false, 0.0, true);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.removeEventListener(type, listener);
		}
		
		/**
		 * 开始加载一首一个Music实例,并将正在播放音乐切换成参数音乐.
		 * @param	song
		 */
		public static function load(song:Music):void
		{
			stop()
			_nowPlayingMusic = song;
			_s.load(new URLRequest(_nowPlayingMusic.musicUrl))
		}
		
		/**
		 * 简便方法,直接load一个url.
		 * @param	s
		 */
		public static function loadUrl(s:String):void
		{
			stop()
			var song:Music = new Music;
			song.album = "UnknownAblum";
			song.artist = "UnknownArtist";
			song.musicUrl = s;
			song.coverUrl = "";
			song.id = 0;
			song.name = "UnknownSongName";
			_nowPlayingMusic = song;
			_s.load(new URLRequest(_nowPlayingMusic.musicUrl));
		}
		
		/**
		 * 播放音乐,当无参数提交的时候会检查是否之前有在播放音乐,有则恢复播放.
		 * 如果
		 * @param	song
		 */
		public static function play():void
		{
			if (_nowPlayingMusic.musicUrl && !_isPlaying)
			{
				_sc = _s.play(_nowPosition, 1, _st);
				_isPlaying = true;
				_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.MUSIC_PLAY))
				_sc.addEventListener(Event.SOUND_COMPLETE, onSoundEvent)
			}
			else
			{
				trace("MusicManager.play:no music loaded")
			}
		}
		
		/**
		 * 暂停播放音乐.记录当前位置.
		 */
		public static function pause():void
		{
			if (_isPlaying)
			{
				_nowPosition = _sc.position
				_isPlaying = false
				_sc.stop();
				_sc.removeEventListener(Event.SOUND_COMPLETE, onSoundEvent)
				_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.MUSIC_STOP))
			}
		}
		
		/**
		 * 停止播放音乐,效果是暂停.但是好写一些.
		 */
		public static function stop():void
		{
			if (_isPlaying)
			{
				_isPlaying = false
				_nowPosition = 0;
				_sc.stop();
				_sc.removeEventListener(Event.SOUND_COMPLETE, onSoundEvent)
				_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.MUSIC_STOP))
				_s = new Sound()
			}
		}
		
		/**
		 * 设置播放时间的位置,播放时间单位为毫秒.
		 * @param	s
		 */
		public static function position(s:int):void
		{
			if (_isPlaying)
			{
				_sc.stop();
				_s.play(s, 1, _st)
				_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.POSITION_CHANGED))
			}
			else
			{
				_nowPosition = s
				_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.POSITION_CHANGED))
			}
		}
		
		/**
		 * 获取声音的SoundTransform;
		 */
		public static function get st():SoundTransform
		{
			return _st
		}
		
		/**
		 * 获取声音的SoundChannal
		 */
		public static function get sc():SoundChannel
		{
			return _sc
		}
		
		/**
		 * 设置缓存时间,单位秒
		 */
		public static function set bufferTime(s:int):void
		{
			SoundMixer.bufferTime = s
		}
		
		/**
		 * 设置目标的音量
		 */
		public static function set targetVolume(s:Number):void
		{
			s > 1 ? s = 1 : null;
			s < 0 ? s = 0 : null;
			_targetVolume = s;
			StageProxy.addEnterFrameFunction(changeVolume);
		}
		
		/**
		 * 获取目标的音量.
		 */
		public static function get targetVolume():Number
		{
			return _targetVolume;
		}
		
		/**
		 * 直接设置当前音量
		 */
		public function set nowVolume(s:Number):void
		{
			_st.volume = s
		}
		
		/**
		 * 获取当前音量的音量大小.
		 */
		public static function get nowVolume():Number
		{
			return _st.volume;
		}
		
		/**
		 * 返回当前音乐的总长度.
		 */
		public static function get length():Number
		{
			return _s.length
		}
		
		/**
		 * 返回当前正在播放的音乐实例
		 */
		public static function get getNowPlayMusic():Music
		{
			return _nowPlayingMusic
		}
		
		/**
		 * 设置静音. 取消后回复之前的音量.
		 */
		public static function set mute(s:Boolean):void
		{
			if (s)
			{
				_beforeMuteVolume = _targetVolume;
				_st.volume = 0;
				_eventDispatcher.dispatchEvent(new MusicEvent(MusicEvent.MUTED))
			}
			if (!s)
			{
				targetVolume = _beforeMuteVolume;
			}
		}
		
		/**
		 * 获取当前是否为静音模式
		 */
		public static function get mute():Boolean
		{
			if (_st.volume == 0 && _targetVolume > 0)
			{
				return true
			}
			else
			{
				return false
			}
		}
		
		/**
		 * 内部方法:渐变音量
		 */
		private static function changeVolume():void
		{
			if (targetVolume > _st.volume)
			{
				_st.volume += 0.05;
				targetVolume < _st.volume ? _st.volume = targetVolume : null;
				_sc.soundTransform = _st;
			}
			if (targetVolume < _st.volume)
			{
				_st.volume -= 0.05;
				targetVolume > _st.volume ? _st.volume = targetVolume : null;
				_sc.soundTransform = _st;
			}
			if (targetVolume == _st.volume)
			{
				StageProxy.removeEnterFrameFunction(changeVolume);
			}
		}
		
		/**
		 * 销毁本类.
		 */
		public static function dispose():void
		{
		}
	}
}