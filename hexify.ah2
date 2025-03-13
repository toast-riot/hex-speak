#Requires AutoHotkey v2
#SingleInstance Force

; Config
MIN_LENGTH := 3
HEX_COLORS := false

RegHook := RegExHs("VI")
RegHook.NotifyNonText := true
RegHook.KeyOpt("{Space}{Tab}{Enter}", "+SN")
RegHook.Start()

if HEX_COLORS
    RegHook.Add("^(?:[0-9abcdefgilostz]{3}|[0-9abcdefgilostz]{6}|[0-9abcdefgilostz]{8})$", call)
else
    RegHook.Add("^(?:[0-9abcdefgilostz]{" MIN_LENGTH ",})$", call)

call(match) {
    s := HEX_COLORS ? "#" : "0x"
    s .= StrUpper(match[0])
    s := StrReplace(s, "g", "6")
    s := StrReplace(s, "i", "1")
    s := StrReplace(s, "l", "1")
    s := StrReplace(s, "o", "0")
    s := StrReplace(s, "s", "5")
    s := StrReplace(s, "t", "7")
    s := StrReplace(s, "z", "2")
	Send("{raw}" s)
}


; Below is a MODIFIED version of https://github.com/8LWXpg/RegExHotstring/
class RegExHs extends InputHook {
	hs := Map()

	Add(Str, CallBack) {
		this.hs[Str] := CallBack
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
		for str, callback in this.hs {
			start := RegExMatch(input, str, &match)
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