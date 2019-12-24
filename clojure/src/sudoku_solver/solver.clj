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
          related-box-indexes))

(defn solve-branch
  [branch related-box-indexes]
  (let [calculate-total-possible-values #(reduce + (map count (vals %)))
        filtered-branch (apply-filters branch related-box-indexes)]
    (if (or (= (calculate-total-possible-values branch)
               (calculate-total-possible-values filtered-branch))
            (not (branches/branch-still-valid? filtered-branch related-box-indexes)))
      filtered-branch
      (solve-branch filtered-branch related-box-indexes))))

(defn solve-puzzle
  [branches current-branch-number related-box-indexes]
  (let [current-branch (get branches current-branch-number)
        branch-solution-attempt (solve-branch current-branch related-box-indexes)
        next-branch-number (+ current-branch-number 1)]
    (if-not (branches/branch-still-valid? branch-solution-attempt related-box-indexes)
      (if (> next-branch-number (count branches))
        (throw (Exception. "Puzzle cannot be solved"))
        (solve-puzzle branches next-branch-number related-box-indexes))
      (if (branches/all-values-known? branch-solution-attempt)
        branch-solution-attempt
        (solve-puzzle (into branches (branches/generate-next-branch branch-solution-attempt))
                      next-branch-number
                      related-box-indexes)))))

(defn run-solver
  [initial-puzzle square-length]
  (let [first-branch        (branches/generate-initial-branch initial-puzzle square-length)
        branches            [first-branch]
        related-box-indexes (apply concat (vals (related-boxes/calculate-related-box-indexes square-length)))]
    (->> (solve-puzzle branches 0 related-box-indexes)
         (into (sorted-map))
         (vals)
         (map first))))
