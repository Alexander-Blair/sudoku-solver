const Puzzle = require('../src/puzzle.js');
const fs = require('fs');

[
  'puzzle_easy_0.json',
  'puzzle_medium_0.json',
  'puzzle_hard_0.json',
  'puzzle_hard_1.json',
  'puzzle_hard_2.json',
].forEach((filename) => {
  const fixture =
    JSON.parse(fs.readFileSync(`../support/fixtures/${filename}`, 'utf8'));

  describe(`when solving puzzle ${filename}`, () => {
    const puzzle = new Puzzle(fixture.puzzle, 3);

    test('it solves the puzzle', () => {
      expect(puzzle.solve()).toEqual(fixture.solution);
    });
  });
});
