(ns sudoku-solver.branches)

(defn generate-initial-branch
  [puzzle square-length]
  (let [range-end (+ 1 (* square-length square-length))]
    (for [box-value puzzle]
      (if (nil? box-value)
        (into #{} (range 1 range-end))
        #{box-value}))))

(defn index-to-branch-from
  [current-branch]
  (->> current-branch
       (map-indexed (fn [index box-values] {:index index :box-values box-values}))
       (remove #(= (count (:box-values %)) 1))
       (apply min-key #(count (:box-values %)))
       (:index)))

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
    (some #(= (count %) 0) related-boxes)
    (->> related-boxes
         (filter #(= (count %) 1))
         (frequencies)
         (vals)
         (some #(> % 1))))))

(defn branch-still-valid?
  [branch related-box-indexes]
  (not-any? #(related-boxes-invalid? (vals (select-keys branch %)))
            (apply concat (vals related-box-indexes))))

(defn branch-solved?
  [branch related-box-indexes]
  (and
    (every? #(= (count %) 1) branch)
    (branch-still-valid? branch related-box-indexes)))
