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
    var prev = 0
    var i = 0
    var mod = -1

    var result = 
      string.getBytes.map( char => {
        mod = i % 3
        val r = mod match {
            case 0 => encode_case0(char)
            case 1 => encode_case1(prev, char)
            case 2 => encode_case2(prev, char)
          }
        i += 1
        prev = char
        r
      }).toList

    result = result :+ (mod match {
        case 0 => List(alphabet.charAt((prev & 3) << 4), '=', '=')
        case 1 => List(alphabet.charAt((prev & 15) << 2), '=')
        case _ => List.empty
      })

    result.flatten.foldRight("")((x, acc) => x.toChar+acc)
  }

  def main(args: Array[String]) {

    println(encode_case0(104) == List('a'))
    println(encode_case1(104, 97) == List('G'))
    println(encode_case2(97, 116) == List('F', '0'))

    println(encode64(""))

    var the_string = "hat"
    println(the_string)
    println(encode64(the_string))
    //println(MyBase64.decode64(MyBase64.encode64(the_string)))

    println("")
    the_string = "chat"
    println(the_string)
    println(MyBase64.encode64(the_string))
    //println(MyBase64.decode64(MyBase64.encode64(the_string)))

    println("")
    the_string = "hatch"
    println(the_string)
    println(MyBase64.encode64(the_string))
    //println(MyBase64.decode64(MyBase64.encode64(the_string)))

    println("")
    the_string = "hatche"
    println(the_string)
    println(MyBase64.encode64(the_string))
    //println(MyBase64.decode64(MyBase64.encode64(the_string)))

  }
}
