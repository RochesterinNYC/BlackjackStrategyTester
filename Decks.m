classdef Decks < handle
   properties (SetAccess = public, GetAccess = public)
      cardsOfDeck
   end
   methods
      function obj = Decks()
        obj.cardsOfDeck = zeros(10, 4);
      end
      function setDecks(obj, numDecks)
        obj.cardsOfDeck(:, :) = 4 * numDecks;
        obj.cardsOfDeck(10, :) = 16 * numDecks;
      end
      %dealCard Function
      %Deals a card that can be specified as by random, random non ace or of a specific value of random suit
      %No input arguments is deal random card
      %One input argument is nonAce indication (varagin{1} is whether a non ace card is to be randomly dealt)
      %Two input arguments is dealing a specific value card of a random suit with varagin{2} indicating the value
      function cardValue = dealCard(obj, varargin)
        validCardPicked = 0;
        while ~validCardPicked
          suit = floor(rand(1)* 4) + 1;
          %seeking to specific value card
          if nargin == 3
            cardValue = varargin{2};
          %seeking to deal nonace card
          elseif nargin == 2 && varargin{1}
            cardValue = floor(rand(1)* 9) + 2;
          %seeking to deal random card
          else
            cardValue = floor(rand(1)* 10) + 1;
          end
          if obj.cardsOfDeck(cardValue, suit) ~= 0
            validCardPicked = 1;
          end
        end
        %remove card from deck since it was dealt
        obj.cardsOfDeck(cardValue, suit) = obj.cardsOfDeck(cardValue, suit) - 1;
      end
   end
end