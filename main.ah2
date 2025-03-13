#Requires AutoHotkey v2
#SingleInstance Force
#Include RegExHotstring.ah2

MIN_LENGTH := 3
HEX_COLORS := false

if HEX_COLORS
    RegExHotstring("^(?:[0-9abcdefgilostz]{3}|[0-9abcdefgilostz]{6}|[0-9abcdefgilostz]{8})$", call)
else
    ; RegExHotstring("(^|\s)(?:[0-9abcdefgilostz]{" MIN_LENGTH ",})", call)
    RegExHotstring("^(?:[0-9abcdefgilostz]{" MIN_LENGTH ",})$", call)

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

#q::ExitApp()
#r::Reload()
#t::MsgBox("Running")