(ns sudoku-solver.filters
  (:require [clojure.set :refer [difference union]]
            [clojure.math.combinatorics :refer [combinations]]))

(defn filter-boxes
  [related-boxes indexes-of-boxes-with-known-values]
  (let [boxes-with-known-values (select-keys related-boxes indexes-of-boxes-with-known-values)
        filter-fn #(difference % (apply union (vals boxes-with-known-values)))]
    (if (nil? indexes-of-boxes-with-known-values)
      related-boxes
      (reduce (fn [filtered-boxes [index boxes]]
                (if (some #(= index %) indexes-of-boxes-with-known-values)
                  filtered-boxes
                  (assoc filtered-boxes index (filter-fn boxes))))
              related-boxes
              related-boxes))))

(defn remove-known-values
  [related-boxes]
  (let [indexes-of-known-values (for [[index values] related-boxes
                                      :when (= 1 (count values))]
                                  index)]
    (filter-boxes related-boxes indexes-of-known-values)))

(defn- eligible-box-index-combinations-from
  [related-boxes number-of-restricted-values]
  (let [indexes (for [[index boxes] related-boxes
                      :when (> (count boxes) 1)]
                  index)]
    (combinations indexes number-of-restricted-values)))

(defn- is-restricted-combination?
  [indexes related-boxes number-of-restricted-values]
  (let [boxes (select-keys related-boxes indexes)]
    (= (count (apply union (vals boxes)))
       number-of-restricted-values)))

(defn remove-restricted-values
  [related-boxes number-of-restricted-values]
  (let [box-index-combinations (eligible-box-index-combinations-from related-boxes
                                                                     number-of-restricted-values)]
    (->> box-index-combinations
         (filter #(is-restricted-combination? % related-boxes number-of-restricted-values))
         (first)
         (filter-boxes related-boxes))))

(defn run-all-filters
  [related-boxes]
  (-> related-boxes
      (remove-known-values)
      (remove-restricted-values 2)))
