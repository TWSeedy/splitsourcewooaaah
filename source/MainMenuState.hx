package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var supahmarioirl:Bool = false;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.4" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var bg:FlxSprite;
	var bgFront:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
        bg.scrollFactor.x = 0;
        bg.scrollFactor.y = 0;
        bg.setGraphicSize(Std.int(bg.width * 0.82));
        bg.updateHitbox();
        bg.screenCenter();
        bg.visible = true;
        bg.antialiasing = true;
        add(bg);

        camFollow = new FlxObject(0, 0, 1, 1);
        add(camFollow);

        magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
        magenta.scrollFactor.x = 0;
        magenta.scrollFactor.y = 0;
        magenta.setGraphicSize(Std.int(magenta.width * 0.82));
        magenta.updateHitbox();
        magenta.screenCenter();
        magenta.visible = false;
        magenta.antialiasing = true;
        add(magenta);
		// magenta.scrollFactor.set();

		bgFront = new FlxSprite(-100).loadGraphic(Paths.image('menuBGFrontMain'));
        bgFront.scrollFactor.x = 0;
        bgFront.scrollFactor.y = 0;
        bgFront.setGraphicSize(Std.int(bgFront.width * 0.82));
        bgFront.updateHitbox();
        bgFront.screenCenter();
        bgFront.visible = true;
        bgFront.antialiasing = true;
        add(bgFront);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');


		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 0);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			for (str in menuItems)
			if (str.ID == 0) //could probably make this positioning shit better but im too lazy
				{
					str.x = 50;
					str.y = 59;
					str.scale.x = 0.8;
					str.scale.y = 0.8;
				}
			for (str in menuItems)
			if (str.ID == 1)
				{
					str.x = -38;
					str.y = 2;
					str.scale.x = 0.7;
					str.scale.y = 0.7;
				}
			for (str in menuItems)
			if (str.ID == 2)
				{
					str.x = -15;
					str.y = 160;
					str.scale.x = 0.7;
					str.scale.y = 0.7;
				}
			for (str in menuItems)
			if (str.ID == 3)
				{
					str.x = 67;
					str.y = 541;
					str.scale.x = 0.8;
					str.scale.y = 0.8;
				}
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			finishedFunnyMove = true;
			changeItem();
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{	
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}	

			if (optionShit[curSelected] == 'story mode') //i dont care if this isnt efficient + ratio
				{
					for (str in menuItems)
					if (str.ID == 0)
						{
							str.x = 50;
							str.y = 59;
						}
				}
			if (optionShit[curSelected] != 'story mode')
				{
					for (str in menuItems)
					if (str.ID == 0)
						{
							str.x = 58;
							str.y = 79;
						}
				}
			if (optionShit[curSelected] == 'freeplay')
				{
					for (str in menuItems)
					if (str.ID == 1)
						{
							str.x = -13;
							str.y = 5;
						}
				}
			if (optionShit[curSelected] != 'freeplay')
				{
					for (str in menuItems)
					if (str.ID == 1)
						{
							str.x = -38;
							str.y = 2;
						}
				}
			if (optionShit[curSelected] == 'donate')
				{
					for (str in menuItems)
					if (str.ID == 2)
						{
							str.x = 8;
							str.y = 158;
						}
				}
			if (optionShit[curSelected] != 'donate')
				{
					for (str in menuItems)
					if (str.ID == 2)
						{
							str.x = -15;
							str.y = 160;
						}
				}
			if (optionShit[curSelected] == 'options')
				{
					for (str in menuItems)
					if (str.ID == 3)
						{
							str.x = 42;
							str.y = 523;
						}
				}
			if (optionShit[curSelected] != 'options')
				{
					for (str in menuItems)
					if (str.ID == 3)
						{
							str.x = 67;
							str.y = 541;
						}
				}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://www.youtube.com/user/NikocadoAvocado");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, true);

					new FlxTimer().start(1.25, function(tmr:FlxTimer)
					{
						bg.visible = false;
						FlxTween.tween(magenta, {alpha: 0}, 0.35);
						FlxTween.tween(bgFront, {alpha: 0}, 0.35);
					});

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										goToState();
									});
								});
							}
							else
							{
								new FlxTimer().start(1.5, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
