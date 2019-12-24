(ns sudoku-solver.branches-test
  (:require [clojure.test :refer :all]
            [sudoku-solver.branches :as branches]
            [sudoku-solver.related-boxes :as related-boxes]))

(deftest generate-initial-branch-test
  (let [puzzle [1,   nil, nil, nil,
                nil, 4,   nil, nil,
                nil, nil, 3,   nil
                nil, nil, nil, nil]
        square-length 2
        expected-result {0 #{1}        1 #{1 2 3 4}  2 #{1 2 3 4}  3 #{1 2 3 4}
                         4 #{1 2 3 4}  5 #{4}        6 #{1 2 3 4}  7 #{1 2 3 4}
                         8 #{1 2 3 4}  9 #{1 2 3 4}  10 #{3}       11 #{1 2 3 4}
                         12 #{1 2 3 4} 13 #{1 2 3 4} 14 #{1 2 3 4} 15 #{1 2 3 4}}]
    (is (= (branches/generate-initial-branch puzzle square-length) expected-result))))

(deftest index-to-branch-from-test
  (let [current-branch {0 #{1 2 3} 1 #{1 2 3 4} 2 #{1 2} 3 #{1}}
        expected-result 2]
    (is (= (branches/index-to-branch-from current-branch) expected-result))))

(deftest generate-next-branch-test
  (let [current-branch {0 #{1 2 3} 1 #{1 2 3} 2 #{1 2} 3 #{4}}
        expected-result '({0 #{1 2 3} 1 #{1 2 3} 2 #{1} 3 #{4}}
                          {0 #{1 2 3} 1 #{1 2 3} 2 #{2} 3 #{4}})]
    (is (= (branches/generate-next-branch current-branch) expected-result))))

(deftest related-boxes-invalid-test
  (testing "when a box has no possible values"
    (let [related-boxes {0 #{} 4 #{1} 8 #{2 3 4} 12 #{2 3 4}}]
      (is (= (branches/related-boxes-invalid? related-boxes) true))))
  (testing "when known values are duplicated"
    (let [related-boxes {0 #{1} 1 #{1} 2 #{2 3 4} 3 #{2 3 4}}]
      (is (= (branches/related-boxes-invalid? related-boxes) true))))
  (testing "when all values are known"
    (let [related-boxes {2 #{1} 6 #{2} 10 #{3} 14 #{4}}]
      (is (= (branches/related-boxes-invalid? related-boxes) false))))
  (testing "when not all values are known but there are no duplicated known values"
    (let [related-boxes {0 #{1} 4 #{2} 8 #{3 4} 12 #{3 4}}]
      (is (= (branches/related-boxes-invalid? related-boxes) false)))))

(deftest branch-still-valid-test
  (let [related-box-indexes (apply concat (vals (related-boxes/calculate-related-box-indexes 2)))]
    (testing "when invalid"
      (let [branch {0 #{1}      1 #{2}    2 #{3 4}    3 #{3 4}
                    4 #{1}      5 #{3 4}  6 #{2 3 4}  7 #{2 3 4}
                    8 #{2 3 4}  9 #{3 4}  10 #{2 3 4} 11 #{2 3 4}
                    12 #{2 3 4} 13 #{3 4} 14 #{2 3 4} 15 #{2 3 4}}]
        (is (= (branches/branch-still-valid? branch related-box-indexes) false))))
    (testing "when the branch is solved"
      (let [branch {0 #{1}  1 #{2}  2 #{3}  3 #{4}
                    4 #{3}  5 #{4}  6 #{1}  7 #{2}
                    8 #{2}  9 #{1}  10 #{4} 11 #{3}
                    12 #{4} 13 #{3} 14 #{2} 15 #{1}}]
        (is (= (branches/branch-still-valid? branch related-box-indexes) true))))
    (testing "when the branch is not solved but valid"
      (let [branch {0 #{1}      1 #{2}    2 #{3 4}    3 #{3 4}
                    4 #{2 3 4}  5 #{3 4}  6 #{2 3 4}  7 #{2 3 4}
                    8 #{2 3 4}  9 #{3 4}  10 #{2 3 4} 11 #{2 3 4}
                    12 #{2 3 4} 13 #{3 4} 14 #{2 3 4} 15 #{2 3 4}}]
        (is (= (branches/branch-still-valid? branch related-box-indexes) true))))))

(deftest all-values-known-test
  (testing "when all boxes have one possible value"
    (let [branch {0 #{1}  1 #{2}  2 #{3}  3 #{4}
                  4 #{3}  5 #{4}  6 #{1}  7 #{2}
                  8 #{2}  9 #{1}  10 #{4} 11 #{3}
                  12 #{4} 13 #{3} 14 #{2} 15 #{1}}]
      (is (= (branches/all-values-known? branch) true))))
  (testing "when branch is not yet solved"
    (let [branch {0 #{1 2} 1 #{1 2} 2 #{3 4} 3 #{3 4}
                  4 #{3 4} 5 #{3 4} 6 #{1}   7 #{2}
                  8 #{2}   9 #{1}   10 #{4}  11 #{3}
                  12 #{4}  13 #{3}  14#{2}   15 #{1}}]
      (is (= (branches/all-values-known? branch) false)))))
