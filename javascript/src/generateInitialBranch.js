const generateInitialBranch = (puzzle, squareLength) => {
  return puzzle.map((boxValue) => {
    if (!boxValue) {
      const possibleValues = [];
      for (i = 1; i <= squareLength * squareLength; i++) possibleValues.push(i);
      return possibleValues;
    } else return [boxValue];
  });
};

module.exports = generateInitialBranch;
