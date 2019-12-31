const generateInitialBranch = require('../src/generateInitialBranch.js');

describe('when square length is 2', () => {
  let puzzle;

  beforeEach(() => {
    puzzle = [
      null, 1, null, null,
      2, null, null, null,
      null, null, 3, null,
      null, null, null, null,
    ];
  });

  test('it generates the initial branch', () => {
    expect(generateInitialBranch(puzzle, 2)).toEqual([
      [1, 2, 3, 4], [1], [1, 2, 3, 4], [1, 2, 3, 4],
      [2], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
      [1, 2, 3, 4], [1, 2, 3, 4], [3], [1, 2, 3, 4],
      [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4],
    ]);
  });
});

describe('when square length is 3', () => {
  let puzzle;

  beforeEach(() => {
    puzzle = [
      null, null, null, null, null, null, null, null, 1,
      null, 2, null, null, 8, 5, null, null, null,
      null, null, null, 3, null, null, 6, 2, 5,
      null, 7, null, null, 6, null, null, null, 9,
      null, 6, null, 1, null, 7, null, 5, null,
      8, null, null, null, 3, null, null, 1, null,
      6, 3, 7, null, null, 8, null, null, null,
      null, null, null, 2, 7, null, null, 4, null,
      5, null, null, null, null, null, null, null, null,
    ];
  });

  test('it generates the initial branch', () => {
    const all = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    expect(generateInitialBranch(puzzle, 3)).toEqual([
      all, all, all, all, all, all, all, all, [1],
      all, [2], all, all, [8], [5], all, all, all,
      all, all, all, [3], all, all, [6], [2], [5],
      all, [7], all, all, [6], all, all, all, [9],
      all, [6], all, [1], all, [7], all, [5], all,
      [8], all, all, all, [3], all, all, [1], all,
      [6], [3], [7], all, all, [8], all, all, all,
      all, all, all, [2], [7], all, all, [4], all,
      [5], all, all, all, all, all, all, all, all,
    ]);
  });
});
