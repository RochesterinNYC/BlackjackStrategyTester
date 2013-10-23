%Decks class
%Represents an aggregate deck (composed of many 52 card decks) that gets passed by reference
classdef Decks < handle
   properties (SetAccess = public, GetAccess = public)
      cardsOfDeck
   end
   methods
      function obj = Decks()
        obj.cardsOfDeck = zeros(10, 4);
      end
      %setDecks Function
      %sets the aggregate cards of deck array to appropriate number of cards/decks
      function setDecks(obj, numDecks)
        obj.cardsOfDeck(:, :) = 4 * numDecks;
        obj.cardsOfDeck(10, :) = 16 * numDecks;
      end
      %dealCard Function
      %Deals a random card
      function cardValue = dealCard(obj)
        validCardPicked = 0;
        while ~validCardPicked
          suit = floor(rand(1)* 4) + 1;
          cardValue = floor(rand(1)* 10) + 1;
          if obj.cardsOfDeck(cardValue, suit) ~= 0
            validCardPicked = 1;
          end
        end
        %remove card from deck since it was dealt
        obj.cardsOfDeck(cardValue, suit) = obj.cardsOfDeck(cardValue, suit) - 1;
      end
   end
end