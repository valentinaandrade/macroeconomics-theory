% Teoritical value p = 0.00049116
number_of_runs = 10000;
allHeart = zero(1,number_of_runs);

for n = 1:number_of_runs
    deck = randperm(52); % 52 heart in deck
    num_of_cards_drawn = 5;
    draw = deck(1:num_of_cards_drawn);

    count = 0;
    for i = 1:num_of_cards_drawn
        if draw(i) <= 13;
            count = count + 1
        end
    end
    if count == num_of_cards_drawn;
        allHeart(n) = 1;
    else
        allHeart(n) = 0;
    end
 S = sum(allHearts);
 p = S/number_of_runs;