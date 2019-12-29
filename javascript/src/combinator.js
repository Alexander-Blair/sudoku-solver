/**
 * Finds all combinations of elements within a given collection
 */
class Combinator {
  /**
   * @param {array} array the array from which to find combinations
   * @param {number} combinationSize the size of the combinations to search for
   */
  constructor(array, combinationSize) {
    this.array = array;
    this.combinationSize = combinationSize;
  }

  /**
   * Generates all combinations of a given size for a given array.
   *
   * For example, with an array of ['a', 'b', 'c', 'd'] and a combination
   * size of 3, you would expect to get back:
   * [['a', 'b', 'c'], ['a', 'b', 'd'], ['a', 'c', 'd'], ['b', 'c', 'd']]
   *
   * @return {array} returns an array of arrays containing all combinations
   */
  findCombinations() {
    const combinations = [];

    let indices;

    if (this.array.length < this.combinationSize) return [];

    while (indices = this.getNextIndices(indices)) {
      const newCombination = [];
      indices.forEach((i) => newCombination.push(this.array[i]));
      combinations.push(newCombination);
    }
    return combinations;
  }

  /**
   * Receives the indices used for the last combination and works out what
   * the next indices are.
   *
   * For example, where the array was of size 8, and the combination size
   * was 4, it would return
   * getNextIndices([0, 1, 2, 3]) => [0, 1, 2, 4]
   * getNextIndices([0, 1, 2, 7]) => [0, 1, 3, 4]
   * getNextIndices([0, 1, 6, 7]) => [0, 2, 3, 4]
   * getNextIndices([0, 5, 6, 7]) => [1, 2, 3, 4]
   * getNextIndices([4, 5, 6, 7]) => undefined
   *
   * @param {array} indices the indices used to generate the previous
   * combination
   * @return {?array} the next indices
   */
  getNextIndices(indices) {
    if (!indices) {
      return new Array(this.combinationSize).fill('').map((_, i) => i);
    }

    const columnNumberToIncrement = this.getColumnNumberToIncrement(indices);

    if (columnNumberToIncrement === undefined) return;

    this.recalculateIndices(indices, columnNumberToIncrement);

    return indices;
  }

  /**
   * When a column needs to be incremented, it usually means that the columns
   * following that one will have their indices reduced.
   *
   * For example if [0, 5, 6, 7] becomes [1, 2, 3, 4], the first column is
   * incremented, but then all the other columns have three subtracted.
   *
   * @param {array} indices the indices of the previous combination
   * @param {number} columnNumberToIncrement
   * @return {void} the indices are updated in place
   */
  recalculateIndices(indices, columnNumberToIncrement) {
    const deductionFromLaterIndices =
      columnNumberToIncrement + this.array.length -
      indices[columnNumberToIncrement] - this.combinationSize - 1;

    for (let i = columnNumberToIncrement + 1; i < this.combinationSize; i++) {
      indices[i] -= deductionFromLaterIndices;
    }
    indices[columnNumberToIncrement] += 1;
  }

  /**
   * Starting from the right, works out which column can be incremented
   * based on its current index
   *
   * @param {array} indices the current indices
   * @return {?number} the column to be incremented, if any
   */
  getColumnNumberToIncrement(indices) {
    for (let i = 0; i < this.combinationSize; i++) {
      const columnNumber = this.combinationSize - i - 1;
      const maxColumnValue = this.array.length - i - 1;

      if (indices[columnNumber] < maxColumnValue) return columnNumber;
    }
  }
}

module.exports = Combinator;
