function TryOut
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
 G.onMouseRelease = @buttondownfcn;

    bkg = SpriteKit.Background(resizeBackgroundToScreenSize(screen2, '../Images/BACKGROUND_unscaled.png'));
    addBorders(G);
    
% Initiate Sprites 
% Clowns 
    Clown = SpriteKit.Sprite('clown');
    Clown.initState('angry','../Images/clownfish_1.png', true);
    Clown.initState('sad','../Images/clownfish_2.png', true);
    Clown.initState('joyful','../Images/clownfish_3.png', true);
    Clown.initState('silent','../Images/clownfish_4.png', true);
    
    Clown.Location = [screen2(3)/4, screen2(4)-450]; 
    Clown.State = 'silent';
    ratioscreenclown = 0.25 * screen2(4);
    [HeightClown, ~] = size(imread ('../Images/clownfish_1.png'));
    Clown.Scale = ratioscreenclown/HeightClown;
 
%       Buttons 
    Buttonup = SpriteKit.Sprite ('buttonup'); 
    Buttonup.initState ('on','../Images/buttonup_1.png', true);
    Buttonup.initState ('off','../Images/buttonup_2.png', true); 
    Buttonup.Location = [screen2(3)/2, screen2(4)-650];
    Buttonup.State = 'on';
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
    Buttondown.State = 'on';
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
    
results = struct ();
response_accuracy = [];
countTrials = 0; 
starting = 1;   

soundDir = '../Stimuli/Emotion_normalized/';
emotionvoices = classifyFiles(soundDir);
options = [];
[expe, options] = building_conditions(options);

phase = 'test';
options.(phase).total_ntrials
  
for iTrial = 1 : options.(phase).total_ntrials
    
    Clown.State = 'silent';
    Buttonup.State = 'off';
    Buttondown.State = 'off';
    
    emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(iTrial).voicelabel);
    phaseVect = strcmp({emotionvoices.phase}, phase);
    possibleFiles = [emotionVect & phaseVect];
    indexes = 1:length(possibleFiles);
    indexes = indexes(possibleFiles);
    %this should store all names of possibleFiles 
    toPlay = randperm(length(emotionvoices(indexes)),1);
    
    [y, Fs] = audioread(emotionvoices(indexes(toPlay)).name);
    disp (emotionvoices(indexes(toPlay)).emotion)
    player = audioplayer (y, Fs);
    playblocking (player); 
    
    Clown.State = expe.(phase).condition(iTrial).facelabel;
    Buttonup.State = 'on';
    Buttondown.State = 'on';
    tic();
    uiwait();
    % remove just played file from list of possible sound files
    emotionvoices(indexes(toPlay)) = [];
    
    
    %if PrevRespAcc 
        %Confetti.State = 
    
    resp(iTrial).response=response;
    resp(iTrial).condition=expe.(phase).condition(iTrial);
    
    save ('tryoutresponses.mat', 'resp');
    
    
end

% response_accuracy = [response_accuracy, response.correct]; 
% resp = repmat(struct(response.button_clicked, 0), 1);


function buttondownfcn(hObject, callbackdata)
    
        locClick = get(hObject,'CurrentPoint');
        if starting == 1
            % uiwait();
            
            response.timestamp = now();
            response.response_time = toc();
            response.button_clicked = 0; % default in case they click somewhere else
            
                if (locClick(1) >= Buttonup.clickL) && (locClick(1) <= Buttonup.clickR) && ...
                        (locClick(2) >= Buttonup.clickD) && (locClick(2) <= Buttonup.clickU)
                    response.button_clicked = 1;
                end
                
                if (locClick(1) >= Buttondown.clickL) && (locClick(1) <= Buttondown.clickR) && ...
                        (locClick(2) >= Buttondown.clickD) && (locClick(2) <= Buttondown.clickU)
                    response.button_clicked = 0;
                end
                    response.correct = (response.button_clicked == expe.(phase).condition(iTrial).congruent);
                    
                    fprintf('Clicked button: %d\n', response.button_clicked);
                    fprintf('Trials: %d\n', iTrial);
                    fprintf('Response time : %d ms\n', round(response.response_time*1000));
                    fprintf('Response: %d\n', response.correct);
                    
                    uiresume
        end
               
end

    
G.onKeyPress = @keypressfcn;  
function keypressfcn(~,e)
        switch e.Key
            case 'a'
                Clown.State = 'angry';
            case 's'
                Clown.State = 'sad';
            case 'd'
                Clown.State = 'joyful';
        end
end 


end




     
