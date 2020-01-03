const RelatedBoxesFilter = require('./relatedBoxesFilter.js');
/**
 * Wraps the current branch we are attempting to solve
 */
class Branch {
  /**
   * @param {array} puzzle the initial state of the puzzle
   * @param {number} squareLength the puzzle size
   *   (the board length is squareLength squared)
   * @param {object} relatedBoxIndices contains indices of boxes that are
   *   related by row, column, or sub square
   */
  constructor(puzzle, squareLength, relatedBoxIndices) {
    this.puzzle = puzzle;
    this.squareLength = squareLength;
    this.relatedBoxIndices = relatedBoxIndices;

    this.relatedBoxes = this.getRelatedBoxes();
  }

  /**
   * Continuously runs the filters to remove candidates until no more can be
   * removed.
   * @return {void} All changes are done via mutations, so the execution simply
   *                terminates once no further changes can be made
   */
  solve() {
    const getNumberOfPossibilities =
      () => this.puzzle.reduce((sum, box) => sum + box.length, 0);

    const startingPossibilities = getNumberOfPossibilities();
    this.runFilters();
    const endingPossibilities = getNumberOfPossibilities();

    if (startingPossibilities !== endingPossibilities) this.solve();
  }

  /**
   * Run all the filters on related boxes to remove candidates from each box.
   * Note that the array of values is mutated in place.
   */
  runFilters() {
    const relatedBoxesFilter = new RelatedBoxesFilter();

    this.relatedBoxes.forEach((boxes) => {
      relatedBoxesFilter.removeKnownValues(boxes);
      relatedBoxesFilter.removeRestrictedValues(boxes, 3);
      relatedBoxesFilter.removeRestrictedValues(boxes, 2);
    });
  }

  /**
   * Uses the related box indices to create a single level array of all the
   * related boxes that need to be filtered one after another.
   * Since we are mutating the boxes when solving a given branch, we can
   * memoize the references so that we don't need to recreate this collection
   * multiple times.
   *
   * @return {array}
   */
  getRelatedBoxes() {
    const relatedBoxes = [];

    this.relatedBoxIndices.forEach((indices) => {
      const boxesForIndices = [];
      for (let i = 0; i < Math.pow(this.squareLength, 2); i++) {
        boxesForIndices.push(this.puzzle[indices[i]]);
      }
      relatedBoxes.push(boxesForIndices);
    });
    return relatedBoxes;
  }
}

module.exports = Branch;
