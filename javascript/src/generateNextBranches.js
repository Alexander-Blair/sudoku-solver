const generateNextBranches = (currentBranch) => {
  const clone = (array) => array.map((boxes) => {
    return boxes.map((possibleValue) => possibleValue);
  });

  const indexToBranchFrom = currentBranch.reduce((boxToBranchFrom, box, i) => {
    if (box.length > 1) {
      if (!boxToBranchFrom || box.length < boxToBranchFrom[0].length) {
        return [box, i];
      }
    }

    return boxToBranchFrom;
  }, null)[1];

  return currentBranch[indexToBranchFrom].map((value) => {
    const newBranch = clone(currentBranch);
    newBranch[indexToBranchFrom] = [value];
    return newBranch;
  });
};

module.exports = generateNextBranches;
