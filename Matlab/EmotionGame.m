function [G, bkg, Clown, Buttonup, Buttondown, gameCommands, Confetti, CircusAnimal] = EmotionGame

% Setup Game 

% PT: check there are games already opened and close them
    fig = get(groot,'CurrentFigure');
    if ~isempty(fig)
        close(fig)
    end
    clear fig   
 
    [~, screen2] = getScreens();
    fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ',screen2));
    % We put the game on screen 2
  % Make animation  

G = SpriteKit.Game.instance('Title','Emotion Game', 'Size', screen2(3:4), 'Location', screen2(1:2), 'ShowFPS', false);
    
bkg = SpriteKit.Background(resizeBackgroundToScreenSize(screen2, '../Images/BACKGROUND_unscaled.png'));
addBorders(G);
    
% Initiate Sprites 
% Clowns 
    Clown = SpriteKit.Sprite('clown');
    Clown.initState('angry','../Images/clownfish_1.png', true);
    Clown.initState('sad','../Images/clownfish_2.png', true);
    Clown.initState('joyful','../Images/clownfish_3.png', true);
    Clown.initState('silent','../Images/clownfish_4.png', true);
    Clown.initState('off', '../Images/clownfish_5.png', true); 
    
    Clown.Location = [screen2(3)/4, screen2(4)-450]; 
    Clown.State = 'off';
    ratioscreenclown = 0.25 * screen2(4);
    [HeightClown, ~] = size(imread ('../Images/clownfish_1.png'));
    Clown.Scale = ratioscreenclown/HeightClown;
 
%       Buttons 
    Buttonup = SpriteKit.Sprite ('buttonup'); 
    Buttonup.initState ('on','../Images/buttonup_1.png', true);
    Buttonup.initState ('off','../Images/buttonup_2.png', true); 
    Buttonup.Location = [screen2(3)/2, screen2(4)-650];
    Buttonup.State = 'off';
    [HeightButtonup, WidthButtonup] = size(imread ('../Images/buttonup_1.png'));
    % ratioscreenbuttons = 0.2 * screen2(4);
    % [HeightButtons, ~] = size(imread ('../Images/buttons_1.png'));
    Buttonup.Scale = 0.5;
    
    addprop(Buttonup, 'clickL');
    addprop(Buttonup, 'clickR');
    addprop(Buttonup, 'clickD');
    addprop(Buttonup, 'clickU');
    Buttonup.clickL = round(Buttonup.Location(1) - round(HeightButtonup/2));
    Buttonup.clickR = round(Buttonup.Location(1) + round(HeightButtonup/2));
    Buttonup.clickD = round(Buttonup.Location(2) - round(WidthButtonup/2));
    Buttonup.clickU = round(Buttonup.Location(2) + round(WidthButtonup/2));

    Buttondown = SpriteKit.Sprite ('buttondown'); 
    Buttondown.initState ('on','../Images/buttondown_1.png', true);
    Buttondown.initState ('off','../Images/buttondown_2.png', true);
    Buttondown.Location = [screen2(3)/2.5, screen2(4)-650];
    Buttondown.State = 'off';
    [HeightButtondown, WidthButtondown] = size(imread ('../Images/buttondown_1.png'));
    % ratioscreenbuttons = 0.2 * screen2(4);
    % [HeightButtons, ~] = size(imread ('../Images/buttons_1.png'));
    Buttondown.Scale = 0.5;
    
    addprop(Buttondown, 'clickL');
    addprop(Buttondown, 'clickR');
    addprop(Buttondown, 'clickD');
    addprop(Buttondown, 'clickU');
    Buttondown.clickL = round(Buttondown.Location(1) - round(HeightButtondown/2));
    Buttondown.clickR = round(Buttondown.Location(1) + round(HeightButtondown/2));
    Buttondown.clickD = round(Buttondown.Location(2) - round(WidthButtondown/2));
    Buttondown.clickU = round(Buttondown.Location(2) + round(WidthButtondown/2));
    
%      Confetti/Feedback
    Confetti = SpriteKit.Sprite ('confetti');
    Confetti.initState ('confetti', '../Images/confetti.png', true);
    Confetti.initState ('nono', '../Images/confettiOFF.png', true);
    Confetti.Location = [screen2(3)/4, screen2(4)-450];
    Confetti.State = 'nono';
    Confetti.Scale = 0.4; 
    
%      Start and finish     
    gameCommands = SpriteKit.Sprite('controls');
%   initState(gameCommands, 'none', zeros(2,2,3), true);
    initState(gameCommands, 'begin','../Images/start.png' , true);
    initState(gameCommands, 'finish','../Images/finish.png' , true);
    initState(gameCommands, 'empty', ones(1,1,3), true); % to replace the images, 'none' will give an annoying warning
    gameCommands.State = 'begin';
    gameCommands.Location = [screen2(3)/2, screen2(4)/2 + 40];
    gameCommands.Scale = 0.7; % make it bigger to cover fishy
    % define clicking areas
    clickArea = size(imread('../Images/start.png'));
    addprop(gameCommands, 'clickL');
    addprop(gameCommands, 'clickR');
    addprop(gameCommands, 'clickD');
    addprop(gameCommands, 'clickU');
    gameCommands.clickL = round(gameCommands.Location(1) - round(clickArea(1)/2));
    gameCommands.clickR = round(gameCommands.Location(1) + round(clickArea(1)/2));
    gameCommands.clickD = round(gameCommands.Location(2) - round(clickArea(2)/2));
    gameCommands.clickU = round(gameCommands.Location(2) + round(clickArea(2)/2));
    clear clickArea 
   
%      CircusAnimals 
      CircusAnimal = SpriteKit.Sprite ('circusanimal');
      CircusAnimal.initState ('monkey', '../Images/circusanimal_1.png', true);
 %       for k = 1:8 % in case of 8 different images (different image for every 6 trials)
 %           spritename = sprintf ('circusanimal_%d', k);
 %           pngFile = ['../Images/' spritename '.png'];
 %           initState (CircusAnimal, ['circusanimal_' int2str(k)] , pngFile, true);
 %       end
       CircusAnimal.Location = [screen2(3)/0.5, screen2(4)-150];
       CircusAnimal.State = 'monkey';
       ratioscreencircusanimal = 0.2 * screen2(4);
       [HeightCircusAnimal, ~] = size (imread ('../Images/circusanimal_1.png'));
       CircusAnimal.Scale = ratioscreencircusanimal/HeightCircusAnimal;     
end
