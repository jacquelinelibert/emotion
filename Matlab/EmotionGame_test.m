function [G, bkg, confetti, clown] = EmotionGame_test

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
    
%     Confetti = SpriteKit.Sprite ('confetti');
%     Confetti.initState ('off', ones(1,1,3), true);
%     for k = 1:7
%         spritename = sprintf('confetti_%d',k);
%         pngFile = ['../Images/' spritename '.png'];
%         Confetti.initState(spritename, pngFile, true);
%     end
%     Confetti.Location = [screen2(3)/4, screen2(4)-450];
%     Confetti.State = 'off';
%     Confetti.Scale = 0.8; 

    
    clown = SpriteKit.Sprite('clown');
    clown.initState('angry',['../Images/' 'clownemo_1' '.png'], true);
    clown.initState('sad',['../Images/' 'clownemo_2' '.png'], true);
    clown.initState('joyful',['../Images/' 'clownemo_3' '.png'], true);
    clown.initState('off', ones(1,1,3), true);
    for k = 1:5
        spritename = sprintf('clown_%d',k);
        pngFile = ['../Images/' spritename '.png']; 
        clown.initState(spritename, pngFile, true);
    end
    clown.Location = [screen2(3)/5.5, screen2(4)/3.2]; 
    clown.State = 'off';
    clown.Depth = 1;

    confetti = SpriteKit.Sprite ('confetti');
    confetti.initState ('off', ones(1,1,3), true);
    for k = 1:7
        spritename = sprintf('confetti_%d',k);
        pngFile = ['../Images/' spritename '.png'];
        confetti.initState(spritename, pngFile, true);
    end
    confetti.Location = [screen2(3)/4, screen2(4)-450];
    confetti.State = 'off';
    confetti.Scale = 0.8; 
    confetti.Depth = 2;
    


end
