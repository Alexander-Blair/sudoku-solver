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
    const getNumberOfCandidates =
      () => this.puzzle.reduce((sum, box) => sum + box.length, 0);

    const relatedBoxesFilter = new RelatedBoxesFilter();

    let startingCandidates;

    while (startingCandidates !== getNumberOfCandidates()) {
      this.filterKnownValues();

      startingCandidates = getNumberOfCandidates();

      this.relatedBoxes.forEach((boxes) => {
        relatedBoxesFilter.removeRestrictedValues(boxes, 3);
        relatedBoxesFilter.removeRestrictedValues(boxes, 2);
      });
    }
  }

  /**
   * Runs the known values filter until we can't discover any new known values
   */
  filterKnownValues() {
    const relatedBoxesFilter = new RelatedBoxesFilter();
    let startingKnownValues;

    while (startingKnownValues !== this.getNumberOfKnownValues()) {
      startingKnownValues = this.getNumberOfKnownValues();

      this.relatedBoxes.forEach((boxes) => {
        relatedBoxesFilter.removeKnownValues(boxes);
      });
    }
  }

  /**
   * Calculates the number of boxes that already have only a single candidate
   * @return {number} the number of boxes that just one possible candidate
   */
  getNumberOfKnownValues() {
    return this.puzzle.reduce((sum, box) => {
      return box.length === 1 ? sum + 1 : sum;
    }, 0);
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
