object MyBase64 {
  private val alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="

  private def encode_case0(x: Int): List[Char] =
    List(alphabet.charAt(x >> 2))

  private def encode_case1(x: Int, y: Int): List[Char] =
    List(alphabet.charAt(((x & 3) << 4) | (y >> 4)))

  private def encode_case2(x: Int, y: Int): List[Char] =
    List(alphabet.charAt((x & 15) << 2 | y >> 6), alphabet.charAt(y & 63))

  //AAAAAAAA-BBBBBBBB-CCCCCCCC
  //AAAAAA-AABBBB-BBBBCC-CCCCCC
  def encode64(string: String): String = {
    string.getBytes.grouped(3).map( ints => {
      ints.toList match {
        case a :: b :: c :: Nil => {
          encode_case0(a) ++
            encode_case1(a, b) ++ encode_case2(b, c)
        }
        case a :: b :: Nil => {
          encode_case0(a) ++
            encode_case1(a, b) ++ List(alphabet.charAt((b & 15) << 2), '=')
        }
        case a :: Nil => {
          encode_case0(a) ++ List(alphabet.charAt((a & 3) << 4), '=', '=')
        }
        case _ => {
          throw new RuntimeException("uh")
        }
      }
    }).toList.flatten.foldRight("")((x, acc) => x.toChar+acc)
  }

  def decode_case0(x: Int, y: Int): List[Char] = {
    check_params_decode(x, y)
    List((x << 2 | y >> 4).toChar)
  }

  // TODO(jake) this is wrong
  def decode_case1(x: Int, y: Int): List[Char] = {
    check_params_decode(x, y)
    List(((x & 15) << 4 | y >> 2).toChar)
  }

  // TODO(jake) I am least happy about how this worked out
  def decode_case2(x: Int, y: Int): List[Char] = {
    check_params_decode(x, y)
    if (x == alphabet.length - 1)
      List.empty
    else if (y == alphabet.length - 1)
      List(((x & 3) << 6).toChar)
    else
      List(((x & 3) << 6 | y).toChar)
  }

  def check_params_decode(x: Int, y: Int) {
    if (!((x >= 0 && x < alphabet.length) && (y >= 0 && y < alphabet.length)))
      throw new RuntimeException("Bad parameters + " + List(x, y))
  }

  // AAAAAA-BBBBBB-CCCCCC-DDDDDD
  // AAAAAABB-BBBBCCCC-CCDDDDDD
  def decode64(string: String): String = {
    if (string.length % 4 != 0)
      throw new RuntimeException("Not a valid base64 string")

    // TODO(jake) maybe change the order of the mapping here
    string.grouped(4).map( chars => {
      chars.toList.map(alphabet.indexOf(_)) match {
        case a :: b :: c :: d :: Nil => {
          decode_case0(a, b) ++ decode_case1(b, c) ++ decode_case2(c, d)
        }
        case _ => {
          throw new RuntimeException("uh")
        }
      }
    }).toList.flatten.foldRight("")((x, acc) => x.toChar+acc)
  }

  def main(args: Array[String]) {

    println(encode_case0(104) == List('a'))
    println(encode_case1(104, 97) == List('G'))
    println(encode_case2(97, 116) == List('F', '0'))

    println(decode_case0(26, 6) == List('h'))
    println(decode_case1(6, 5) == List('a'))
    println(decode_case2(5, 52) == List('t'))

    println(encode64(""))

    println(MyBase64.decode64(""))

    var the_string = "hat"
    println(the_string)
    println(encode64(the_string))
    println(MyBase64.decode64(MyBase64.encode64(the_string)))

    println("")
    the_string = "chat"
    println(the_string)
    println(MyBase64.encode64(the_string))
    println(MyBase64.decode64(MyBase64.encode64(the_string)))

    println("")
    the_string = "hatch"
    println(the_string)
    println(MyBase64.encode64(the_string))
    println(MyBase64.decode64(MyBase64.encode64(the_string)))

    println("")
    the_string = "hatche"
    println(the_string)
    println(MyBase64.encode64(the_string))
    println(MyBase64.decode64(MyBase64.encode64(the_string)))

  }
}
