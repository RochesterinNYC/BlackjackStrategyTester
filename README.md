Example Test Run: 

Strategy File transcribed from: http://wizardofodds.com/games/blackjack/strategy/calculator/

Actual Blackjack Calculator
Number of decks of cards used: 8
Dealer hits or stands on a soft 17:  Stands
Player can double after a split:  Yes
Player can double on:  Any first two cards
Player can resplit to:  4 hands
Player can resplit aces:  Yes
Player can hit split aces:  No
Player loses only original bet against dealer BJ:  No
Surrender rule:  None
Blackjack pays:  3 to 2

Calculator Result: 0.36052%
Source: http://wizardofodds.com/games/blackjack/calculator/

MATLAB Program Test Run:

Test run with: blackjackStrategyTester('blackjackstrategychart.csv', 8, 1, 1, 1.5, 10000, 5);
Same rules and 10,000 simulations/betting rounds with $5 standard bet

House Edge Result: 0.3540

% Error = (0.3540 - 0.36052) / 0.36052 = - 0.018 = -1.8% Error
- Very acceptable error margin.

- Note: For test runs with low number of simulations (ex. 1000), error margins are a lot larger.

- The graph of player bankroll progress helps to illustrate that even if you play with perfect 
  strategy (house edge cannot get much lower than 0.35ish without extremely casino-unfavorable rules or card-counting),
  you will lose money in the long run due to house edge. For perspective, most simulation runs of 10,000 rounds or so with 
  a $5 standard bet end up with a -2.2 * 10^4 bankroll, or -$22,000 bankroll. A good Blackjack player that knows perfect 
  strategy can play about 10 hands a minute online or at an empty table so in about 16.6 hours or maybe 2 days of 
  consecutive play, a Blackjack player playing perfect strategy can lose $22,000.

------------------------------------------------------------------------------------------------

CSV Format:
- 1 is hit, 2 is stand, 3 is split, 4 is double if possible, otherwise hit, 5 is double if possible, otherwise stand
- Intersection of what dealer has and what player has are the actions that the player should take

Dealer Face-up Card = Columns 1-10 = 
0. Labels/What Player has
1. A
2. 2
3. 3
4. 4
5. 5
6. 6
7. 7
8. 8
9. 9
10. 10/J/Q/K

User Hand = Rows 1-36 = 
0. Labels/What Dealer has
1. 5
2. 6
3. 7
4. 8
5. 9
6. 10
7. 11
8. 12
9. 13
10. 14
11. 15
12. 16
13. 17
14. 18
15. 19
16. 20
17. 21
18. A-2
19. A-3
20. A-4
21. A-5
22. A-6
23. A-7
24. A-8
25. A-9
26. A-10
27. A-A
28. 2-2
29. 3-3
30. 4-4
31. 5-5
32. 6-6
33. 7-7
34. 8-8
35. 9-9
36. 10-10