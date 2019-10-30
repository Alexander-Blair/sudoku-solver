(ns sudoku-solver.related-boxes)

(defn- board-length-from
  [square-length]
  (* square-length square-length))

(defn- calculate-row-indexes
  [square-length]
  (let [board-length (board-length-from square-length)]
    (for [row-number (range 0 board-length)]
      (into #{} (range (* row-number board-length)
                       (* (+ row-number 1) board-length))))))

(defn- calculate-column-indexes
  [square-length]
  (let [board-length (board-length-from square-length)]
    (for [column-number (range 0 board-length)]
      (->> (range 0 board-length)
           (map #(+ column-number
                    (* board-length %)))
           (into #{})))))

(defn- sub-square-start-index-of
  [sub-square-index row-offset square-length]
  (let [row-start-index (* (board-length-from square-length)
                           (+ sub-square-index
                              row-offset
                              (- (rem sub-square-index square-length))))
        horizontal-displacement (* square-length
                                   (rem sub-square-index square-length))]
    (+ horizontal-displacement row-start-index)))

(defn- calculate-sub-square-indexes
  [square-length]
  (let [board-length (board-length-from square-length)]
    (for [sub-square-number (range 0 board-length)]
      (->> (range 0 square-length)
           (map (fn [row-offset]
                  (let [starting-index-for-row (sub-square-start-index-of sub-square-number
                                                                          row-offset
                                                                          square-length)]
                    (range starting-index-for-row
                           (+ starting-index-for-row square-length)))))
           (flatten)
           (into #{})))))

(defn calculate-related-box-indexes
  [square-length]
  {:row (into [] (calculate-row-indexes square-length))
   :column (into [] (calculate-column-indexes square-length))
   :sub-square (into [] (calculate-sub-square-indexes square-length))})
