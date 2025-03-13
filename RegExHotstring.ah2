#Requires AutoHotkey v2.0

RegHook := RegExHs("VI")
RegHook.NotifyNonText := true
RegHook.KeyOpt("{Space}{Tab}{Enter}", "+SN")
RegHook.Start()

; This is a MODIFIED version of https://github.com/8LWXpg/RegExHotstring/

RegExHotstring(Str, CallBack, Options := "") {
	RegHook.Add(Str, CallBack, Options)
}

class RegExHs extends InputHook {
	; stores with RegEx string as key and obj as value
	hs := Map()

	; append new RegExHotstring
	Add(Str, CallBack, Options) {
		this.hs[Str] := {str: Str, callback: CallBack}
	}

	OnKeyDown := this.keyDown
	keyDown(vk, sc) {
		if (vk = 8 || vk = 160 || vk = 161)
			return

		if (vk != 32 && vk != 9 && vk != 13) {
			this.Stop()
			this.Start()
			return
		}

		; find the last pattern without \s
		if (!RegExMatch(this.Input, "(\S+)(?![\s\S]*(\S+))", &match)) {
			this.Stop()
			Send("{Blind}{vk" Format("{:02x}", vk) " down}")
			this.Start()
			return
		}
		input := match[1]
		this.Stop()
		; loop through each strings and find the first match
		for , obj in this.hs {
			callback := obj.callback
			start := RegExMatch(input, obj.str, &match)
			if (start) {
				Send("{BS " match.Len[0] "}")
				callback(match)
				Send("{Blind}{vk" Format("{:02x}", vk) " down}")
				this.Start()
				return
			}
		}
		Send("{Blind}{vk" Format("{:02x}", vk) " down}")
		this.Start()
	}

	OnKeyUp := this.keyUp
	keyUp(vk, sc) {
		if (vk = 32 || vk = 9 || vk = 13)
			Send("{Blind}{vk" Format("{:02x}", vk) " up}")
	}
}