function Expe_Emotion(varargin)
% 

    if nargin > 0
        simulateSubj = false;
        if strcmp(varargin{1}, 'simulate')
            simulateSubj = true;
            subjectname = varargin{2};
            phase = varargin{3};
            cue = varargin{4};
        else
            subjectname = varargin{1};
            phase = varargin{2};
            cue = varargin{3};
        end
    else
        simulateSubj = true;
        subjectname = 'random';
        phase = {'test', 'training', 'facerecognition'};
        phase = phase{randi(2)};
        cue = {'intact', 'normalized'};
        cue = cue{randi(2)};
    end
    
    switch cue
        case 'normalized'
            soundDir = '../Stimuli/Emotion_normalized/';
        case 'intact'
            soundDir = '../Stimuli/Emotion/';
        otherwise
            error('cue option does not exists')
    end
    
%     pathsToAdd = {'../lib/MatlabCommonTools/'};
% this kind of defeat the purpouse but for now it stays like this:
    pathsToAdd = {'/home/paolot/gitStuff/Beautiful/lib/MatlabCommonTools/'};
    for iPath = 1 : length(pathsToAdd)
        addpath(pathsToAdd{iPath})
    end
    
    options.home = getHome;
    
    pathsToAdd{2} = [options.home '/gitStuff/Beautiful/lib/SpriteKit'];
    addpath(pathsToAdd{2});
    
    %% Setup experiment 
    options.subject_name = subjectname;
    options.result_path = [options.home '/results/Emotion'];
    options.result_prefix = 'emo_';
    res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
    options.res_filename = res_filename;

    if exist(options.res_filename, 'file')
        load(options.res_filename);
    else
        [expe, options] = building_conditions(options);
    end
    
    
    %% Game Stuff 
    [G, Clown, Buttonup, Buttondown, gameCommands, Confetti, Parrot, Pool, ...
        Clownladder, Splash, ladder_jump11, clown_jump11, Drops, ExtraClown] = EmotionGame; 
    G.onMouseRelease = @buttondownfcn;
    G.onKeyPress = @keypressfcn;

    starting = 0;   
    
    emotionvoices = classifyFiles(soundDir, phase);
    ladderStep = 1;
    %% ============= Main loop =============   
    for itrial = 1 : options.(phase).total_ntrials 
        pauseGame = false;
            
        if ~simulateSubj
            while starting == 0
                uiwait();
            end
        else
            gameCommands.State = 'empty';
        end
        
        
        if itrial == 1
            Clown.State = 'neutral';  
            if (strcmp(phase, 'training'))
                Clownladder.State = 'empty';
                 ExtraClown.State = 'empty';
                 Pool.State = 'empty'; 
            else
                Clownladder.State = 'ground';
                Pool.State = 'pool'; 
                ExtraClown.State = 'on';
            end
            Confetti.State = 'off';
        end      
        
        
        Buttonup.State = 'off';
        Buttondown.State = 'off';
        Parrot.State = 'neutral';
        pause(1);
        
        % 
        for clownState = 5:-1:1
            Clown.State = sprintf('clownSpotLight_%d',clownState);
            pause(0.01)
        end
        
        Parrot.State = 'parrot_1';
        pause(0.5)
       
        emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(itrial).voicelabel);
        phaseVect = strcmp({emotionvoices.phase}, phase);
        possibleFiles = [emotionVect & phaseVect];
        indexes = 1:length(possibleFiles);
        indexes = indexes(possibleFiles);
        
        if isempty(emotionvoices(indexes)) % extend structure with missing files and redo selection
            nLeft = length(emotionvoices);
%           tmp = emotionvoices(strcmp({emotionvoices.phase}, phase));
            tmp = classifyFiles(soundDir, phase);
            emotionvoices(nLeft + 1 : nLeft + length(tmp)) = tmp;
            clear tmp
            emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(itrial).voicelabel);
            phaseVect = strcmp({emotionvoices.phase}, phase);
            possibleFiles = [emotionVect & phaseVect];
            indexes = 1:length(possibleFiles);
            indexes = indexes(possibleFiles);
        end
    
        %this should store all names of possibleFiles 
        toPlay = randperm(length(emotionvoices(indexes)),1);
        [y, Fs] = audioread([soundDir emotionvoices(indexes(toPlay)).name]);
%         disp (emotionvoices(indexes(toPlay)).emotion)
        player = audioplayer(y, Fs);
        iter = 1;
        play(player)
        while true
            Parrot.State = ['parrot_' sprintf('%i', mod(iter, 2) + 1)];
            iter = iter + 1;
            pause(0.2);
            if ~isplaying(player)
                Parrot.State = 'neutral';
                break;
            end
        end
        tic();      
        if simulateSubj
            response.timestamp = now;
            response.response_time = toc;
            response.button_clicked = randi([0, 1], 1, 1); % default in case they click somewhere else
            response.correct = (response.button_clicked == expe.(phase).condition(itrial).congruent);
            response.filename = emotionvoices(indexes(toPlay)).name;
        else
            uiwait
            for clownState = 1:5
                Clown.State = sprintf('clownSpotLight_%d',clownState);
                pause(0.01)
            end
            Clown.State = expe.(phase).condition(itrial).facelabel;
            pause(0.6)
            
            Buttonup.State = 'on';
            Buttondown.State = 'on';
