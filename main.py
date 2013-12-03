import base64
import random
import string

alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="

def encode_case0(x):
    return [alphabet[x >> 2]]

def encode_case1(x, y):
    return [alphabet[((x & 3) << 4) | (y >> 4)]]

def encode_case2(x, y):
    return [alphabet[(x & 15) << 2 | y >> 6], alphabet[y & 63]]

# AAAAAAAA-BBBBBBBB-CCCCCCCC
# AAAAAA-AABBBB-BBBBCC-CCCCCC
def encode64(string):
    if len(string) == 0:
        return ""

    prev = None
    i = 0
    result = []
    length = len(string)
    while i < length:
        curr = ord(string[i])
        mod = i % 3
        if mod == 0:
            result.extend(encode_case0(curr))
        elif mod == 1:
            result.extend(encode_case1(prev, curr))
        elif mod == 2:
            result.extend(encode_case2(prev, curr))

        i += 1
        prev = curr

    if mod == 0:
        result.append(alphabet[(prev & 3) << 4])
        result.append("==")
    elif mod == 1:
        result.append(alphabet[(prev & 15) << 2])
        result.append("=")

    return "".join(result)

# AAAAAA-BBBBBB-CCCCCC-DDDDDD
# AAAAAABB-BBBBCCCC-CCDDDDDD
def decode_case0(x, y):
    return [chr(x << 2 | y >> 4)]

def decode_case1(x, y):
    return [chr((x & 15) << 4 | y >> 2)]

def decode_case2(x, y):
    return [chr((x & 3) << 6 | y)]

def decode64(string):
    if len(string) == 0:
        return ""

    string = string.rstrip("=")

    prev = None
    i = 0
    result = []
    length = len(string)
    while i < length:
        curr = alphabet.index(string[i])
        mod = i % 4
        if mod == 1:
            result.extend(decode_case0(prev, curr))
        elif mod == 2:
            result.extend(decode_case1(prev, curr))
        elif mod == 3:
            result.extend(decode_case2(prev, curr))

        i += 1
        prev = curr

    return "".join(result)


# hat <-> aGF0
# "unit tests"
print encode_case0(104) == ["a"]
print encode_case1(104, 97) == ["G"]
print encode_case2(97, 116) == ["F", "0"]

print encode64("")

print decode64("")

print decode_case0(26, 6) == ["h"]
print decode_case1(6, 5) == ["a"]
print decode_case2(5, 52) == ["t"]


print ""
the_string = "hat"
print the_string
print encode64(the_string)
print decode64(encode64(the_string))

print ""
the_string = "chat"
print the_string
print encode64(the_string)
print decode64(encode64(the_string))

print ""
the_string = "hatch"
print the_string
print encode64(the_string)
print decode64(encode64(the_string))

print ""
the_string = "hatche"
print the_string
print encode64(the_string)
print decode64(encode64(the_string))

iterations = 100
for i in range(iterations):
    str_length = random.randint(1, 10000)
    the_string = ''.join(random.choice(string.printable) for x in range(str_length))
    encoded_mine = encode64(the_string)
    encoded_lib = base64.b64encode(the_string)
    if encoded_mine != encoded_lib:
        print "Failed to encode " + the_string
        print encoded_mine
        print encoded_lib
        continue

    decoded_mine = decode64(encoded_mine)
    decoded_lib = base64.b64decode(encoded_lib)

    if decoded_mine != decoded_lib:
        print "Failed to decode: " + the_string
        print encoded_mine
        print decoded_mine
        print decoded_lib
        continue
