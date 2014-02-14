(ns mybase64.core)
(use '[clojure.core.match :only (match)])
(use '[clojure.string :only (join)])

(def ^:const alphabet "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=")

(defn encode_case0
  "encode the first 6 bytes"
  [x]
  [(.charAt alphabet (bit-shift-right x 2))])

(defn encode_case1
  "encode the second 6 bytes"
  [x y]
  [(.charAt alphabet (bit-or (bit-shift-left (bit-and x 3) 4) (bit-shift-right y 4)))])

(defn encode_case2
  "encode the last 12 bytes"
  [x y]
  [(.charAt alphabet (bit-or (bit-shift-left (bit-and x 15) 2) (bit-shift-right y 6)))
   (.charAt alphabet (bit-and y 63))])

(defn encode64
  "encode string into base64"
  [string]
  (join (flatten (map
    #(match [%]
            [([a b c] :seq)] (concat (encode_case0 a) (encode_case1 a b) (encode_case2 b c))
            [([a b] :seq)]  (concat (encode_case0 a) (encode_case1 a b) [(.charAt alphabet (bit-shift-left (bit-and b 15) 2)) \=])
            [([a] :seq)] (concat (encode_case0 a) [(.charAt alphabet (bit-shift-left (bit-and a 3) 4)) \= \=])
            :else nil)
    (partition-all 3 (.getBytes string))))))

(defn get_index
  "get the index into alphabet for a char"
  [x]
  (.indexOf alphabet (int x)))

(defn decode_case0
  "decode the first 8 bytes"
  [x y]
  [(char (bit-or (bit-shift-left (get_index x) 2) (bit-shift-right (get_index y) 4)))])

(defn decode_case1
  "decode the second 8 bytes"
  [x y]
  [(char (bit-or (bit-shift-left (bit-and (get_index x) 15) 4) (bit-shift-right (get_index y) 2)))])

(defn decode_case2
  "decode the third 8 bytes"
  [x y]
  [(char (bit-or (bit-shift-left (bit-and (get_index x) 3) 6) (get_index y)))])

(defn decode64
  "decode string from base64"
  [string]
  (join (flatten (map 
    #(match [%]
            [([a b c d] :seq)] (concat (decode_case0 a b) (decode_case1 b c) (decode_case2 c d))
            [([a b c] :seq)] (concat (decode_case0 a b) (decode_case1 b c))
            [([a b] :seq)] (decode_case0 a b)
            :else nil)
     (partition-all 4 (filter #((complement =) % \=) (.toCharArray string)))))))

(defn check
  "check if equal"
  [f x y]
  (println \" (apply f x) \" " == " y "? " (= (apply f x) y)))

(defn -main
  [& args]
  (check encode_case0 '(104) '(\a))
  (check encode_case0 '(104) '(\a))
  (check encode_case1 '(104 97) '(\G))
  (check encode_case2 '(97 116) '(\F \0))
  (check encode64 '("h") "aA==")
  (check encode64 '("ha") "aGE=")
  (check encode64 '("hat") "aGF0")
  (check encode64 '("hatch") "aGF0Y2g=")
  (check encode64 '("hatche") "aGF0Y2hl")
  (check encode64 '("") "")
  (check decode_case0 '(\a \G) '(\h))
  (check decode_case1 '(\G \F) '(\a))
  (check decode_case2 '(\F \0) '(\t))
  (check decode64 '("aA==") "h")
  (check decode64 '("aGE=") "ha")
  (check decode64 '("aGF0") "hat")
  (check decode64 '("aGF0Y2g=") "hatch")
  (check decode64 '("aGF0Y2hl") "hatche"))

