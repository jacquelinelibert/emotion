function [G, Clown, Buttonup, Buttondown, gameCommands, Confetti, Parrot, ...
    Pool, Clownladder, Splash, ladder_jump11, clown_jump11] = EmotionGame

    fig = get(groot,'CurrentFigure');
    if ~isempty(fig)
        close(fig)
    end
    clear fig

    [~, screen2] = getScreens();
    fprintf('Experiment will displayed on: [%s]\n', sprintf('%d ',screen2));

    G = SpriteKit.Game.instance('Title','Emotion Game', 'Size', screen2(3:4), 'Location', screen2(1:2), 'ShowFPS', false);

    bkg = SpriteKit.Background(resizeBackgroundToScreenSize(screen2, '../Images/circusbackground_unscaled.png'));
    addBorders(G);
%     bkg.Depth = -1;
    
    Clown = SpriteKit.Sprite('clown');
    Clown.initState('angry',['../Images/' 'clownemo_1' '.png'], true);
    Clown.initState('sad',['../Images/' 'clownemo_2' '.png'], true);
    Clown.initState('joyful',['../Images/' 'clownemo_3' '.png'], true);
    Clown.initState('neutral',['../Images/' 'clown_neutral' '.png'], true);
    Clown.initState('off', ones(1,1,3), true);
    % SpotLight
    for iClown = 1:5
        spritename = sprintf('clownSpotLight_%d',iClown);
        pngFile = ['../Images/' spritename '.png'];
        Clown.initState(spritename, pngFile, true);
    end
%   Clown.Location = [screen2(3)/5.5, screen2(4)/3.2]; 
    [HeightClown, WidthClown, ~] = size(imread ('../Images/clownSpotLight_1.png')); 
    Clown.Location = [round(G.Size(1) /25 + WidthClown/2), round(HeightClown/2) + G.Size(2)/35]; 
    Clown.State = 'off';
    Clown.Scale = 1.1;
    Clown.Depth = 1;
    %ratioscreenclown = 0.25 * screen2(4);
    %[HeightClown, ~] = size(imread ('../Images/clownfish_1.png'));
    %Clown.Scale = ratioscreenclown/HeightClown;
    
%       Parrot 
    Parrot = SpriteKit.Sprite ('parrot');
    Parrot.initState('neutral', ['../Images/' 'parrot_neutral' '.png'], true);
    Parrot.initState('off', ones(1,1,3), true);
    for iParrot = 1:2
        spritename = sprintf('parrot_%d',iParrot);
        pngFile = ['../Images/' spritename '.png'];
        Parrot.initState(spritename, pngFile, true);
    end
    % Parrot.Scale = 0.8;
    Parrot.Location = [screen2(3)/2.2, screen2(4)/1.8];
    Parrot.State = 'off'; 
    Parrot.Depth = 2;
%       Buttons 
    Buttonup = SpriteKit.Sprite ('buttonup'); 
    Buttonup.initState ('on','../Images/buttonup_1.png', true);
    Buttonup.initState('press', '../Images/buttonuppress_1.png', true)
    Buttonup.initState ('off', ones(1,1,3), true); 
    Buttonup.Location = [screen2(3)/2.25, screen2(4)/6];
    Buttonup.State = 'off';
    [HeightButtonup, WidthButtonup] = size(imread ('../Images/buttonup_1.png'));
    % ratioscreenbuttons = 0.2 * screen2(4);
    % [HeightButtons, ~] = size(imread ('../Images/buttons_1.png'));
    % Buttonup.Scale = 0.5;
    
    addprop(Buttonup, 'clickL');
    addprop(Buttonup, 'clickR');
    addprop(Buttonup, 'clickD');
    addprop(Buttonup, 'clickU');
    Buttonup.clickL = round(Buttonup.Location(1) - round(HeightButtonup/2));
    Buttonup.clickR = round(Buttonup.Location(1) + round(HeightButtonup/2));
    Buttonup.clickD = round(Buttonup.Location(2) - round(WidthButtonup/2));
    Buttonup.clickU = round(Buttonup.Location(2) + round(WidthButtonup/2));
    Buttonup.Depth = 2;
    
    Buttondown = SpriteKit.Sprite ('buttondown'); 
    Buttondown.initState ('on','../Images/buttondown_1.png', true);
    Buttondown.initState ('press', '../Images/buttondownpress_1.png', true);
    Buttondown.initState ('off', ones(1,1,3), true);
    Buttondown.Location = [screen2(3)/1.75, screen2(4)/6];
    Buttondown.State = 'off';
    [HeightButtondown, WidthButtondown] = size(imread ('../Images/buttondown_1.png'));
    % ratioscreenbuttons = 0.2 * screen2(4);
    % [HeightButtons, ~] = size(imread ('../Images/buttons_1.png'));
    % Buttondown.Scale = 0.5;
    
    addprop(Buttondown, 'clickL');
    addprop(Buttondown, 'clickR');
    addprop(Buttondown, 'clickD');
    addprop(Buttondown, 'clickU');
    Buttondown.clickL = round(Buttondown.Location(1) - round(HeightButtondown/2));
    Buttondown.clickR = round(Buttondown.Location(1) + round(HeightButtondown/2));
    Buttondown.clickD = round(Buttondown.Location(2) - round(WidthButtondown/2));
    Buttondown.clickU = round(Buttondown.Location(2) + round(WidthButtondown/2));
    Buttondown.Depth = 2;

    %      Confetti/Feedback
    Confetti = SpriteKit.Sprite ('confetti');
    Confetti.initState ('off', ones(1,1,3), true);
    for iConfetti = 1:7
        spritename = sprintf('confetti_%d',iConfetti);
        pngFile = ['../Images/' spritename '.png'];
        Confetti.initState(spritename, pngFile, true);
    end
    Confetti.Location = [screen2(3)/2.5, screen2(4)-350];
    Confetti.State = 'off';
    Confetti.Scale = 1.4; 
    Confetti.Depth = 5;
    
