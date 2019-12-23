(ns sudoku-solver.solver-test
  (:require [clojure.test :refer :all]
            [clojure.data.json :as json]
            [sudoku-solver.solver :as solver]))

(deftest run-solver-test
  (testing "it solves easy puzzle"
    (let [json-puzzle (slurp (str (System/getProperty "user.dir") "/../support/fixtures/puzzle_easy_0.json"))
          parsed-puzzle (get (json/read-str json-puzzle) "puzzle")
          square-length 3
          result (time (solver/run-solver parsed-puzzle square-length))
          expected-solution (get (json/read-str json-puzzle) "solution")]
      (is (= result expected-solution))))
  (testing "it solves medium puzzle"
    (let [json-puzzle (slurp (str (System/getProperty "user.dir") "/../support/fixtures/puzzle_medium_0.json"))
          parsed-puzzle (get (json/read-str json-puzzle) "puzzle")
          square-length 3
          result (time (solver/run-solver parsed-puzzle square-length))
          expected-solution (get (json/read-str json-puzzle) "solution")]
      (is (= result expected-solution))))
  (testing "it solves hard puzzle"
    (let [json-puzzle (slurp (str (System/getProperty "user.dir") "/../support/fixtures/puzzle_hard_0.json"))
          parsed-puzzle (get (json/read-str json-puzzle) "puzzle")
          square-length 3
          result (time (solver/run-solver parsed-puzzle square-length))
          expected-solution (get (json/read-str json-puzzle) "solution")]
      (is (= result expected-solution))))
  (testing "it solves really hard puzzle"
    (let [json-puzzle (slurp (str (System/getProperty "user.dir") "/../support/fixtures/puzzle_hard_2.json"))
          parsed-puzzle (get (json/read-str json-puzzle) "puzzle")
          square-length 3
          result (time (solver/run-solver parsed-puzzle square-length))
          expected-solution (get (json/read-str json-puzzle) "solution")]
      (is (= result expected-solution)))))
