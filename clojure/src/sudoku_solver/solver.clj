(ns sudoku-solver.solver
  (:require [sudoku-solver.related-boxes :as related-boxes]
            [sudoku-solver.branches :as branches]
            [sudoku-solver.filters :as filters]))

(defn apply-filters
  [branch related-box-indexes]
  (reduce (fn [filtered-branch indexes]
            (merge filtered-branch
                   (filters/run-all-filters (select-keys filtered-branch indexes))))
          branch
          (apply concat (vals related-box-indexes))))

(defn solve-branch
  [branch related-box-indexes]
  (let [calculate-total-possible-values #(reduce + (map count (vals %)))
        filtered-branch (apply-filters branch related-box-indexes)]
    (if (= (calculate-total-possible-values branch)
           (calculate-total-possible-values filtered-branch))
      filtered-branch
      (solve-branch filtered-branch related-box-indexes))))

(defn solve-puzzle
  [branches branch-number related-box-indexes]
  (let [current-branch (get branches branch-number)
        branch-solution-attempt (solve-branch current-branch related-box-indexes)]
    (if-not (branches/branch-still-valid? branch-solution-attempt related-box-indexes)
      (if (nil? (get branches (+ branch-number 1)))
        (throw (Exception. "Puzzle cannot be solved"))
        (solve-puzzle branches (+ branch-number 1) related-box-indexes))
      (if (branches/all-values-known? branch-solution-attempt)
        branch-solution-attempt
        (solve-puzzle (into branches (branches/generate-next-branch branch-solution-attempt))
                      (+ branch-number 1)
                      related-box-indexes)))))

(defn run-solver
  [initial-puzzle square-length]
  (let [first-branch        (branches/generate-initial-branch initial-puzzle square-length)
        branches            [first-branch]
        related-box-indexes (related-boxes/calculate-related-box-indexes square-length)]
    (->> (solve-puzzle branches 0 related-box-indexes)
         (into (sorted-map))
         (vals)
         (map first))))
