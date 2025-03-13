import re

def hexify(string, min_length = 3, colors=False):
    def rpl(match):
        r = match.group(2)
        for a, b in {"g": "6", "i": "1", "l": "1", "o": "0", "s": "5", "t": "7", "z": "2"}.items():
            r = r.replace(a, b)
        return match.group(1) + ("#" if colors else "0x") + r.upper()
    if colors:
        reg = "(^|\\s)([0-9abcdefgilostz]{3}|[0-9abcdefgilostz]{6}|[0-9abcdefgilostz]{8})(?=$|\\s)"
    else:
        reg = f"(^|\\s)([0-9abcdefgilostz]{{{min_length},}})(?=$|\\s)"
    return re.sub(reg, rpl, string)

test = '''
ff0000
bada55
c0ffee
salted
oracle
lol
sos
123
abdicate
543a09e0
test
none
thr
pragma
zen
'''

print(hexify(test))