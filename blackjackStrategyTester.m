function[houseEdge] = blackjackStrategyTester(dataFile, numDecks, standSoft17, doubleAfterSplit, blackjackPayout, numSimulations, standardBet)
  %import and convert strategyTable

  strategyChart = generateStrategyChart(dataFile);

  %create deck
  %matrix of 10 * 4 (10, J, Q, K are all the same value)
  decks = Decks();
  %creates a big deck of cards that are composed of numDecks decks
  decks.setDecks(numDecks);

  totalWinnings = 0;
  totalSpent = 0;
  %Iterate through each combination
  for n = 1:numSimulations
    decks.setDecks(numDecks);
    [roundWinnings, roundSpent] = playRound(standSoft17, doubleAfterSplit, blackjackPayout, strategyChart, decks, standardBet);
    totalWinnings = totalWinnings + roundWinnings;
    totalSpent = totalSpent + roundSpent;
  end

  houseEdge = totalWinnings / totalSpent;

end

%------------------------------------------------------------------
%handSum Function
%Calculates sum of hand (necessary to have function because of special nature of aces)
function[handValue] = handSum(hand) 
  if(min(hand) == 1)
    %number of aces in hand does not matter since only one ace can have a value of 11 instead of 1 (two aces with value of 11 is 22 hand total)
    if sum(hand) + 10 <= 21
      handValue = sum(hand) + 10;
    else
      handValue = sum(hand); 
    end
  else
    handValue = sum(hand);
  end
end
%------------------------------------------------------------------
%playRound Function
%Plays a simulated round of blackjack where user has a predefined hand, action to take, and dealer has a faceup card
%Dealer plays as normal 
%playerWon as 0 is loses, 1 is wins, 2 is player blackjack
function[playerWinnings, playerLoss] = playRound(standSoft17, doubleAfterSplit, blackjackPayout, strategyChart, decks, standardBet, varargin)

  playerLoss = standardBet;
  isDoubleRound = 0;
  isSplitRound = 0;

  if nargin == 9
    %new round player has one split card so deal another
    playerHand = [varargin{8}, decks.dealCard()];
    dealerHand = varargin{9};
    isSplitRound = 1;
  elseif nargin == 7
    %1st card in dealer hand is the visible, faceup one
    dealerHand = [decks.dealCard(), decks.dealCard()];
    playerHand = [decks.dealCard(), decks.dealCard()];
  end

  %Both Blackjack (Tie)
  if handSum(playerHand) == 21 && handSum(dealerHand) == 21
    playerWinnings = standardBet;
    return
  end

  %Player Blackjack (Player Win)
  if handSum(playerHand) == 21 && handSum(dealerHand) ~= 21
    playerWinnings = standardBet * blackjackPayout + standardBet;
    return
  end

  %Dealer Blackjack (Player Loss)
  if handSum(playerHand) ~= 21 && handSum(dealerHand) == 21
    playerWinnings = 0;
    return
  end

  %Else play out
  %1 is hit, 2 is stand, 3 is split, 4 is double if possible, otherwise hit, 5 is double if possible, otherwise stand
  playerContinue = 1;
  while playerContinue
    action = strategyChart.getPlayerAction(playerHand, dealerHand(1), handSum(playerHand))

    %is a split hand and double after split is not allowed so hit
    if isSplit && ~doubleAfterSplit
      if action == 4
        action = 1;
      elseif action == 5
        action = 2;
      end
    end

    if action == 1 %hit
      playerHand(1, end + 1) = decks.dealCard();
    elseif action == 2 %stand
      playerContinue = 0;
    elseif action == 3 %split
      
      playerSplitHand1 = [playerHand(1)];
      playerLoss = playerLoss - standardBet;
      %splitting is as if you took back your bet and put down two bets on two separate hands
      playerSplitHand2 = [playerHand(2)];
      [splitHand1Loss, splitHand1Winnings] = playRound(standSoft17, doubleAfterSplit, blackjackPayout, ...
                                                       strategyChart, decks, standardBet, playerSplitHand1, dealerHand);
      [splitHand2Loss, splitHand2Winnings] = playRound(standSoft17, doubleAfterSplit, blackjackPayout, ...
                                                       strategyChart, decks, standardBet, playerSplitHand2, dealerHand);

      playerLoss = playerLoss + splitHand1Loss + splitHand2Loss;
      playerWinnings = playerWinnings + splitHand1Winnings + splitHand2Winnings;

    elseif action == 4 || action == 5 %double
      playerLoss = playerLoss + standardBet;
      isDoubleRound = 1;
      playerHand(1, end + 1) = decks.dealCard();
      playerContinue = 0;
    end
  end

  dealerHand = dealerPlay(dealerHand, standSoft17, decks);
  
  dealerHandValue = handSum(dealerHand);
  playerHandValue = handSum(playerHand);

  %instead of extra set of logic branches, simply add a multiplier for double
  if isDoubleRound
    doubleMultiplier = 2;
  else
    doubleMultiplier = 1;
  end

  if playerHandValue == dealerHandValue
    playerWinnings = standardBet * doubleMultiplier;
  elseif playerHandValue < dealerHandValue
    playerWinnings = 0;
  elseif playerHandValue > dealerHandValue
    playerWinnings == 2 * standardBet * doubleMultiplier;  
  end

end
%------------------------------------------------------------------
%dealerPlay Function
%dealer plays (depends on )
function[dealerHandValue] = dealerPlay(dealerHand, standSoft17, decks)
  %dealer has an ace and has to hit on 17
  if min(dealerHand) == 1 && ~standSoft17
    dealerStopsOn = 18;
  %dealer does not have an ace or does but has to stand on 17
  else
    dealerStopsOn = 17;
  end
  while(handSum(dealerHand) < dealerStopsOn)
    dealerHand(1, end + 1) = decks.dealCard();
  end
  dealerHandValue = handSum(dealerHand);
end