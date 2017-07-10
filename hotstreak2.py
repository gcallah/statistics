#!/Users/gcallah/anaconda/bin/python3

"""
Demonstrating that statistically undetectable hot streaks can be bet on.
"""

import random

SHOTS = 100
MAKE_BET = True
MISS_BET = False

gene_stake = 100
kr_stake = 100
gene_bet = MAKE_BET

make = 0.0
print("Betting with hidden hot streak mechanism:")
for shot in range(1, SHOTS):
    hot = (random.random() < .5)
    gene_bet = MAKE_BET if hot else MISS_BET
    if hot:
        make = (random.random() < .66)
    else:
        make = (random.random() < .33)
    if gene_bet == make:
        gene_stake += .97
        kr_stake -= .97
    else:
        gene_stake -= 1.03
        kr_stake += 1.03

print("Gene's final holdings = " + str(round(gene_stake, 2)))
print("KR's final holdings = " + str(round(kr_stake, 2)))