%             tic();
            uiwait();
            pause(0.5)
            Buttonup.State = 'off';
            Buttondown.State = 'off';

            response.filename = emotionvoices(indexes(toPlay)).name;
            response.correct = (response.button_clicked == expe.(phase).condition(itrial).congruent);
            if response.correct 
                for confettiState = 1:7
                    Confetti.State = sprintf('confetti_%d', confettiState);
                    pause(0.2)
                end
                Confetti.State = 'off';
                pause(0.3)
            else
                for shakeshake = 1:2
                    for parrotshake = 1:3
                        Parrot.State = sprintf('parrot_shake_%d', parrotshake);
                        pause(0.2)
                    end
                end
%                 
            end
            
            fprintf('Clicked button: %d\n', response.button_clicked);
            fprintf('Response time : %d ms\n', round(response.response_time*1000));
            fprintf('Response correct: %d\n\n', response.correct);
            
        end
        
        response.condition = expe.(phase).condition(itrial);
        response.cue = cue;
        results.(phase).(cue).responses(itrial) = response;

        
        save(options.res_filename, 'options', 'expe', 'results');
        
%       fprintf('Trial: %d\n', itrial);
        if expe.test.condition(itrial).clownladderNmove
            
            %itrial = 12; % 3, 7, 12
            if (strcmp(phase, 'test'))
                if ~ expe.test.condition(itrial).splash
                
                for iState = 1 : expe.test.condition(itrial).clownladderNmove
                    %                 fprintf('%i', ladderStep)
                    Clownladder.State = sprintf('clownladder_%d%c',mod(ladderStep, 9),'a');
                    pause (0.2)
                    Clownladder.State = sprintf('clownladder_%d%c',mod(ladderStep, 9),'b');
                    pause (0.2)
                    ladderStep = ladderStep + 1;
                end
            else
                
                    Clownladder.State = sprintf('clownladder_%d%c',mod(ladderStep, 9),'a');
                    pause (0.2)
                    Clownladder.State = sprintf('clownladder_%d%c',mod(ladderStep, 9),'b');
                    pause (0.2)
                    for ijump = 1:10
                        Clownladder.State = sprintf('clownladder_jump_%d', ijump);
                        pause(0.2)
                    end
                    Clownladder.State = 'empty';
                    ladder_jump11.State = 'ladder_jump_11';
                    clown_jump11.State = 'clown_jump_11';
                    for isplash = 1:3
                        Splash.State = sprintf('sssplash_%d', isplash);
                        pause(0.1)
                    end
                    pause (0.5)
                    Splash.State = 'empty';
                    ladder_jump11.State = 'empty';
                    clown_jump11.State = 'empty';
                    ExtraClown.State = 'empty';
                    Clownladder.State = 'ground';
                    ladderStep = 1;
                    for idrop = 1:2
                        Drops.State = sprintf('sssplashdrops_%d', idrop);
                        pause(0.2)
                    end
                    Drops.State = 'empty';
                end
            end
        end
        
        if itrial == options.(phase).total_ntrials
            gameCommands.Scale = 4; 
            gameCommands.State = 'finish';
            pause(2);
            close(gcf)
        end
        
        % remove just played file from list of possible sound files
        emotionvoices(indexes(toPlay)) = [];
        
    end

%% embedded game functions    
    
    function buttondownfcn(hObject, callbackdata)
        
        locClick = get(hObject,'CurrentPoint');
        
        if starting == 1
            
            response.timestamp = now();
            response.response_time = toc();
            response.button_clicked = 0; % default in case they click somewhere else
            
          if Clown.State == expe.(phase).condition(itrial).facelabel
          
            if (locClick(1) >= Buttonup.clickL) && (locClick(1) <= Buttonup.clickR) && ...
                    (locClick(2) >= Buttonup.clickD) && (locClick(2) <= Buttonup.clickU)
                Buttonup.State = 'press';
                response.button_clicked = 1;
                uiresume
            end
            
            if (locClick(1) >= Buttondown.clickL) && (locClick(1) <= Buttondown.clickR) && ...
                    (locClick(2) >= Buttondown.clickD) && (locClick(2) <= Buttondown.clickU)
                Buttondown.State = 'press'; 
                response.button_clicked = 0;
                uiresume
            end
            
            if (locClick(1) >= Pool.clickL) && (locClick(1) <= Pool.clickR) && ...
                    (locClick(2) >= Pool.clickD) && (locClick(2) <= Pool.clickU)
                uiresume;
                tic();
            end
          end
          
%             uiresume;
            
        else
             if (locClick(1) >= gameCommands.clickL) && (locClick(1) <= gameCommands.clickR) && ...
                (locClick(2) >= gameCommands.clickD) && (locClick(2) <= gameCommands.clickU)
             starting = 1;
             gameCommands.State = 'empty';
             pause (1)
             uiresume();
             end
        end
    end
   
    function keypressfcn(~,e)
        if strcmp(e.Key, 'control') % OR 'space'
            uiresume;
            tic();
        end
    end
  
    for iPath = 1 : length(pathsToAdd)
        rmpath(pathsToAdd{iPath});
    end

end




     
