const Combinator = require('../src/combinator.js');

[
  {
    description: 'when combination size is greater than array size',
    combinationSize: 7,
    array: ['a', 'b', 'c', 'd', 'e', 'f'],
    expectedResult: [],
  },
  {
    description: 'when combination size equals array size',
    combinationSize: 6,
    array: ['a', 'b', 'c', 'd', 'e', 'f'],
    expectedResult: [['a', 'b', 'c', 'd', 'e', 'f']],
  },
  {
    description: 'when combination size is 2',
    combinationSize: 2,
    array: ['a', 'b', 'c', 'd', 'e', 'f'],
    expectedResult: [
      ['a', 'b'], ['a', 'c'], ['a', 'd'], ['a', 'e'], ['a', 'f'], ['b', 'c'],
      ['b', 'd'], ['b', 'e'], ['b', 'f'], ['c', 'd'], ['c', 'e'], ['c', 'f'],
      ['d', 'e'], ['d', 'f'], ['e', 'f'],
    ],
  },
  {
    description: 'when combination size is 3',
    combinationSize: 3,
    array: ['a', 'b', 'c', 'd', 'e', 'f'],
    expectedResult: [
      ['a', 'b', 'c'], ['a', 'b', 'd'], ['a', 'b', 'e'], ['a', 'b', 'f'],
      ['a', 'c', 'd'], ['a', 'c', 'e'], ['a', 'c', 'f'], ['a', 'd', 'e'],
      ['a', 'd', 'f'], ['a', 'e', 'f'], ['b', 'c', 'd'], ['b', 'c', 'e'],
      ['b', 'c', 'f'], ['b', 'd', 'e'], ['b', 'd', 'f'], ['b', 'e', 'f'],
      ['c', 'd', 'e'], ['c', 'd', 'f'], ['c', 'e', 'f'], ['d', 'e', 'f'],
    ],
  },
  {
    description: 'when combination size is 4',
    combinationSize: 4,
    array: ['a', 'b', 'c', 'd', 'e', 'f'],
    expectedResult: [
      ['a', 'b', 'c', 'd'], ['a', 'b', 'c', 'e'], ['a', 'b', 'c', 'f'],
      ['a', 'b', 'd', 'e'], ['a', 'b', 'd', 'f'], ['a', 'b', 'e', 'f'],
      ['a', 'c', 'd', 'e'], ['a', 'c', 'd', 'f'], ['a', 'c', 'e', 'f'],
      ['a', 'd', 'e', 'f'], ['b', 'c', 'd', 'e'], ['b', 'c', 'd', 'f'],
      ['b', 'c', 'e', 'f'], ['b', 'd', 'e', 'f'], ['c', 'd', 'e', 'f'],
    ],
  },
  {
    description: 'when combination size is 5',
    combinationSize: 5,
    array: ['a', 'b', 'c', 'd', 'e', 'f'],
    expectedResult: [
      ['a', 'b', 'c', 'd', 'e'], ['a', 'b', 'c', 'd', 'f'],
      ['a', 'b', 'c', 'e', 'f'], ['a', 'b', 'd', 'e', 'f'],
      ['a', 'c', 'd', 'e', 'f'], ['b', 'c', 'd', 'e', 'f'],
    ],
  },
].forEach((spec) => {
  describe(spec.description, () => {
    let combinator;

    beforeEach(() => {
      combinator = new Combinator(spec.array, spec.combinationSize);
    });

    test('it returns expected result', () => {
      expect(combinator.findCombinations()).toEqual(spec.expectedResult);
    });
  });
});
