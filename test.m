function[dealerHandValue] = test(dealerHand, standSoft17, decks)
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