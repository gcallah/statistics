#!/Users/gcallah/miniconda3/bin/python3

"""
Demonstrating that statistically undetectable hot streaks can exist.
"""

import random

SHOTS = 50

print("Shooting with hot streaks:")
for shot in range(1, SHOTS):
    hot = (random.random() < .5)
    if hot:
        make = (random.random() < .66)
    else:
        make = (random.random() < .33)
    mark = 'X' if make else 'O'
    print(mark, end='')
print("")

print("Shooting without hot streaks:")
for shot in range(1, SHOTS):
    make = (random.random() < .5)
    mark = 'X' if make else 'O'
    print(mark, end='')
print("")
