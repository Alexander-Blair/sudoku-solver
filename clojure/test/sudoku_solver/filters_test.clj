(ns sudoku-solver.filters-test
  (:require [clojure.test :refer :all]
            [sudoku-solver.filters :as filters]))

(deftest remove-known-values-test
  (let [related-boxes {0 #{1}
                       1 #{1 2 3 4}
                       2 #{4}
                       3 #{1 2 3 4}}
        expected-result {0 #{1}
                         1 #{2 3}
                         2 #{4}
                         3 #{2 3}}]
    (is (= (filters/remove-known-values related-boxes) expected-result))))

(deftest remove-restricted-values-test
  (testing "when number of values is 2"
    (testing "and there are no values to filter out"
      (let [related-boxes {0 #{1 2} 4 #{1 2 3} 8 #{1 2 3 4} 12 #{1 2 3 4 5}}]
        (is (= (filters/remove-restricted-values related-boxes 2) related-boxes))))
    (testing "and there are values to filter out"
      (let [related-boxes {0 #{1 2} 4 #{1 2} 8 #{1 2 3 4}}
            expected-result {0 #{1 2} 4 #{1 2} 8 #{3 4}}]
        (is (= (filters/remove-restricted-values related-boxes 2) expected-result)))))
  (testing "when number of values is 3"
    (testing "and there are no values to filter out"
      (let [related-boxes {2 #{1 2 3} 6 #{1 2 4} 10 #{1 3} 14 #{1 2 3 4 5}}]
        (is (= (filters/remove-restricted-values related-boxes 3) related-boxes))))
    (testing "and there are three boxes, all containing the three restricted values"
      (let [related-boxes {2 #{1 2 3} 6 #{1 2 3} 10 #{1 2 3} 14 #{1 2 3 4 5}}
            expected-result {2 #{1 2 3} 6 #{1 2 3} 10 #{1 2 3} 14 #{4 5}}]
        (is (= (filters/remove-restricted-values related-boxes 3) expected-result))))
    (testing "and there are three boxes, together containing three restricted values"
      (let [related-boxes {0 #{1 2} 4 #{1 3} 8 #{2 3} 12 #{1 2 3 4 5}}
            expected-result {0 #{1 2} 4 #{1 3} 8 #{2 3} 12 #{4 5}}]
        (is (= (filters/remove-restricted-values related-boxes 3) expected-result))))))
