const getPasswordCountInRange = (start, finish) => {
  let counter = 0;
  for (var i = start; i <= finish; i++) {
    const numToString = `${i}`;
    if (twoAdjacentDigits(numToString) && digitsDoNotDecrease(numToString)) {
      counter += 1;
    }
  }
  return counter;
}

function twoAdjacentDigits(numToString) {
  const matchData = numToString.match(/(\d)\1+/g);
  if (matchData) {
    return Math.min(...matchData) < 100
  }
  return false
}

function digitsDoNotDecrease(numToString) {
  const digits = numToString.split("");
  result = true
  for (let i = 0; i < digits.length; i++) {
    if (digits[i] > digits[i + 1]) { return false; }
  }
  return true;
}

getPasswordCountInRange(278384, 824795);
