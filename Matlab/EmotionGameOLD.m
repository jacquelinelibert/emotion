
function [G, bkg, Clown, Buttons, screen2] = EmotionGame
%      Setup Game 

% PT: check if there are games already opened and close them
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
    
%       Initiate Sprites 
%       Clowns 
    Clown = SpriteKit.Sprite('clown');
    initState(Clown, 'clown', '../Images/clownfish_1.png', true);
    for k=1:4
        spritename = sprintf('clownfish_%d',k);
        pngFile = ['../Images/' spritename '.png'];
%       s.initState(spritename, pngFile, true);
        initState(Clown, ['clownfish_' int2str(k)] , pngFile, true);
    end
 Clown.Location = [screen2(3)/4, screen2(4)-450]; 
 Clown.State = 'clown';
 ratioscreenclown = 0.25 * screen2(4);
 [HeightClown, ~] = size(imread ('../Images/clownfish_1.png'));
 Clown.Scale = ratioscreenclown/HeightClown;
  
%       Buttons 
%  buttons_2 just a transparent image? 
    Buttons = SpriteKit.Sprite ('buttons'); 
    initState (Buttons, 'buttons', '../Images/buttons_1.png', true);
    for k=1:2
        spritename = sprintf ('buttons_%d', k);
        pngFile = ['../Images/' spritename '.png']; 
        initState (Buttons, ['buttons_' int2str(k)] , pngFile, true);
    end
    Buttons.Location = [screen2(3)/2, screen2(4)-650];
    Buttons.State = 'buttons';
    % ratioscreenbuttons = 0.2 * screen2(4);
    % [HeightButtons, ~] = size(imread ('../Images/buttons_1.png'));
    Buttons.Scale = 0.3;
    
      %      CircusAnimals 
%    CircusAnimal = Spritekit.Sprite ('circusanimal');
%     initState (CircusAnimal, 'circusanimals', '../Images/circusanimal_1.png', true);
%     for k = 1:8 % in case of 8 different images (different image for every 6 trials)
%         spritename = sprintf ('circusanimal_%d', k);
%         pngFile = ['../Images/' spritename '.png'];
%         initState (CircusAnimal, ['circusanimal_' int2str(k)] , pngFile, true);
%     end
%     CircusAnimal.Location = [screen2(3)/0.5, screen(4)-150];
%     CircusAnimal.State = 'circusanimal';
%     ratioscreencircusanimal = 0.2 * screen2(4);
%     [HeightCircusAnimal, ~] = size (imread ('../Images/circusanimal_1.png'))
%     CircusAnimal.Scale = ratioscreencircusanimal/HeightCircusAnimal        
%     

%  %      Confetti/Feedback
%     Confetti = Spritekit.Sprite ('confetti');
%     initState (Confetti, 'confetti', '../Images/confetti.png', true);
%     Confetti.Location = [screen2(3)/4, screen2(4)-450];
%     Confetti.State = 'confetti';
   
    
   %% 
   G.onKeyPress = @keypressfcn;
   
   
     function keypressfcn(~,e)
      switch e.Key
            case 'a'
                Clown.State = 'clownfish_1';
            case 's'
                Clown.State = 'clownfish_2';
            case 'd'
                Clown.State = 'clownfish_3';
            case 'f'
                Clown.State = 'clownfish_4';
        end
     end    

 
    
    

   % function action (Clown)
   %     Clown.State = Clown.CycleNext; 
   % end
        
end

 