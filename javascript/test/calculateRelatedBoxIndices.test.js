const calculateRelatedBoxIndices =
  require('../src/calculateRelatedBoxIndices.js');

describe('calculateRelatedBoxIndices', () => {
  describe('when square length is 2', () => {
    const expectedResult = {
      row: [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15]],
      column: [[0, 4, 8, 12], [1, 5, 9, 13], [2, 6, 10, 14], [3, 7, 11, 15]],
      subSquare: [[0, 1, 4, 5], [2, 3, 6, 7], [8, 9, 12, 13], [10, 11, 14, 15]],
    };

    test('it calculates the indices correctly', () => {
      expect(calculateRelatedBoxIndices(2)).toEqual(expectedResult);
    });
  });

  describe('when square length is 3', () => {
    test('it calculates row 1 indices correctly', () => {
      expect(calculateRelatedBoxIndices(3).row[1]).toEqual(
          [9, 10, 11, 12, 13, 14, 15, 16, 17],
      );
    });

    test('it calculates column 4 indices correctly', () => {
      expect(calculateRelatedBoxIndices(3).column[4]).toEqual(
          [4, 13, 22, 31, 40, 49, 58, 67, 76],
      );
    });

    test('it calculates sub square 6 indices correctly', () => {
      expect(calculateRelatedBoxIndices(3).subSquare[6]).toEqual(
          [54, 55, 56, 63, 64, 65, 72, 73, 74],
      );
    });

    test('it calculates sub square 4 indices correctly', () => {
      expect(calculateRelatedBoxIndices(3).subSquare[4]).toEqual(
          [30, 31, 32, 39, 40, 41, 48, 49, 50],
      );
    });

    test('it calculates sub square 2 indices correctly', () => {
      expect(calculateRelatedBoxIndices(3).subSquare[2]).toEqual(
          [6, 7, 8, 15, 16, 17, 24, 25, 26],
      );
    });
  });
});
