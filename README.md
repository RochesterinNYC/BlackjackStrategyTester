Blackjack Strategy Tester
------

###Functionality

This is a MATLAB program that takes in a csv file depicting a Blackjack playing strategy and outputs the house edge of that strategy and a graph of bankroll trend while playing using that strategy.

####To Run:

In a MATLAB console 

    blackjackStrategyTester(dataFile, numDecks, standSoft17, doubleAfterSplit, blackjackPayout, numSimulations, standardBet);

The parameters are as follows:
- dataFile - the name of the Blackjack strategy file
- numDecks - number of decks to simulate with
- standSoft17 - whether the dealer stands on a 17 that has an ace that can still possibly take on a value of 11
- doubleAfterSplit - whether the player is allowed to double on a hand after a split
- blackjackPayout - the payout amount a player gets from winning with a blackjack
- numSimulations - the number of Blackjack rounds to play through with this strategy
- standardBet - the amount of money bet per Blackjack round

Please refer to the Blackjack Strategy CSV Format section for formatting your Blackjack Strategy file.

---

###Example Test Run 

####Actual House Edge and Strategy Calculation:

Strategy File transcribed from: http://wizardofodds.com/games/blackjack/strategy/calculator/

#####Wizard of Odds Actual Blackjack Calculator:
Number of decks of cards used: 8<br/>
Dealer hits or stands on a soft 17:  Stands<br/>
Player can double after a split:  Yes<br/>
Player can double on:  Any first two cards<br/>
Player can resplit to:  4 hands<br/>
Player can resplit aces:  Yes<br/>
Player can hit split aces:  No<br/>
Player loses only original bet against dealer BJ:  No<br/>
Surrender rule:  None<br/>
Blackjack pays:  3 to 2<br/>

Calculator Result: 0.36052%

Source: http://wizardofodds.com/games/blackjack/calculator/

#####MATLAB Program Test Run:

Test run with: 

    blackjackStrategyTester('blackjackstrategychart.csv', 8, 1, 1, 1.5, 10000, 5);

Same rules as used above and 10,000 simulations/rounds with $5 standard bet for each round.

Output:

    The house edge for this Blackjack strategy is 0.3540%.
    Following this strategy, at the end of 10000 rounds with a bet of $5 each round, your bankroll would be -$21735.

![Blackjack Strategy Tester Bankroll Graph](http://s3.amazonaws.com/jamesrwen/app/public/uploads/blackjackstrategygraph_original.png?1390771535 "Blackjack Strategy Tester Bankroll Graph")

#####Error Calculation:

![Blackjack Strategy Tester Error](http://s3.amazonaws.com/jamesrwen/app/public/uploads/blackjackstrategyerror_original.png?1390771527 "Blackjack Strategy Tester Error")

#####Results:
- Acceptable error margin.
- Note: For test runs with low number of simulations (ex. 1000), error margins are a lot larger.
- The graph of player bankroll progress helps to illustrate that even if you play with perfect strategy (house edge cannot get much lower than 0.35ish without extremely casino-unfavorable rules or card-counting), you will lose money in the long run due to house edge. For perspective, most simulation runs of 10,000 rounds or so with a $5 standard bet end up with about a -$22,000 bankroll. A good, efficient Blackjack player can play about 10 hands a minute online or at an empty table. Hence, in about 16.6 hours or maybe 2 days of consecutive play, an efficient Blackjack player playing perfect strategy (with no card counting) can lose $22,000.

---

###Blackjack Strategy CSV Format
- 1 is hit, 2 is stand, 3 is split, 4 is double if possible, otherwise hit, 5 is double if possible, otherwise stand
- Intersection of what dealer has and what player has are the actions that the player should take

####CSV Columns:
The CSV columns (1-10) represent what the dealer's face up card is.

1. A<br/>
2. 2<br/>
3. 3<br/>
4. 4<br/>
5. 5<br/>
6. 6<br/>
7. 7<br/>
8. 8<br/>
9. 9<br/>
10. 10/J/Q/K<br/>
<br/>

####CSV Rows:
The CSV rows (1-36) represent what the player's hand is (cards or total value).

1. 5<br/>
2. 6<br/>
3. 7<br/>
4. 8<br/>
5. 9<br/>
6. 10<br/>
7. 11<br/>
8. 12<br/>
9. 13<br/>
10. 14<br/>
11. 15<br/>
12. 16<br/>
13. 17<br/>
14. 18<br/>
15. 19<br/>
16. 20<br/>
17. 21<br/>
18. A-2<br/>
19. A-3<br/>
20. A-4<br/>
21. A-5<br/>
22. A-6<br/>
23. A-7<br/>
24. A-8<br/>
25. A-9<br/>
26. A-10<br/>
27. A-A<br/>
28. 2-2<br/>
29. 3-3<br/>
30. 4-4<br/>
31. 5-5<br/>
32. 6-6<br/>
33. 7-7<br/>
34. 8-8<br/>
35. 9-9<br/>
36. 10-10