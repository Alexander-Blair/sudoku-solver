const Branch = require('./branch.js');
const PuzzleValidator = require('./puzzleValidator.js');
const calculateRelatedBoxIndices = require('./calculateRelatedBoxIndices.js');
const generateInitialBranch = require('./generateInitialBranch.js');
const generateNextBranches = require('./generateNextBranches.js');

/**
 * Wraps a puzzle and attempts to solve the puzzle using logical rules. If
 * it gets to a point where it cannot logically remove candidates from any
 * more boxes, it will 'branch' off from the unsolved branch, and attempt
 * to solve, assuming one of the previously unknown values.
 */
class Puzzle {
  /**
   * @param {array} puzzle the initial puzzle (contains integers and nulls)
   * @param {number} squareLength the size of the puzzle
   */
  constructor(puzzle, squareLength) {
    this.puzzle = puzzle;
    this.squareLength = squareLength;
    this.relatedBoxIndices = this.flattenRelatedBoxIndices();
  }

  /**
   * Attempts to solve the puzzle
   * @return {array} the solution
   */
  solve() {
    const branches = [generateInitialBranch(this.puzzle, this.squareLength)];
    let branchNumber = 0;

    for (branchNumber; true; branchNumber++) {
      if (!branches[branchNumber]) throw new Error('Unable to solve puzzle');

      this.attemptBranch(branches[branchNumber]);

      const validator = this.getValidator(branches[branchNumber]);

      if (validator.isValid()) {
        if (validator.allValuesKnown()) break;

        branches.push(...generateNextBranches(branches[branchNumber]));
      }
    }
    return branches[branchNumber].map((box) => box[0]);
  }

  /**
   * Attempts to solve the current branch
   * @param {array} currentBranch the current branch
   * @return {void} the underlying data structure is mutated, so there is no
   *                return value
   */
  attemptBranch(currentBranch) {
    new Branch(
        currentBranch, this.squareLength, this.relatedBoxIndices,
    ).solve();
  }

  /**
   * Initializes a validator for the current branch
   * @param {array} currentBranch the current branch
   * @return {PuzzleValidator}
   */
  getValidator(currentBranch) {
    return new PuzzleValidator(
        currentBranch,
        this.squareLength,
        this.relatedBoxIndices,
    );
  }

  /**
   * Takes the related box indices, and converts them into a single level
   * array, since none of the filtering is different for each related box type
   * @return {array}
   */
  flattenRelatedBoxIndices() {
    const indices = calculateRelatedBoxIndices(this.squareLength);

    return [...indices.row, ...indices.column, ...indices.subSquare];
  }
}

module.exports = Puzzle;
