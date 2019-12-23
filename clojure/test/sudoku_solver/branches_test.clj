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

(deftest related-boxes-invalid-test
  (testing "when a box has no possible values"
    (let [related-boxes [#{} #{1} #{2 3 4} #{2 3 4}]]
      (is (= (branches/related-boxes-invalid? related-boxes) true))))
  (testing "when known values are duplicated"
    (let [related-boxes [#{1} #{1} #{2 3 4} #{2 3 4}]]
      (is (= (branches/related-boxes-invalid? related-boxes) true))))
  (testing "when all values are known"
    (let [related-boxes [#{1} #{2} #{3} #{4}]]
      (is (= (branches/related-boxes-invalid? related-boxes) false))))
  (testing "when not all values are known but there are no duplicated known values"
    (let [related-boxes [#{1} #{2} #{3 4} #{3 4}]]
      (is (= (branches/related-boxes-invalid? related-boxes) false)))))

(deftest branch-still-valid-test
  (let [related-box-indexes (related-boxes/calculate-related-box-indexes 2)]
    (testing "when invalid"
      (let [branch [#{1}     #{2}   #{3 4}   #{3 4}
                    #{1}     #{3 4} #{2 3 4} #{2 3 4}
                    #{2 3 4} #{3 4} #{2 3 4} #{2 3 4}
                    #{2 3 4} #{3 4} #{2 3 4} #{2 3 4}]]
        (is (= (branches/branch-still-valid? branch related-box-indexes) false))))
    (testing "when the branch is solved"
      (let [branch [#{1} #{2} #{3} #{4}
                    #{3} #{4} #{1} #{2}
                    #{2} #{1} #{4} #{3}
                    #{4} #{3} #{2} #{1}]]
        (is (= (branches/branch-still-valid? branch related-box-indexes) true))))
    (testing "when the branch is not solved but valid"
      (let [branch [#{1}     #{2}   #{3 4}   #{3 4}
                    #{2 3 4} #{3 4} #{2 3 4} #{2 3 4}
                    #{2 3 4} #{3 4} #{2 3 4} #{2 3 4}
                    #{2 3 4} #{3 4} #{2 3 4} #{2 3 4}]]
        (is (= (branches/branch-still-valid? branch related-box-indexes) true))))))

(deftest branch-solved-test
  (let [related-box-indexes (related-boxes/calculate-related-box-indexes 2)]
    (testing "when branch is solved"
      (let [branch [#{1} #{2} #{3} #{4}
                    #{3} #{4} #{1} #{2}
                    #{2} #{1} #{4} #{3}
                    #{4} #{3} #{2} #{1}]]
        (is (= (branches/branch-solved? branch related-box-indexes) true))))
    (testing "when branch is not solved"
      (let [branch [#{1 2} #{1 2} #{3 4} #{3 4}
                    #{3 4} #{3 4} #{1} #{2}
                    #{2} #{1} #{4} #{3}
                    #{4} #{3} #{2} #{1}]]
        (is (= (branches/branch-solved? branch related-box-indexes) false))))))