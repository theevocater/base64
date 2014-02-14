(ns mybase64.main
  (:require [mybase64.core :refer :all]))

(defn check
  "check if equal"
  [f x y]
  (println \" (apply f x) \" " == " y "? " (= (apply f x) y)))

(defn -main
  [& args]
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

