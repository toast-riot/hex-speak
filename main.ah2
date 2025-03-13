#Requires AutoHotkey v2
#SingleInstance Force
#Include RegExHotstring.ah2

RegExHotstring("(^|\s)(?:[0-9abcdefgilostz]{3}|[0-9abcdefgilostz]{6}|[0-9abcdefgilostz]{8})", call)

call(match) {
    s := match[0]
    s := StrReplace(s, "g", "6")
    s := StrReplace(s, "i", "1")
    s := StrReplace(s, "l", "1")
    s := StrReplace(s, "o", "0")
    s := StrReplace(s, "s", "5")
    s := StrReplace(s, "t", "7")
    s := StrReplace(s, "z", "2")
	Send("{raw}#" s)
}

#q::ExitApp()
#r::Reload()
#t::MsgBox("Running")