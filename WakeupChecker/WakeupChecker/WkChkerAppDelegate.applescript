--
--  WakeCheckerAppDelegate.applescript
--  WakeChecker
--
--  Created by sandwitchman on 2013/07/19.
--  Copyright (c) 2013年 sandwitchman. All rights reserved.
--

script WkChkerAppDelegate
	property parent : class "NSObject"
    
    ----------------------------
    --define
    ----------------------------
    property TOOL_CHIP_MSG   : "WakeChecker"
    property WC_ICON_IMAGE   : "wakeCheckerIcon2"
    property NS_WS_WK_SELCTR : "wakeUp:"
    property NS_WS_WK_NOTFY  : "NSWorkspaceDidWakeNotification"
    property NS_WS_WK_MSG_EN : "Good morning, my master"
    property KYOKO_VOICE     : "com.apple.speech.synthesis.voice.kyoko.premium"
    property NS_WS_WK_MSG_JP : "おはようございます、マイマスター"
    --calss define
    property NSStatusBar         : class "NSStatusBar"
    property NSImage             : class "NSImage"
    property NSWorkspace         : class "NSWorkspace"
    property NSSpeechSynthesizer : class "NSSpeechSynthesizer"
    --property NSVariableStatusItemLength : (-1)
    
    ----------------------------
    --outlet
    ----------------------------
    property wcMenu  : missing value
    
    ----------------------------
    --var
    ----------------------------
    property _wcItem    : missing value
    property _wcWkcnter : missing value
    property _spchSynth : missing value
    property _vRecord   : missing value
    
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened
        my createMenuItem()
        if my checkAvailableVoicesList(KYOKO_VOICE) then
            set my _vRecord to {voice:KYOKO_VOICE, wakeup:NS_WS_WK_MSG_JP}
        else
            set my _vRecord to {voice:NSSpeechSynthesizer's defaultVoice(), wakeup:NS_WS_WK_MSG_EN}
        end if
        set my _spchSynth to NSSpeechSynthesizer's alloc()'s initWithVoice_(voice of my _vRecord)
        --my _spchSynth's setDelegate_(me)
        set my _wcWkcnter to my NSWorkspace's sharedWorkspace()'s notificationCenter()
        my _wcWkcnter's addObserver_selector_name_object_(me, NS_WS_WK_SELCTR, NS_WS_WK_NOTFY, missing value)
        
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits
        my _spchSynth's release()
        my _wcWkcnter's removeObserver_name_object_(me, NS_WS_WK_NOTFY, missing value)
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    
    
    ----------------------------
    --スリープ実行
    ----------------------------
    on sleep_(sender)
        tell application "System Events"
            sleep
        end tell
    end sleep_
    
    ----------------------------
    --メニューアイテム生成
    ----------------------------
    on createMenuItem()
        set my _wcItem to (NSStatusBar's systemStatusBar())'s statusItemWithLength_(-1)
        my _wcItem's setHighlightMode_(true)
        my _wcItem's setToolTip_(TOOL_CHIP_MSG)
        my _wcItem's setImage_(NSImage's imageNamed_(WC_ICON_IMAGE))
        my _wcItem's setMenu_(my wcMenu)
    end createMenuItem
	
    ----------------------------
    --通知メソッド
    ----------------------------
    on wakeUp_(notification)
        try
            my _spchSynth's startSpeakingString_(wakeup of my _vRecord)
        on error
            log "Speech Failed" --debug
        end try
    end wakeUp_
    
    ----------------------------
    --実行可能ボイスチェック
    ----------------------------
    on checkAvailableVoicesList(voiceName)
        set vlist to NSSpeechSynthesizer's availableVoices() as list
        repeat with voiceStrName in vlist
            set chrPos to the offset of voiceName in voiceStrName
            if chrPos is not equal to 0 then return true
        end repeat
        return false
    end checkAvailableVoicesList
    
end script