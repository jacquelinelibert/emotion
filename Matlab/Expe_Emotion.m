function Expe_Emotion(varargin)
% 

    if nargin > 0
        simulateSubj = false;
        subjectname = varargin{1};
        phase = varargin{2};
    else
        simulateSubj = true;
        subjectname = 'random';
        phase = 'test';
    end
    
    [~, name] = system('hostname');
    testing_machine = 'lt159107.med.rug.nl';
    if strncmp(name, testing_machine, 19)
        spriteKitPath = '/Users/dbaskent/Experiments/Beautiful/lib/SpriteKit';
        options.result_path = '~/resultsBeautiful/Emotion'; 
    else
        if strncmp(name, '12-000-4372', 11)
            spriteKitPath = '/home/paolot/gitStuff/Beautiful/lib/SpriteKit';
            options.result_path = '/home/paolot/results/Emotion'; 
        else
           spriteKitPath = '/Users/laptopKno/Github/Beautiful/lib/SpriteKit';
           options.result_path = 'Users/laptopKno/Github/Results/Emotion/Result files';
%            spriteKitPath = 'C:/Users/Jacqueline Libert/Documents/GitHub/Beautiful/lib/SpriteKit';
%            options.result_path = 'C:/Users/Jacqueline Libert/Documents/Github/Results/Emotion/Result files';
        end
    end
    addpath(spriteKitPath);
    
    %% Game Stuff 
    [G, Clown, Buttonup, Buttondown, gameCommands, Confetti, Parrot, Pool, ...
        Clownladder, Splash, ladder_jump11, clown_jump11] = EmotionGame; 
    G.onMouseRelease = @buttondownfcn;

    %% Setup experiment 
    options.subject_name = subjectname;
    
    options.result_prefix = 'emo_';
    res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
    options.res_filename = res_filename;

    if exist(res_filename, 'file')
        filesList = dir(fullfile(options.result_path, sprintf('*%s*.mat', options.subject_name)));
        options.subject_name = sprintf('%s_%d', options.subject_name, length(filesList)+1);
        res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
        options.res_filename = res_filename;
    end
    [expe, options] = building_conditions(options);

    starting = 0;   

    soundDir = '../Stimuli/Emotion_normalized/';
    emotionvoices = classifyFiles(soundDir);
    ladderStep = 1;
    %% ============= Main loop =============   
    for itrial = 1 : options.(phase).total_ntrials 
        
            
        if ~simulateSubj
            while starting == 0
                uiwait();
            end
        else
            gameCommands.State = 'empty';
        end
        
        if itrial == 1
            Clown.State = 'neutral'; % should be neutral? 
            Clownladder.State = 'ground';
            Confetti.State = 'off';
        end      
        
        Pool.State = 'pool';
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
            tmp = classifyFiles(soundDir);
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
             
        
        % SpotLight
        for clownState = 1:5
            Clown.State = sprintf('clownSpotLight_%d',clownState);
            pause(0.01)
        end
        
        Clown.State = expe.(phase).condition(itrial).facelabel;
        pause(0.6)
        Buttonup.State = 'on';
        Buttondown.State = 'on';
        
        tic();
        if ~simulateSubj
            uiwait();
        else
            response.timestamp = now;
            response.response_time = toc;
            response.button_clicked = randi([0, 1], 1, 1); % default in case they click somewhere else
            response.correct = (response.button_clicked == expe.(phase).condition(itrial).congruent);
        end
        
        resp(itrial).response = response;
        resp(itrial).condition = expe.(phase).condition(itrial);
        resp(itrial).phase = phase;
        
        save(options.res_filename, 'options', 'expe', 'resp');
        
%         fprintf('Trial: %d\n', itrial);
        if expe.test.condition(itrial).clownladderNmove
            
            %itrial = 12; % 3, 7, 12
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
                Clownladder.State = 'ground';
                ladderStep = 1;
                for idrop = 1:2
                    Drops.State = sprintf('sssplashdrops_%d', idrop);
                    pause(0.2)
                end
            end
            
        end


        
        if itrial == options.(phase).total_ntrials
            gameCommands.Scale = 2; 
            gameCommands.State = 'finish';
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
            
            if (locClick(1) >= Buttonup.clickL) && (locClick(1) <= Buttonup.clickR) && ...
                    (locClick(2) >= Buttonup.clickD) && (locClick(2) <= Buttonup.clickU)
                Buttonup.State = 'press';
                response.button_clicked = 1;
            end
            
            if (locClick(1) >= Buttondown.clickL) && (locClick(1) <= Buttondown.clickR) && ...
                    (locClick(2) >= Buttondown.clickD) && (locClick(2) <= Buttondown.clickU)
                Buttondown.State = 'press'; 
                response.button_clicked = 0;
            end
            
            pause(0.5)
            
            response.correct = (response.button_clicked == expe.(phase).condition(itrial).congruent);
            
            Buttonup.State = 'off';
            Buttondown.State = 'off';
            
            if response.correct 
                % Clown.State = 'joyful';
                for confettiState = 1:7
                    Confetti.State = sprintf('confetti_%d', confettiState);
                    pause(0.2)
                end
                pause(0.3)
                Confetti.State = 'off';
            end
            
            fprintf('Clicked button: %d\n', response.button_clicked);
            fprintf('Response time : %d ms\n', round(response.response_time*1000));
            fprintf('Response correct: %d\n\n', response.correct);
            
            uiresume
            
            
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
   

    rmpath(spriteKitPath);

end




     
