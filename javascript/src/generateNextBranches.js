const generateNextBranches = (currentBranch) => {
  const indexToBranchFrom = currentBranch.reduce((boxToBranchFrom, box, i) => {
    if (box.length > 1) {
      if (!boxToBranchFrom || box.length < boxToBranchFrom[0].length) {
        return [box, i];
      }
    }

    return boxToBranchFrom;
  }, null)[1];

  return currentBranch[indexToBranchFrom].map((value) => {
    const newBranch = currentBranch.slice();
    newBranch[indexToBranchFrom] = [value];
    return newBranch;
  });
};

module.exports = generateNextBranches;
