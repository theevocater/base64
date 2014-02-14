(ns mybase64.core-test
  (:require [clojure.test :refer :all]
            [mybase64.core :refer :all]))

(deftest encoding
  (testing "Encoding"
    (testing "case functions"
      (is (= (encode_case0 104) '(\a)))
      (is (= (encode_case1 104 97) '(\G)))
      (is (= (encode_case2 97 116) '(\F \0)))
    )
    (testing "encode64"
      (is (= (encode64 "h")) "aA==")
      (is (= (encode64 "ha")) "aGE=")
      (is (= (encode64 "hat")) "aGF0")
      (is (= (encode64 "hatch")) "aGF0Y2g=")
      (is (= (encode64 "hatche")) "aGF0Y2hl")
      (is (= (encode64 "") ""))
    )
  )
)

(deftest decoding 
  (testing "Decoding"
    (testing "case functions"
      (is (= (decode_case0 \a \G)) '(\h))
      (is (= (decode_case1 \G \F)) '(\a))
      (is (= (decode_case2 \F \0)) '(\t))
    )
    (testing "decode64"
      (is (= (decode64 "aA==")) "h")
      (is (= (decode64 "aGE=")) "ha")
      (is (= (decode64 "aGF0")) "hat")
      (is (= (decode64 "aGF0Y2g=")) "hatch")
      (is (= (decode64 "aGF0Y2hl")) "hatche")
      (is (= (decode64 "") ""))
    )
  )
)
