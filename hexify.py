import re

def hexify(string, min_length = 3, colors=False):
    def rpl(match):
        r = match.group(2)
        r = r.replace("g","6")
        r = r.replace("i","1")
        r = r.replace("l","1")
        r = r.replace("o","0")
        r = r.replace("s","5")
        r = r.replace("t","7")
        r = r.replace("z","2")
        r = ("#" if colors else "0x") + r.upper()
        return match.group(1) + r
    if colors:
        reg = "(^|\\s)([0-9abcdefgilostz]{3}|[0-9abcdefgilostz]{6}|[0-9abcdefgilostz]{8})(?=$|\\s)"
    else:
        reg = f"(^|\\s)([0-9abcdefgilostz]{{{min_length},}})(?=$|\\s)"
    return re.sub(reg, rpl, string)

test = '''
## tests
- general
ff0000
bada55
c0ffee
salted
oracle

- three-letter
lol
sos
123

- six-letter
abdicate
54340920

- none
test
none
thr
pragma
zen
'''

print(hexify(test))
# print(hexify(test, True))