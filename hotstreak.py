#!/Users/gcallah/miniconda3/bin/python3

"""
Demonstrating that statistically undetectable hot streaks can exist.
"""

import random

SHOTS = 50
in_streak = False
hot_streaks = 0
hot_total = 0

print("Shooting with hot streaks:")
for shot in range(1, SHOTS):
    hot = (random.random() < .5)
    if hot:
        hot_total += 1
        if not in_streak:
            in_streak = True
            hot_streaks += 1
        make = (random.random() < .66)
    else:
        in_streak = False
        make = (random.random() < .33)
    mark = 'X' if make else 'O'
    print(mark, end='')
print("")
print("Average hot streak length = " + str(hot_total / hot_streaks))

print("Shooting without hot streaks:")
for shot in range(1, SHOTS):
    make = (random.random() < .5)
    mark = 'X' if make else 'O'
    print(mark, end='')
print("")
