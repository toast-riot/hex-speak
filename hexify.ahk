#Requires AutoHotkey v2
#SingleInstance Force

;// BUG: MIN_LENGTH is ignored when HEX_COLORS is true

;// Config
MIN_LENGTH := 3
HEX_COLORS := false
CONVERSIONS := {
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

;// Main
RegHook := RegExHs("VI")
RegHook.NotifyNonText := true
RegHook.KeyOpt("{Space}{Tab}{Enter}", "+SN")
RegHook.Start()

rg := ""
for k in CONVERSIONS.OwnProps()
	rg .= k
rg := "[0-9a-f" rg "]{"

if HEX_COLORS
    RegHook.Add("^(?:" rg "3}|" rg "6}|" rg "8})$", call)
else
    RegHook.Add("^(?:" rg MIN_LENGTH ",})$", call)


#SuspendExempt true
!+q::ExitApp()
!+p::Suspend()
#SuspendExempt false


call(match) {
    s := StrUpper(match[0])
	for k, v in CONVERSIONS.OwnProps()
		s := StrReplace(s, k, v)
	Sleep(50)
	Send("{raw}" (HEX_COLORS ? "#" : "0x") s)
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