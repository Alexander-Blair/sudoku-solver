/**
 * Validates the current state of a given puzzle
 */
class PuzzleValidator {
  /**
   * @param {array} puzzle the puzzle to validate
   * @param {number} squareLength the puzzle size
   * @param {object} relatedBoxIndices collection of indices connecting related
   * boxes
   */
  constructor(puzzle, squareLength, relatedBoxIndices) {
    this.puzzle = puzzle;
    this.squareLength = squareLength;
    this.relatedBoxIndices = relatedBoxIndices;
  }

  /**
   * Checks whether an incomplete or complete puzzle is still valid.
   * This includes checking for values duplicated in the same row /
   * column, or checking for boxes with zero possible values.
   * @return {boolean}
   */
  isValid() {
    const indicesValid = (indices) => {
      const knownValues = [];
      for (let i = 0; i < Math.pow(this.squareLength, 2); i++) {
        const box = this.puzzle[indices[i]];
        if (box.length === 1) knownValues.push(box[0]);
      }
      return knownValues.length === new Set(knownValues).size;
    };

    return this.puzzle.every((box) => box.length >= 1) &&
      this.relatedBoxIndices.every((indices) => indicesValid(indices));
  }

  /**
   * Checks whether a puzzle has one possible value in every box
   * @return {boolean}
   */
  allValuesKnown() {
    return this.puzzle.every((box) => box.length === 1);
  }
}

module.exports = PuzzleValidator;
