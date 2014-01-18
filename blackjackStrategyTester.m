function[houseEdge] = blackjackStrategyTester(dataFile, numDecks, standSoft17, doubleAfterSplit, blackjackPayout, numSimulations, standardBet)
%blackjackStrategyTester method that reads in a Blackjack Strategy Chart in a specific format and runs simulations and calculates house edge and graphs play bankroll
%parameters((dataFile, numDecks, standSoft17, doubleAfterSplit, blackjackPayout, numSimulations, standardBet)
  
  %Create strategyTable object with strategy table csv
  strategyChart = StrategyChart(dataFile);

  %create complete deck object (matrix of 10 * 4 as 10, J, Q, K are all the same value)
  decks = Decks();
  decks.setDecks(numDecks);

  %Minimum recommended starting bankroll is enough to cover 50 minimum bets
  bankRollValue = 50 * standardBet;
  bankRollCount = [];
  roundNumber = [];
  totalWinnings = 0;
  totalSpent = 0;
  %Iterate through each combination
  for n = 1:numSimulations
    decks.setDecks(numDecks);
    [roundWinnings, roundSpent] = playRound(standSoft17, doubleAfterSplit, blackjackPayout, strategyChart, decks, standardBet);
    totalWinnings = totalWinnings + roundWinnings;
    totalSpent = totalSpent + roundSpent;
    bankRollValue = bankRollValue + roundWinnings - roundSpent;
    bankRollCount(1, end + 1) = bankRollValue;
    roundNumber(1, end + 1) = n;
  end
  
  clf;
  figure(1);
  plot(roundNumber, bankRollCount);
  title('Blackjack Player Bankroll Progress');
  xlabel('Round Number');
  ylabel('Player Bankroll Value ($)');
  axis([0 (max(roundNumber)+1) (min(bankRollCount) - (max(bankRollCount) - min(bankRollCount)) * 0.05) ...
           (max(bankRollCount) + (max(bankRollCount) - min(bankRollCount)) * 0.05)]);
  grid minor;

  %House Edge is ratio of average loss to initial bet
  %Ex. If house edge = .05%, then player expects to lose $0.05 for every $1 flat bet.
  houseEdge = -((totalWinnings - totalSpent) / totalSpent);
  fprintf('The house edge for this Blackjack strategy is %f%%.\n', houseEdge);
  fprintf('Following this strategy, at the end of %d rounds with a bet of $%d each round, your bankroll would be -$%d.\n', numSimulations, standardBet, -round(bankRollValue));
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
%plays a round of blackjack between player and dealer and returns player winnings and loss
function[playerWinnings, playerLoss] = playRound(standSoft17, doubleAfterSplit, blackjackPayout, strategyChart, decks, standardBet, varargin)
  playerLoss = standardBet;
  isDoubleRound = 0;
  isSplitRound = 0;
  playerBusts = 0;

  %deal out cards (deal one to player if round is a split round)
  if nargin == 8
    %new round player has one split card so deal another
    playerHand = [varargin{1}, decks.dealCard()];
    dealerHand = varargin{2};
    isSplitRound = 1;
  elseif nargin == 6
    %1st card in dealer hand is the visible, faceup one
    playerHand = [decks.dealCard(), decks.dealCard()];
    dealerHand = [decks.dealCard(), decks.dealCard()];
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

  %continue and decide a player action based on strategy chart if not busted yet
  while playerContinue
    
    action = strategyChart.decideAction(playerHand, dealerHand(1), handSum(playerHand));
    
    %is a split hand and double after split is not allowed, so action is hit or stand
    if isSplitRound && ~doubleAfterSplit
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
      %set up split betting and hands      
      playerSplitHand1 = [playerHand(1)];
      playerLoss = playerLoss - standardBet;
      %splitting is as if you took back your bet and put down two bets on two separate hands
      playerSplitHand2 = [playerHand(2)];
      %recursively play new split hands
      [splitHand1Loss, splitHand1Winnings] = playRound(standSoft17, doubleAfterSplit, blackjackPayout, ...
                                                       strategyChart, decks, standardBet, playerSplitHand1, dealerHand);
      [splitHand2Loss, splitHand2Winnings] = playRound(standSoft17, doubleAfterSplit, blackjackPayout, ...
                                                       strategyChart, decks, standardBet, playerSplitHand2, dealerHand);
      %get split hand results
      playerLoss = playerLoss + splitHand1Loss + splitHand2Loss;
      playerWinnings = splitHand1Winnings + splitHand2Winnings;
      playerContinue = 0;
    elseif action == 4 || action == 5 %double
      playerLoss = playerLoss + standardBet;
      isDoubleRound = 1;
      playerHand(1, end + 1) = decks.dealCard();
      playerContinue = 0;
    end

    %check if player has busted
    if handSum(playerHand) > 21 
      action = 0;
      playerBusts = 1;
      playerContinue = 0;
    end
  end
  
  %instead of extra set of logic branches, simply add a multiplier for double
  if isDoubleRound
    doubleMultiplier = 2;
  else
    doubleMultiplier = 1;
  end

  %if player has busted, round ends and dealer wins
  if playerBusts
    playerWinnings = 0;
    return
  end
  
  %if player has not busted, dealer plays
  dealerHand = dealerPlay(dealerHand, standSoft17, decks);

  %if dealer has busted and player has not, round ends and player wins
  if handSum(dealerHand) > 21 
    playerWinnings = standardBet * doubleMultiplier;
    return
  end

  dealerHandValue = handSum(dealerHand);
  playerHandValue = handSum(playerHand);
  
  %if neither player nor dealer has busted, compare hand values
  if playerHandValue == dealerHandValue
    playerWinnings = standardBet * doubleMultiplier;
  elseif playerHandValue < dealerHandValue
    playerWinnings = 0;
  elseif playerHandValue > dealerHandValue
    playerWinnings = 2 * standardBet * doubleMultiplier;  
  end

end
%------------------------------------------------------------------
%dealerPlay Function
%dealer plays his hand according to stand or not on soft 17 rules and having to hit until at least 17
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