%      Start and finish     
    gameCommands = SpriteKit.Sprite('controls');
    initState(gameCommands, 'begin','../Images/start1.png' , true);
    initState(gameCommands, 'finish','../Images/finish1.png' , true);
    initState(gameCommands, 'empty', ones(1,1,3), true); % to replace the images, 'none' will give an annoying warning
    gameCommands.State = 'begin';
    gameCommands.Location = [screen2(3)/2, screen2(4)/2];
    gameCommands.Scale = 1.3; % make it bigger to cover fishy
    % define clicking areas
    clickArea = size(imread('../Images/start.png'));
    addprop(gameCommands, 'clickL');
    addprop(gameCommands, 'clickR');
    addprop(gameCommands, 'clickD');
    addprop(gameCommands, 'clickU');
    gameCommands.clickL = round(gameCommands.Location(1) - round(clickArea(1)/2));
    gameCommands.clickR = round(gameCommands.Location(1) + round(clickArea(1)/2));
    gameCommands.clickD = round(gameCommands.Location(2) - round(clickArea(2)/4));
    gameCommands.clickU = round(gameCommands.Location(2) + round(clickArea(2)/4));
    clear clickArea 
    gameCommands.Depth = 10;   

%      Pool 
    Pool = SpriteKit.Sprite ('pool');
    Pool.initState('pool','../Images/pool.png', true);
    Pool.initState('empty', ones(1,1,3), true);
    Pool.Location = [screen2(3)/1.11, screen2(4)/3.7];
    Pool.State = 'empty';
    Pool.Depth = 1;

%      Splash 
    Splash = SpriteKit.Sprite ('splash');
    Splash.initState ('empty', ones(1,1,3), true);
    for isplash = 1:4
        spritename = sprintf('splash_%d', isplash);
        pngFile = ['../Images/' spritename '.png']; 
        Splash.initState (spritename, pngFile,true);
    end
    Splash.State = 'empty';
    Splash.Location = [screen2(3)/1.06 screen2(4)/2.5];
    Splash.Depth = 6;
      
%      Clownladder 
     Clownladder = SpriteKit.Sprite ('clownladder');
     Clownladder.initState ('empty', ones(1,1,3), true);
     Clownladder.initState ('ground', '../Images/clownladder_0a.png', true)
     Clownladder.State = 'empty';
     Clownladder.Location = [screen2(3)/1.26, screen2(4)/1.40];% screen2(3)/1.26 for sony 1.28 for maclaptop
     Clownladder.Depth = 5;
     let = {'a','b'};  
     for iladder = 0:8 
         for ilett=1:2
             spritename = sprintf('clownladder_%d%c',iladder,let{ilett});
             pngFile = ['../Images/' spritename '.png'];
             Clownladder.initState(spritename, pngFile, true);
         end
     end
     for ijump = 1:10
          spritename = sprintf('clownladder_jump_%d',ijump);
          pngFile = ['../Images/' spritename '.png'];
          Clownladder.initState (spritename, pngFile, true); 
     end
     
     spritename = sprintf('ladder_jump_11');
     pngFile = ['../Images/' spritename '.png'];
     ladder_jump11 = SpriteKit.Sprite ('ladder_jump11');
     ladder_jump11.initState ('empty', ones(1,1,3), true);
     ladder_jump11.initState (spritename, pngFile, true);
     ladder_jump11.Location = [screen2(3)/1.26, screen2(4)/1.40];
     ladder_jump11.Depth = 5;
     spritename = sprintf('clown_jump_11');
     pngFile = ['../Images/' spritename '.png'];     
     clown_jump11 = SpriteKit.Sprite ('clown_jump11');
     clown_jump11.initState ('empty', ones(1,1,3), true);
     clown_jump11.initState (spritename, pngFile, true);
     clown_jump11.Location = [screen2(3)/1.26, screen2(4)/1.40];
     clown_jump11.Depth = 7;
     
%     end
%     Confetti.Location = [screen2(3)/4, screen2(4)-450];
%     CircusAnimal.Location= [CircusAnimal.currentLocation{trial}];
%     CircusAnimal.State = 'empty';
%     ratioscreencircusanimal = 0.3 * screen2(4);
%     [HeightCircusAnimal, ~] = size (imread ('../Images/circusanimal_1.png'));
%     CircusAnimal.Scale = ratioscreencircusanimal/HeightCircusAnimal;

%     PositionPlaces = [1.7, 1.5; 1.6, 1.4; 1.5, 1.3; 1.4, 1.2; 1.3, 1.1; 1.1, 1.5];
%     addprop(CircusAnimal, 'currentLocation');
%     trial = 0;
%     
%     for animal = 1:8 % in case of 8 different images (different image for every 6 trials)
%         spritename = sprintf ('circusanimal_%d', animal);
%         pngFile = ['../Images/' spritename '.png'];
%         initState (CircusAnimal, ['circusanimal_' int2str(animal)] , pngFile, true);
%         for positions = 1:6
%             trial = trial +1;
%             CircusAnimal.currentLocation{trial}=[screen2(3)/PositionPlaces(positions,1), screen2(4)/PositionPlaces(positions, 1+1)];
%         end
%     end
%     
end
