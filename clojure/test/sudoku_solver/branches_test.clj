(ns sudoku-solver.branches-test
  (:require [clojure.test :refer :all]
            [sudoku-solver.branches :as branches]))

(deftest generate-initial-branch-test
  (let [puzzle [1,   nil, nil, nil,
                nil, 4,   nil, nil,
                nil, nil, 3,   nil
                nil, nil, nil, nil]
        square-length 2
        expected-result [#{1}, #{1 2 3 4} #{1 2 3 4} #{1 2 3 4}
                         #{1 2 3 4} #{4} #{1 2 3 4} #{1 2 3 4}
                         #{1 2 3 4} #{1 2 3 4} #{3} #{1 2 3 4}
                         #{1 2 3 4} #{1 2 3 4} #{1 2 3 4} #{1 2 3 4}]]
    (is (= (branches/generate-initial-branch puzzle square-length) expected-result))))

(deftest index-to-branch-from-test
  (let [current-branch [#{1 2 3} #{1 2 3 4} #{1 2} #{1}]
        expected-result 2]
    (is (= (branches/index-to-branch-from current-branch) expected-result))))

(deftest generate-next-branch-test
  (let [current-branch [#{1 2 3} #{1 2 3} #{1 2} #{4}]
        expected-result '([#{1 2 3} #{1 2 3} #{1} #{4}]
                          [#{1 2 3} #{1 2 3} #{2} #{4}])]
    (is (= (branches/generate-next-branch current-branch) expected-result))))
