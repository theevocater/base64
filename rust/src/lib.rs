// this is kind of a gross hack to get a static vector of characters
//
// probably a better way
static alphabetVec: &'static [char] = &['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '='];

fn encode_case0(x: u8) -> char {
    // im not really sure what the right answer is to this. i could 0 it but eh? in other languages
    // I don't have to line up u8 / uint or i can just throw and exception...
    return alphabetVec[(x >> 2).to_uint().unwrap()];
}

fn encode_case1(x: u8, y: u8) -> char {
    return alphabetVec[(((x & 3) << 4) | (y >> 4)).to_uint().unwrap()];
}

fn encode_case2(x: u8, y: u8) -> char  {
    return alphabetVec[(((x & 15) << 2) | (y >> 6)).to_uint().unwrap()];
}

fn encode_case3(x: u8) -> char  {
    return alphabetVec[(x & 63).to_uint().unwrap()];
}

fn encode64(input_str: &str) -> String {
    let mut output_string = String::new();
    let vec_bytes: Vec<u8> = input_str.bytes().collect();
    // I still don't understand why this is mut. does the for destroy it?
    let mut chunked_bytes = vec_bytes.as_slice().chunks(3);

    // if i don't do this weird extra block the borrow checker seems to not
    // see the 'push_chars' go out of scope and thinks I'm borrowing
    // output_string outside of the function
    {
        // this isn't super necessary but it looks nice i guess
        let push_chars = |a: char, b: char, c: char, d: char| {
            output_string.push_char(a);
            output_string.push_char(b);
            output_string.push_char(c);
            output_string.push_char(d);
        };
        for bytes in chunked_bytes {
            match bytes {
                [x, y, z] => {
                    push_chars(encode_case0(x),
                               encode_case1(x,y),
                               encode_case2(y,z),
                               encode_case3(z));
                }
                [x, y] => {
                    push_chars(encode_case0(x),
                               encode_case1(x,y),
                               alphabetVec[((y & 15) << 2).to_uint().unwrap()],
                               '=');
                }
                [x] => {
                    push_chars(encode_case0(x),
                               alphabetVec[((x & 3) << 4).to_uint().unwrap()],
                               '=',
                               '=');
                }
                _ => {}
            }

        }
    }
    return output_string;
}

#[test]
fn encode_case0_test() {
    assert_eq!(encode_case0(104), 'a');
}

#[test]
fn encode_case1_test() {
    assert_eq!(encode_case1(104, 97), 'G');
}

#[test]
fn encode_case2_test() {
    assert_eq!(encode_case2(97, 116), 'F');
}

#[test]
fn encode_case3_test() {
    assert_eq!(encode_case3(116), '0');
}

#[test]
fn encode64_test() {
    assert_eq!(encode64("h").as_slice(), "aA==");
    assert_eq!(encode64("ha").as_slice(), "aGE=");
    assert_eq!(encode64("hat").as_slice(), "aGF0");
    assert_eq!(encode64("hatch").as_slice(), "aGF0Y2g=");
    assert_eq!(encode64("hatche").as_slice(), "aGF0Y2hl");
    assert_eq!(encode64("").as_slice(), "");
}
