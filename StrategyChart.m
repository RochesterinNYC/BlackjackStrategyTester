classdef StrategyChart < handle
   properties (SetAccess = public, GetAccess = public)
      hardStrat
      softStrat
      pairStrat
   end
   methods
      function obj = StrategyChart(dataFileName)
        obj.hardStrat = dlmread(dataFileName, ',', [ 1 1 17 10] );
        obj.softStrat = dlmread(dataFileName, ',', [ 18 1 27 10] );
        obj.pairStrat = dlmread(dataFileName, ',', [ 27 1 36 10] );
      end
      %decideAction function
      %returns what a player should do given their current hand and the dealer face up card
      function playerAction = decideAction(obj, playerHand, dealerHand, playerHandSum);
        %paired hand
        if length(playerHand) == 2 && playerHand(1) == playerHand(2)
          playerAction = obj.pairStrat(playerHand(1), dealerHand);

        %ace edge cases of handValue == 12 should be treated as if they were 12
        elseif min(playerHand) == 1 && playerHandSum == 12
          playerAction = obj.decideAction([2, 10], dealerHand, 12);
       
        %soft hand with one ace
        elseif min(playerHand) == 1 && sum(playerHand == 1) == 1
          playerAction = obj.softStrat(playerHandSum - 12, dealerHand);
        
        %soft hand with > one ace
        elseif min(playerHand) == 1 && sum(playerHand == 1) > 1
          %turn other aces and non-ace values into single value
          playerHand = sort(playerHand);
          sumOtherCards = sum(playerHand(2:end));
          if (sumOtherCards >= 11)
            playerAction = obj.decideAction([1, sumOtherCards], dealerHand, sumOtherCards + 1);
          else
            playerAction = obj.softStrat(sumOtherCards - 1, dealerHand);
          end
        %hard hand
        else
          playerAction = obj.hardStrat(playerHandSum - 4, dealerHand);
        end
      end
   end
end