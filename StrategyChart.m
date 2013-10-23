classdef StrategyChart < handle
   properties (SetAccess = public, GetAccess = public)
      hardStrat
      softStrat
      pairStrat
   end
   methods
      function obj = StrategyChart(dataFileName)
        obj.cardsOfDeck = zeros(17, 10);
        obj.cardsOfDeck = zeros(9, 4);
        obj.cardsOfDeck = zeros(11, 4);
        setStrategyChart(dataFileName);
      end
      function setStrategyChart(dataFileName)
        hardStrat = csvread(dataFileName, 1, 1, [ 1 1 17 10] );
        softStrat = csvread(dataFileName, 1, 1, [ 18 1 27 10] );
        pairStrat = csvread(dataFileName, 1, 1, [ 27 1 36 10] );
      end
      %decideAction function
      function playerAction = decideAction(playerHand, dealerHand, playerHandSum);
        %paired hand
        if length(playerHand) == 2 && playerHand(1) == playerHand(2)
          playerAction = pairStrat(playerHand(1), dealerHand);

        %ace edge cases of handValue == 12 should be treated as if they were 12
        elseif min(playerHand) == 1 && playerHandSum == 12
          playerAction = decideAction([2, 10], dealerHand, 12);
        %soft hand with one ace
        elseif min(playerHand) == 1 && sum(playerHand == 1) == 1
          removeAce()
          playerAction = softStrat(playerHandSum - 4, dealerHand);
        %soft hand with > one ace
        elseif min(playerHand) == 1 && sum(playerHand == 1) > 1
          %turn other aces and non-ace values into single value
          playerHand = sort(playerHand);
          sumOtherCards = sum(playerHand(2:end));
          playerAction = softStrat(sumOtherCards - 1, dealerHand);
        %hard hand
        else
          playerAction = hardStrat(playerHandSum - 4, dealerHand);
        end
      end
      function 
   end
end