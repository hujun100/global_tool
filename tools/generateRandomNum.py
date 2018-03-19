import random
import numpy as np
lowerBound = 0
UpperBound = 800
ignoreNum = [1]
randNum = random.randint(lowerBound, UpperBound)
while randNum in ignoreNum:
  randNum = random.randint(lowerBound, UpperBound)
print(randNum)
