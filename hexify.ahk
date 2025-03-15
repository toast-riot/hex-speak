#Requires AutoHotkey v2
#SingleInstance Force

;// Config
class CONFIG {
	; The minimum length of text that can be hexified
	; NOTE: This is ignored if hex_colors is true
	static min_length := 3

	; Whether to only output valid hex colors
	static hex_colors := false

	; Whether to allow partial hexification (e.g. "codeblocks" -> "0xC0DEB10Cks")
	static allow_partial := false

	; What letters to convert to numbers
	static conversions := {
		g: "6",
		i: "1",
		l: "1",
		o: "0",
		p: "9",
		r: "2",
		s: "5",
		t: "7",
		z: "2"
	}

	; The format for output text
	; - PREFIX: "0x" (or "#" if hex_colors is true)
	; - HEX: the hexified part of the word
	; - NORM: the non-hexified part of the word
	; - ORIGINAL: the original word

	; The get method is overridden to allow for dynamic formatting. For example:
	; if WinActive("ahk_exe Notepad.exe")
	;    return "`{{PREFIX}}{{HEX}}`{{NORM}}"
	static format_string {
		get {
			return "{{PREFIX}}{{HEX}}{{NORM}}"
		}
	}
}



;// Main
RegHook := RegExHs("VI")
RegHook.NotifyNonText := true
RegHook.KeyOpt("{Space}{Tab}{Enter}", "+SN")
RegHook.Start()

rg := ""
for k in config.conversions.OwnProps()
	rg .= StrUpper(k) StrLower(k)
rg := "[0-9a-fA-F" rg "]{"

if config.hex_colors
    RegHook.Add("^(\p{P}*)(" rg "8}|" rg "6}|" rg "3}+)(" (config.allow_partial ? "\w*" : "") ")(\p{P}*)$", call)
else
	RegHook.Add("^(\p{P}*)(" rg config.min_length ",}+)(" (config.allow_partial ? "\w*" : "") ")(\p{P}*)$", call)

#SuspendExempt true
!+q::ExitApp()
!+p::Suspend()
#SuspendExempt false


call(match) {
    s := StrUpper(match[2])
	for k, v in config.conversions.OwnProps()
		s := StrReplace(s, k, v)

	rep := {
		PREFIX: (config.hex_colors ? "#" : "0x"),
		HEX: s,
		NORM: match[3],
		ORIGINAL: match[2] match[3]
	}

	formatted := config.format_string
	if (formatted is Integer) and !formatted
		formatted := REP.ORIGINAL
	else
		for k, v in rep.OwnProps()
			formatted := StrReplace(formatted, "{{" k "}}", v)

	Sleep(50)
	Send("{raw}" match[1] formatted match[4])
}

;// Below is a MODIFIED version of https://github.com/8LWXpg/RegExHotstring/
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

		if A_IsSuspended {
			Send("{Blind}{vk" Format("{:02x}", vk) " down}")
			return
		}

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