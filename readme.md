# Hex Speak
A silly idea I had. Converts some words you type into "leet word" hex numbers. Inspired by [bada55.io](http://bada55.io).

For example:
| Word     | Hex        | Color                                     |
|----------|------------|-------------------------------------------|
| badass   | 0xBADA55   | $\color{#BADA55}{\textsf{\\#BADA55}}$     |
| coffee   | 0xC0FFEE   | $\color{#C0FFEE}{\textsf{\\#C0FFEE}}$     |
| loaded   | 0x10ADED   | $\color{#10ADED}{\textsf{\\#10ADED}}$     |
| delete   | 0xDE1E7E   | $\color{#DE1E7E}{\textsf{\\#DE1E7E}}$     |
| access   | 0xACCE55   | $\color{#ACCE55}{\textsf{\\#ACCE55}}$     |
| cat      | 0xCA7      | $\color{#CA7}{\textsf{\\#CA7}}$           |
| dog      | 0xD06      | $\color{#D06}{\textsf{\\#D06}}$           |
| allocate | 0xA110CA7E | $\color{#A110CA7E}{\textsf{\\#A110CA7E}}$ |
| toast    | 0x70A57    | -                                         |

- enabling "hex colors" will instead give you valid hex colors
- enabling "allow partial" will allow partial hexification (e.g. `codeblocks` -> `0xC0DEB10Cks`)

## Usage
Download the `.exe` from [releases](https://github.com/toast-riot/hex-speak/releases/latest) and run it.
To exit the AHK script, press <kbd><kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>q</kbd></kbd>, or use the tray icon. To temporarily pause the script, use <kbd><kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>p</kbd></kbd>

To change the config, you will need to download `hexify.ahk`, then edit the config at the top of the file.

## The Regex
`(\p{P}*)([0-9a-fA-F<<1>>]{<<2>>,}+)(<<3>>)(\p{P}*)`

Where:
`<<1>>` = a list of all leetspeak letters
`<<2>>` = `min_length`
`<<3>>` = `\w*` if `allow_compound`

## Other
There is also a (not updated) Python script included, which can be used to convert a string.

## Credits
The AHK script uses [RegexHotString by 8LWXpg](https://github.com/8LWXpg/RegExHotstring/).