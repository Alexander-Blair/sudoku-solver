const generateNextBranches = require('../src/generateNextBranches.js');

describe('generateNextBranch', () => {
  describe('when there is a box with two possible values', () => {
    const currentBranch = [
      [1], [2, 3, 4], [2, 3, 4], [2, 3, 4],
      [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
      [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
      [3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
    ];

    test('it generates branches based off the fewest possible values', () => {
      expect(generateNextBranches(currentBranch)).toEqual([
        [
          [1], [2, 3, 4], [2, 3, 4], [2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [3], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        ],
        [
          [1], [2, 3, 4], [2, 3, 4], [2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        ],
      ]);
    });
  });

  describe('when there is a box with three possible values', () => {
    const currentBranch = [
      [1], [2, 3, 4], [2, 3, 4], [2, 3, 4],
      [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
      [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
      [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
    ];

    test('it generates branches based off the fewest possible values', () => {
      expect(generateNextBranches(currentBranch)).toEqual([
        [
          [1], [2], [2, 3, 4], [2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        ],
        [
          [1], [3], [2, 3, 4], [2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        ],
        [
          [1], [4], [2, 3, 4], [2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
          [2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
        ],
      ]);
    });
  });
});
