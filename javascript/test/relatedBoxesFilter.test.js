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
});
