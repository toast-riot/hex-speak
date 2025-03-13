import re

def hexify(s):
    def rpl(match):
        prefix = match.group(1)
        r = match.group(2)
        r = r.replace("g","6")
        r = r.replace("i","1")
        r = r.replace("l","1")
        r = r.replace("o","0")
        r = r.replace("s","5")
        r = r.replace("t","7")
        r = r.replace("z","2")
        r = "0x" + r.upper()
        return prefix + r
    return re.sub("(^|\\s)([0-9abcdefgilostz]+)(?=$|\\s)", rpl, s)

def hexify_colors(s):
    def rpl(m):
        prefix = m.group(1)
        r = m.group(2)
        r = r.replace("g","6")
        r = r.replace("i","1")
        r = r.replace("l","1")
        r = r.replace("o","0")
        r = r.replace("s","5")
        r = r.replace("t","7")
        r = r.replace("z","2")
        r = r.upper()
        r = "#" + r
        return prefix + r
    return re.sub("(^|\\s)([0-9abcdefgilostz]{3}|[0-9abcdefgilostz]{6}|[0-9abcdefgilostz]{8})(?=$|\\s)", rpl, s)

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

# print(hexify(test))
print(hexify(test))