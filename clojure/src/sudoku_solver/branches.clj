(ns sudoku-solver.branches)

(defn generate-initial-branch
  [puzzle square-length]
  (let [range-end (+ 1 (* square-length square-length))]
    (->> puzzle
         (map-indexed (fn [index box] [index box]))
         (reduce (fn [branch [index box]]
                   (let [possible-values (if (nil? box)
                                           (into #{} (range 1 range-end))
                                           #{box})]
                     (assoc branch index possible-values)))
                 {}))))

(defn index-to-branch-from
  [current-branch]
  (->> current-branch
       (remove (fn [[i possible-box-values]] (= (count possible-box-values) 1)))
       (apply min-key (fn [[i possible-box-values]] (count possible-box-values)))
       (first)))

(defn generate-next-branch
  [current-branch]
  (let [box-index (index-to-branch-from current-branch)
        box-values-at-index (get current-branch box-index)]
    (for [possible-value box-values-at-index]
      (assoc current-branch box-index #{possible-value}))))

(defn related-boxes-invalid?
  [related-boxes]
  (some?
    (or
      (some #(= (count %) 0) (vals related-boxes))
      (->> related-boxes
           (vals)
           (filter #(= (count %) 1))
           (frequencies)
           (vals)
           (some #(> % 1))))))

(defn branch-still-valid?
  [branch related-box-indexes]
  (not-any? #(related-boxes-invalid? (select-keys branch %))
            related-box-indexes))

(defn all-values-known?
  [branch]
  (every? #(= (count %) 1) (vals branch)))
