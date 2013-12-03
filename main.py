#6 bits
#bit1 = ord(x[0]) >> 2

#2 bits and 4 bits
#bit2 = (ord(x[0]) & 3) << 4 | ord(x[1]) >> 4

#4 bits and 2 bits
#bit3 = (ord(x[1]) & 15) << 2 | ord(x[2]) >> 6

#6 bits
#bit4 = ord(x[2]) & 63
import base64

alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="

def case0(x):
    return [alphabet[x >> 2]]

def case1(x, y):
    return [alphabet[((x & 3) << 4) | (y >> 4)]]

def case2(x, y):
    return [ alphabet[(x & 15) << 2 | y >> 6], alphabet[y & 63]]

def encode64(string):
    prev = None
    i = 0
    result = []
    length = len(string)
    while i < length:
        curr = ord(string[i])
        mod = i % 3
        if mod == 0:
            result.extend(case0(curr))
        elif mod == 1:
            result.extend(case1(prev, curr))
        elif mod == 2:
            result.extend(case2(prev, curr))

        i += 1
        prev = curr

    if mod == 0:
        result.append(alphabet[(prev & 3) << 4])
        result.append("==")
    elif mod == 1:
        result.append(alphabet[(prev & 15) << 2])
        result.append("=")

    return "".join(result)


print case0(104) == ["a"]
print case1(104, 97) == ["G"]
print case2(97, 116) == ["F", "0"]

the_string = "hatch"

print encode64(the_string)
print encode64(the_string) == base64.b64encode(the_string)

