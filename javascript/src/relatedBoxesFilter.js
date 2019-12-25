/**
 * Takes a list of boxes and removes possible values based on a set of rules
 */
class RelatedBoxesFilter {
  /**
   * Removes values that we already know
   * @param {array} relatedBoxes
   * @return {void}
   */
  removeKnownValues(relatedBoxes) {
    const knownValues = relatedBoxes
        .filter((box) => box.length === 1)
        .map((box) => box[0]);

    knownValues.forEach((value) => {
      relatedBoxes
          .filter((box) => box.length !== 1)
          .forEach((box) => {
            const indexOfValue = box.indexOf(value);

            if (indexOfValue >= 0) box.splice(box.indexOf(value), 1);
          });
    });
  }
}

module.exports = RelatedBoxesFilter;
