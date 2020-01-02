const calculateRelatedBoxIndices = (squareLength) => {
  const boardLength = Math.pow(squareLength, 2);

  const calculateRowIndices = (rowNumber) => {
    const indices = [];
    for (let columnNumber = 0; columnNumber < boardLength; columnNumber++) {
      indices.push(boardLength * rowNumber + columnNumber);
    }
    return indices;
  };

  const calculateColumnIndices = (columnNumber) => {
    const indices = [];
    for (let rowNumber = 0; rowNumber < boardLength; rowNumber++) {
      indices.push(boardLength * rowNumber + columnNumber);
    }
    return indices;
  };

  const subSquareStartIndex = (subSquareIndex, lineOffset) => {
    return (subSquareIndex - (subSquareIndex % squareLength) + lineOffset) *
      boardLength + (subSquareIndex % squareLength) * squareLength;
  };

  const calculateSubSquareIndices = (subSquareIndex) => {
    const indices = [];
    for (let lineOffset = 0; lineOffset < squareLength; lineOffset++) {
      const startIndex = subSquareStartIndex(subSquareIndex, lineOffset);
      for (let i = startIndex; i < startIndex + squareLength; i++) {
        indices.push(i);
      }
    }
    return indices;
  };

  const calculateIndices = (calculator) => {
    const indices = [];
    for (let i = 0; i < boardLength; i++) indices.push(calculator(i));
    return indices;
  };

  return {
    row: calculateIndices(calculateRowIndices),
    column: calculateIndices(calculateColumnIndices),
    subSquare: calculateIndices(calculateSubSquareIndices),
  };
};

module.exports = calculateRelatedBoxIndices;
