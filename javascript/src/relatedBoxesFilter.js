const Combinator = require('./combinator.js');

/**
 * Takes a list of boxes and removes possible values based on a set of rules
 */
class RelatedBoxesFilter {
  /**
   * Removes values that we already know
   * @param {array} relatedBoxes boxes related by row, column or sub-square
   * @return {void}
   */
  removeKnownValues(relatedBoxes) {
    relatedBoxes
        .reduce((knownValues, box) => {
          if (box.length === 1) knownValues.push(box[0]);
          return knownValues;
        }, [])
        .forEach((knownValue) => {
          relatedBoxes.forEach((box) => {
            if (box.length === 1) return;
            const indexOfValue = box.indexOf(knownValue);
            if (indexOfValue >= 0) box.splice(indexOfValue, 1);
          });
        });
  }

  /**
   * Removes values that we can work out based on values restricted to certain
   * boxes
   *
   * i.e. if we had boxes [[1, 2], [1, 2], [1, 2, 3]], since values 1 and 2
   * must be in the first two boxes, it means that the third box cannot be 1
   * or 2 (so in this case we'd know it'd be 3)
   *
   * @param {array} relatedBoxes boxes related by row, column or sub-square
   * @param {number} combinationSize number of restricted values to
   * search for
   * @return {void}
   */
  removeRestrictedValues(relatedBoxes, combinationSize) {
    const eligibleBoxes =
      relatedBoxes.filter((b) => b.length > 1 && b.length <= combinationSize);

    const eligibleCombinations =
      new Combinator(eligibleBoxes, combinationSize).findCombinations();

    const restrictedCombination = eligibleCombinations.find((combination) => {
      return this.getDistinctValues(combination).length === combinationSize;
    });

    if (!restrictedCombination) return;

    relatedBoxes.forEach((box) => {
      if (box.length > 1 && !restrictedCombination.includes(box)) {
        this.getDistinctValues(restrictedCombination).forEach((v) => {
          const indexOfValue = box.indexOf(v);
          if (indexOfValue >= 0) box.splice(indexOfValue, 1);
        });
      }
    });
  }

  /**
   * Given a set of boxes, return the unique set of possible values
   * e.g. [[1, 2], [1, 2]] => [1, 2]
   * @param {array} boxes the boxes in which to find the values
   * @return {set} the distinct values
   */
  getDistinctValues(boxes) {
    const distinctValues = [];
    boxes.forEach((box) => {
      for (let i = 0; i < box.length; i++) {
        if (!distinctValues.includes(box[i])) distinctValues.push(box[i]);
      }
    });
    return distinctValues;
  }
}

module.exports = RelatedBoxesFilter;
