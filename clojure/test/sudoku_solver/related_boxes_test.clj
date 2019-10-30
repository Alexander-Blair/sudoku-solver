(ns sudoku-solver.related-boxes-test
  (:require [clojure.test :refer :all]
            [sudoku-solver.related-boxes :as related-boxes]))

(deftest calculate-row-indexes-test
  (testing "when square length is 2"
    (let [square-length 2
          expected-result {:row [#{0 1 2 3}
                                 #{4 5 6 7}
                                 #{8 9 10 11}
                                 #{12 13 14 15}]
                           :column [#{0 4 8 12}
                                    #{1 5 9 13}
                                    #{2 6 10 14}
                                    #{3 7 11 15}]
                           :sub-square [#{0 1 4 5}
                                        #{2 3 6 7}
                                        #{8 9 12 13}
                                        #{10 11 14 15}]}]
      (is (= (related-boxes/calculate-related-box-indexes square-length) expected-result))))
  (testing "when square length is 3"
    (let [indexes (related-boxes/calculate-related-box-indexes 3)]
      (is (= (get (:row indexes) 1) #{9 10 11 12 13 14 15 16 17}))
      (is (= (get (:column indexes) 4) #{4 13 22 31 40 49 58 67 76}))
      (is (= (get (:sub-square indexes) 6) #{54 55 56 63 64 65 72 73 74}))
      (is (= (get (:sub-square indexes) 4) #{30 31 32 39 40 41 48 49 50}))
      (is (= (get (:sub-square indexes) 2) #{6 7 8 15 16 17 24 25 26})))))
