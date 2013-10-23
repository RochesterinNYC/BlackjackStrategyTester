function[stratTable] = blackjackStrategy(numDecks, standSoft17, numSimulations)
  %create cell array of every combination (35 rows x 10 columns)
  stratTable = zeros(34, 10);
  [playerHands, dealerCards] = size(stratTable);

  %Create Arrays:
  %playerOptions 1-4 = Respectively Stand, Hit;
  playerOptions = [1, 2];
  playerOptionWins = zeros(1, 2);

  %create deck
  %matrix of 10 * 4 (10, J, Q, K are all the same value)
  decks = Decks();
  %creates a big deck of cards that are composed of numDecks decks
  decks.setDecks(numDecks);
  totalWins = 0;
  %Iterate through each combination
  for playerHandType = 1:playerHands
    for dealerCard = 1:dealerCards
      playerOptionWins(:, :) = 0;
      for playerOption = 1:length(playerOptions)
        for n = 1:numSimulations
          decks.setDecks(numDecks);
          simResult = playRound(playerHandType, dealerCard, playerOption, standSoft17, decks);
          if simResult == 1
            playerOptionWins(playerOption) = playerOptionWins(playerOption) + 1;
          end
        end
      end
      %compareWinFrequencies for player options for the currently matched up scenario
      %and set the appropriate cell matrix equal to the option to choose
      disp(playerOptionWins)
      totalWins = totalWins + max(playerOptionWins);
      bestOption = find(playerOptionWins == max(playerOptionWins));
      stratTable(playerHandType, dealerCard) = bestOption(1);
    end
  end
  %generate chart
  %houseEdge = totalWins / (numSimulations * 340);
  clf;
  figure(1);
  strat = uitable();
  set(strat, 'Position', [0 100 300 300])
  set(strat, 'Data', stratTable);
  set(strat,'ColumnWidth',{25})
  set(strat, 'ColumnName', { 'Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10/J/Q/K' });
  set(strat, 'ColumnWidth', { 25 25 25 25 25 25 25 25 25 25  });
  set(strat, 'RowName', {'5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', ...
                         '17', '18', '19', '21', 'A-2', 'A-3', 'A-4', 'A-5', 'A-6', 'A-7', ...
                         'A-8', 'A-9', 'A-A', '2-2', '3-3', '4-4', '5-5', '6-6', '7-7', ...
                         '8-8', '9-9', '10-10'});
end
%------------------------------------------------------------------
%createPlayerHand Function
%Uses number value relationships between the order of the player hand types and the hand/card values desired
function [playerHand] = createPlayerHand(handType, decks)
  %Regular, non-soft, non-paired hand up to 11 (2-9 possible card values dealt)
  playerHand = [];  
  if handType >= 1 && handType < 8
    %deals a random card under the value of the hand and greater than ace
    %ex for handType == 1 (value of 5 for hand), deals out 2 or 3
    playerHand(1, end + 1) = decks.dealCard(1, floor(rand(1)* (handType + 1)) + 2);
    if handType % 2 == 0
      while(playerHand(1, end) == (handType + 4) / 2)
        playerHand(1,end) = decks.dealCard(1, floor(rand(1)* (handType + 1)) + 2);
      end
    end
    playerHand(1, end + 1) = decks.dealCard(1, (handType + 4) - sum(playerHand));
  %Regular, non-soft, non-paired hand from 12 to 21 (2-10 possible card values dealt)
  elseif handType >= 8 && handType < 16
    %deals a random card where lower part of range is >= handTotal - 10
    %cannot deal out card that would need an ace to make the hand (ex. 13 is desired hand total, a 2 cannot be dealt)
    playerHand(1, end + 1) = decks.dealCard(1, floor(rand(1)* (17 - handType)) + (handType - 6));
    if handType % 2 == 0
      while(playerHand(1, end) == (handType + 4) / 2)
        playerHand(1, end) = decks.dealCard(1, floor(rand(1)* (17 - handType)) + (handType - 6));
      end
    end
    playerHand(1, end + 1) = decks.dealCard(1, (handType + 4) - sum(playerHand));
  %is 21
  elseif handType == 16
    playerHand(1, end + 1) = decks.dealCard(0, 1);
    playerHand(1, end + 1) = decks.dealCard(1, 10);
  %is Soft Hand (has an ace)
  elseif handType >= 17 && handType < 25
    playerHand(1, end + 1) = decks.dealCard(0, 1);
    playerHand(1, end + 1) = decks.dealCard(1, handType - 15);
  %is Paired Hand (pairs)
  elseif handType >= 25 && handType < 35
    playerHand(1, end + 1) = decks.dealCard(0, handType - 24);
    playerHand(1, end + 1) = decks.dealCard(0, handType - 24);
  end
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
function[playerWon] = playRound(playerHandType, dealerCard, playerAction, standSoft17, decks)

  playerWon = -1;
  dealerHand = [decks.dealCard(0, dealerCard), decks.dealCard()];
  playerHand = createPlayerHand(playerHandType, decks);

  %Both Blackjack (Tie)
  if handSum(playerHand) == 21 && handSum(dealerHand) == 21
    playerWon = playRound(playerHandType, dealerCard, playerAction, standSoft17, decks);
    return
  end

  %Player Blackjack (Player Win)
  if handSum(playerHand) == 21 && handSum(dealerHand) ~= 21
    playerWon = 2;
    return
  end

  %Dealer Blackjack (Player Loss)
  if handSum(playerHand) ~= 21 && handSum(dealerHand) == 21
    playerWon = 0;
    return
  end

  %Else play out
  %playerAction == 1, then stand
  if playerAction == 2 %Hit
    playerHand(1, end + 1) = decks.dealCard();
  end
  dealerHand = dealerPlay(dealerHand, standSoft17, decks);

  %tie (push) has no effect on strategic selection or wins vs. loses so play again recursively
  if handSum(playerHand) == handSum(dealerHand)
    playerWon = playRound(playerHandType, dealerCard, playerAction, standSoft17, decks);
    return
  end

  playerWon = ~(handSum(playerHand) > handSum(dealerHand));
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