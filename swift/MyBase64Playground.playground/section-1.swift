let alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
var intAlphabet: [UInt8] = []
var charAlphabet: [Character] = []

for char in alphabet {
    charAlphabet.append(char)
}

for codeUnit in alphabet.utf8 {
    intAlphabet.append(codeUnit)
}

//let x: Character = alphabet[2]

5 >> 2

func encode_case0(x: Int) -> [Int] {
    return [Int(intAlphabet[(x >> 2)])]
}

func encode_case1(x: Int, y: Int) -> [Int] {
    return [Int(intAlphabet[((x & 3) << 4) | (y >> 4)])]
}

func encode_case2(x: Int, y: Int) -> [Int] {
    return [Int(intAlphabet[(x & 15) << 2 | y >> 6]), Int(intAlphabet[y & 63])]
}

encode_case0(104) + encode_case1(104, 97) + encode_case2(97, 116)

func encode64(input: String) -> String {
    var finish: [Character] = []
    var index = 0

    for codeUnit in input.utf8 {
        switch (index%3) {
        case 0:
            finish += encode_case0(codeUnit)
        case 1:
            finish += encode_case1(codeUnit)
        case 2:
            finish += encode_case0(Int(codeUnit))
        case _:
            encoding
        }
        finish.append(charAlphabet[encoding])
    }

    return String(finish)
}



encode64("hat")

"aGF0"
