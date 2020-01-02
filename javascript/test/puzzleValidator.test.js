const PuzzleValidator = require('../src/puzzleValidator.js');
const calculateRelatedBoxIndices =
  require('../src/calculateRelatedBoxIndices.js');

describe('PuzzleValidator', () => {
  let validator;
  const lengthTwoRelatedBoxIndices = calculateRelatedBoxIndices(2);
  const lengthThreeRelatedBoxIndices = calculateRelatedBoxIndices(3);

  describe('isValid', () => {
    let puzzle;

    describe('when values are duplicated in a row', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
            [3], [3], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it is not valid', () => {
          expect(validator.isValid()).toBe(false);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          const all = [1, 2, 3, 4, 5, 6, 7, 8, 9];
          puzzle = [
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            [2], all, all, all, all, [2], all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it is not valid', () => {
          expect(validator.isValid()).toBe(false);
        });
      });
    });

    describe('when values are duplicated in a column', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [1, 2, 3, 4], [1], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it is not valid', () => {
          expect(validator.isValid()).toBe(false);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          const all = [1, 2, 3, 4, 5, 6, 7, 8, 9];
          puzzle = [
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, [2], all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, [2], all, all, all,
            all, all, all, all, all, all, all, all, all,
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it is not valid', () => {
          expect(validator.isValid()).toBe(false);
        });
      });
    });

    describe('when values are duplicated in a sub square', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it is not valid', () => {
          expect(validator.isValid()).toBe(false);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          const all = [1, 2, 3, 4, 5, 6, 7, 8, 9];
          puzzle = [
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, [2],
            all, all, all, all, all, all, [2], all, all,
            all, all, all, all, all, all, all, all, all,
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it is not valid', () => {
          expect(validator.isValid()).toBe(false);
        });
      });
    });

    describe('when a box has no possible values', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [1, 2, 3, 4], [], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
            [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it is not valid', () => {
          expect(validator.isValid()).toBe(false);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          const all = [1, 2, 3, 4, 5, 6, 7, 8, 9];
          puzzle = [
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, [], all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
            all, all, all, all, all, all, all, all, all,
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it is not valid', () => {
          expect(validator.isValid()).toBe(false);
        });
      });
    });

    describe('when the puzzle is solved', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [1], [2], [3], [4],
            [3], [4], [1], [2],
            [2], [1], [4], [3],
            [4], [3], [2], [1],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it is valid', () => {
          expect(validator.isValid()).toBe(true);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          puzzle = [
            [1], [2], [3], [4], [5], [6], [7], [8], [9],
            [4], [5], [6], [7], [8], [9], [1], [2], [3],
            [7], [8], [9], [1], [2], [3], [4], [5], [6],
            [2], [3], [1], [5], [6], [4], [8], [9], [7],
            [5], [6], [4], [8], [9], [7], [2], [3], [1],
            [8], [9], [7], [2], [3], [1], [5], [6], [4],
            [3], [1], [2], [6], [4], [5], [9], [7], [8],
            [6], [4], [5], [9], [7], [8], [3], [1], [2],
            [9], [7], [8], [3], [1], [2], [6], [4], [5],
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it is valid', () => {
          expect(validator.isValid()).toBe(true);
        });
      });
    });

    describe('when the puzzle is valid but not yet solved', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [1, 2], [2], [3], [4],
            [3], [4], [1], [2],
            [1, 2], [1], [4], [3],
            [4], [3], [2], [1],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it is valid', () => {
          expect(validator.isValid()).toBe(true);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          puzzle = [
            [1, 2], [2], [3], [4], [5], [6], [7], [8], [9],
            [4], [5], [6], [7], [8], [9], [1], [2], [3],
            [7], [8], [9], [1], [2], [3], [4], [5], [6],
            [1, 2], [3], [1], [5], [6], [4], [8], [9], [7],
            [5], [6], [4], [8], [9], [7], [2], [3], [1],
            [8], [9], [7], [2], [3], [1], [5], [6], [4],
            [3], [1], [2], [6], [4], [5], [9], [7], [8],
            [6], [4], [5], [9], [7], [8], [3], [1], [2],
            [9], [7], [8], [3], [1], [2], [6], [4], [5],
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it is valid', () => {
          expect(validator.isValid()).toBe(true);
        });
      });
    });
  });

  describe('allValuesKnown', () => {
    describe('when a box contain zero values', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [], [2], [3], [4],
            [3], [4], [1], [2],
            [2], [1], [4], [3],
            [4], [3], [2], [1],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it returns false', () => {
          expect(validator.allValuesKnown()).toBe(false);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          puzzle = [
            [1], [2], [3], [4], [5], [6], [7], [8], [9],
            [4], [5], [6], [7], [8], [9], [1], [2], [3],
            [7], [8], [9], [1], [2], [3], [4], [5], [6],
            [1], [3], [1], [5], [6], [4], [8], [9], [7],
            [], [6], [4], [8], [9], [7], [2], [3], [1],
            [8], [9], [7], [2], [3], [1], [5], [6], [4],
            [3], [1], [2], [6], [4], [5], [9], [7], [8],
            [6], [4], [5], [9], [7], [8], [3], [1], [2],
            [9], [7], [8], [3], [1], [2], [6], [4], [5],
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it returns false', () => {
          expect(validator.allValuesKnown()).toBe(false);
        });
      });
    });

    describe('when all boxes contain one value', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [1], [2], [3], [4],
            [3], [4], [1], [2],
            [2], [1], [4], [3],
            [4], [3], [2], [1],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it returns true', () => {
          expect(validator.allValuesKnown()).toBe(true);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          puzzle = [
            [1], [2], [3], [4], [5], [6], [7], [8], [9],
            [4], [5], [6], [7], [8], [9], [1], [2], [3],
            [7], [8], [9], [1], [2], [3], [4], [5], [6],
            [1], [3], [1], [5], [6], [4], [8], [9], [7],
            [2], [6], [4], [8], [9], [7], [2], [3], [1],
            [8], [9], [7], [2], [3], [1], [5], [6], [4],
            [3], [1], [2], [6], [4], [5], [9], [7], [8],
            [6], [4], [5], [9], [7], [8], [3], [1], [2],
            [9], [7], [8], [3], [1], [2], [6], [4], [5],
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it returns true', () => {
          expect(validator.allValuesKnown()).toBe(true);
        });
      });
    });

    describe('when some boxes contain multiple values', () => {
      describe('for puzzle size 2', () => {
        beforeEach(() => {
          puzzle = [
            [1, 2], [2], [3], [4],
            [3], [4], [1], [2],
            [1, 2], [1], [4], [3],
            [4], [3], [2], [1],
          ];
          validator =
            new PuzzleValidator(puzzle, 2, lengthTwoRelatedBoxIndices);
        });

        test('it returns false', () => {
          expect(validator.allValuesKnown()).toBe(false);
        });
      });

      describe('for puzzle size 3', () => {
        beforeEach(() => {
          puzzle = [
            [1, 2], [2], [3], [4], [5], [6], [7], [8], [9],
            [4], [5], [6], [7], [8], [9], [1], [2], [3],
            [7], [8], [9], [1], [2], [3], [4], [5], [6],
            [1, 2], [3], [1], [5], [6], [4], [8], [9], [7],
            [5], [6], [4], [8], [9], [7], [2], [3], [1],
            [8], [9], [7], [2], [3], [1], [5], [6], [4],
            [3], [1], [2], [6], [4], [5], [9], [7], [8],
            [6], [4], [5], [9], [7], [8], [3], [1], [2],
            [9], [7], [8], [3], [1], [2], [6], [4], [5],
          ];
          validator =
            new PuzzleValidator(puzzle, 3, lengthThreeRelatedBoxIndices);
        });

        test('it returns false', () => {
          expect(validator.allValuesKnown()).toBe(false);
        });
      });
    });
  });
});
