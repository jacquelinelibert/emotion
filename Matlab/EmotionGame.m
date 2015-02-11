function [G, bkg, Clown, Buttons, screen2, CircusAnimal, Confetti] = EmotionGame
%       Setup Game 
   
 %--Doesn't work: does not know getScreens 
    %[~, screen2] = getScreens();
    %fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ',screen2));
    % We put the game on screen 2
    
 %G = SpriteKit.Game.instance('Title','Emotion Game', 'Size', screen2(3:4), 'Location', screen2(1:2), 'ShowFPS', false);
  G = SpriteKit.Game.instance('Title','Emotion Game', 'Size', [1010 365], 'Location',[300 300] , 'ShowFPS', false);

 % ------bkg = SpriteKit.Background(resizeBackgroundToScreenSize(screen2, '../Images/CircusTent.png'));
    bkg = SpriteKit.Background ('../Images/CircusTent.png');
    addBorders(G);
    
%       Initiate Sprites 
%       Clowns 
    Clown = SpriteKit.Sprite('clown');
    initState(Clown, 'clown', '../Images/clown_2.png', true);
    for k=1:4
        spritename = sprintf('clown_%d',k);
        pngFile = ['../Images/' spritename '.png'];
%       s.initState(spritename, pngFile, true);
        initState(Clown, ['clown_' int2str(k)] , pngFile, true);
    end
 % Clown.Location = [screen2(3)/2, screen2(4)-450]; 
 % Location probably different than above, but still like screen2/..
 Clown.Location = [400 150];
 Clown.State = 'clown';
 %ratioscreenclown = xxx * screen2(4);
 %[HeightClown, ~] = size(imread ('../Images/clown_2.png'));
 %Clown.Scale = ratioscreenclown/HeightClown;
 Clown.Scale = 0.2;
 
%       Buttons 
%  buttons_2 just a transparent image? 
    Buttons = SpriteKit.Sprite ('buttons'); 
    initState (Buttons, 'buttons', '../Images/buttons_0.png', true);
    for k=0:1
        spritename = sprintf ('buttons_%d', k);
        pngFile = ['../Images/' spritename '.png']; 
        initState (Buttons, ['buttons_' int2str(k)] , pngFile, true);
    end
    Buttons.Location = [900 150];
    Buttons.State = 'buttons';
    %ratioscreenbuttons = xxx * screen2(4);
    %[HeightButtons, ~] = size(imread ('../Images/buttons_0.png'));
    %Buttons.Scale = ratioscreenbuttons/HeightButtons;
    Buttons.Scale = 0.2;
    
%  %      CircusAnimals 
%     CircusAnimal = Spritekit.Sprite ('circusanimal');
%     initState (CircusAnimal, 'circusanimals', '../Images/circusanimal_1.png', true);
%     for k = 1:8 % in case of 8 different images (different image for every 6 trials)
%         spritename = sprintf ('circusanimal_%d', k);
%         pngFile = ['../Images/' spritename '.png'];
%         initState (CircusAnimal, ['circusanimal_' int2str(k)] , pngFile, true);
%     end
%     CircusAnimal.Location = [  ];
%     CircusAnimal.State = 'circusanimal';
%     ratioscreencircusanimal = xxx * screen2(4);
%     [HeightCircusAnimal, ~] = size (imread ('../Images/circusanimal_1.png'))
%     CircusAnimal.Scale = ratioscreencircusanimal/HeightCircusAnimal        
%     

%  %      Confetti/Feedback
%     Confetti = Spritekit.Sprite ('confetti');
%     initState (Confetti, 'confetti', '../Images/confetti.png', true);
%     Confetti.Location = [   ];
%     Confetti.State = 'confetti';
end

    
    