import re

CONVERSIONS = {
    "g": "6",
    "i": "1",
    "l": "1",
    "o": "0",
    "p": "9",
    "r": "2",
    "s": "5",
    "t": "7",
    "z": "2"
}

def hexify(string, min_length=3, colors=False):
    if colors and min_length > 8:
        raise ValueError("min_length cannot exceed 8 when colors is True")

    def rpl(match):
        r = match.group(2)
        for a, b in CONVERSIONS.items():
            r = r.replace(a, b)
        return match.group(1) + ("#" if colors else "0x") + r.upper()

    m = f"[0-9a-f{''.join(CONVERSIONS)}]"
    if colors:
        m = "|".join(f"{m}{{{a}}}" for a in filter(lambda x: x >= min_length, (3, 6, 8)))
        reg = f"(^|\\s)({m})(?=$|\\s)"
    else:
        reg = f"(^|\\s)({m}{{{min_length},}})(?=$|\\s)"

    return re.sub(reg, rpl, string)


print(hexify('''
ff0000
badas5
coffee
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
place
'''))