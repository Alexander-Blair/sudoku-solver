const RelatedBoxesFilter = require('../src/relatedBoxesFilter.js');

describe('RelatedBoxesFilter', () => {
  let filter;

  beforeEach(() => {
    filter = new RelatedBoxesFilter;
  });

  describe('removeKnownValues', () => {
    let relatedBoxes;

    beforeEach(() => {
      relatedBoxes = [[1, 2, 3, 4], [2], [1, 3, 4, 5], [1, 2, 3, 4]];
    });

    test('it removes the known values from other boxes', () => {
      filter.removeKnownValues(relatedBoxes);

      expect(relatedBoxes).toEqual([[1, 3, 4], [2], [1, 3, 4, 5], [1, 3, 4]]);
    });
  });

  describe('removeRestrictedValues', () => {
    let relatedBoxes;
    let combinationSize;

    describe('when we are checking for box pairs', () => {
      beforeEach(() => {
        relatedBoxes = [[1, 2, 3, 4], [1, 2], [1, 2], [1, 3, 4, 5], [1, 2, 3]];
        combinationSize = 2;
      });

      test('it removes 1 and 2 from other boxes', () => {
        filter.removeRestrictedValues(relatedBoxes, combinationSize);

        expect(relatedBoxes).toEqual([[3, 4], [1, 2], [1, 2], [3, 4, 5], [3]]);
      });
    });

    describe('when there are no restricted values', () => {
      beforeEach(() => {
        relatedBoxes = [[2, 3, 4], [1, 2], [1, 2, 3], [1, 3, 4, 5], [1, 2, 3]];
        combinationSize = 2;
      });

      test('it makes no changes', () => {
        filter.removeRestrictedValues(relatedBoxes, combinationSize);

        expect(relatedBoxes).toEqual(
            [[2, 3, 4], [1, 2], [1, 2, 3], [1, 3, 4, 5], [1, 2, 3]],
        );
      });
    });

    describe('when we are checking for box triples', () => {
      beforeEach(() => {
        relatedBoxes = [
          [1, 2, 3, 4, 5, 6],
          [1, 2, 3],
          [1, 2, 3],
          [1, 3, 4, 5],
          [1, 2, 3],
          [4, 5, 6],
        ];
        combinationSize = 3;
      });

      test('it removes 1, 2 and 3 from other boxes', () => {
        filter.removeRestrictedValues(relatedBoxes, combinationSize);

        expect(relatedBoxes).toEqual([
          [4, 5, 6],
          [1, 2, 3],
          [1, 2, 3],
          [4, 5],
          [1, 2, 3],
          [4, 5, 6],
        ]);
      });
    });
  });
});
