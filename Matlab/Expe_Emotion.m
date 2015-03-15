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
    %if strncmp(name, '12-000-4372', 11)
        %spriteKitPath = '/home/paolot/gitStuff/Beautiful/lib/SpriteKit';
    spriteKitPath = 'C:/Users/Jacqueline Libert/Documents/GitHub/BeautifulFishy/lib/SpriteKit';
%     else
%         spriteKitPath = '/Users/laptopKno/Github/Beautiful/lib/Spritekit'; 
%     end
    addpath(spriteKitPath);
    
    %% Game Stuff 
    [G, bkg, Clown, Buttonup, Buttondown, gameCommands, Confetti, Parrot, Pool, Clownladder, Splash] = EmotionGame; 
    G.onMouseRelease = @buttondownfcn;

    %% Setup experiment 
    options.subject_name = subjectname;
    options.result_path = '../Results'; 
    options.result_prefix = 'emo_';
    res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
    options.res_filename = res_filename;

    results = struct ();
    if exist(res_filename, 'file')
        filesList = dir(fullfile(options.result_path, sprintf('*%s*.mat', options.subject_name)));
        options.subject_name = sprintf('%s_%d', options.subject_name, length(filesList)+1);
        res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
        options.res_filename = res_filename;
    end
    [expe, options] = building_conditions(options);

    response_accuracy = [];
    starting = 0;   

    soundDir = '../Stimuli/Emotion_normalized/';
    emotionvoices = classifyFiles(soundDir);
    % options = [];
    countladder = 1;
    % Add the response to the results structure
    % expe.( phase ).condition(itrial) = expe.( phase ).condition(itrial+1);

    %% ============= Main loop =============   
    for itrial = 1 : options.(phase).total_ntrials 
        
         
        if ~simulateSubj
            while starting == 0
                uiwait();
            end
        end    
        
        if itrial == 1
            Clown.State = 'clown_1'; % should be neutral? 
            Clownladder.State = 'ground';
            Confetti.State = 'off';
        end      
        
        Pool.State = 'pool';
        Buttonup.State = 'off';
        Buttondown.State = 'off';
        Parrot.State = 'neutral';
        pause(1);
        
        if itrial ~= 1
            for clownState = 5:-1:1
            Clown.State = sprintf('clown_%d',clownState);
            pause(0.01)
            end
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
        disp (emotionvoices(indexes(toPlay)).emotion)
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
        
        for clownState = 1:5
            Clown.State = sprintf('clown_%d',clownState);
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
            response.timestamp = now();
            response.response_time = toc();
            response.button_clicked = randi([0, 1], 1, 1); % default in case they click somewhere else
            response.correct = (response.button_clicked == expe.(phase).condition(itrial).congruent);
        end
        
        resp(itrial).response = response;
        resp(itrial).condition = expe.(phase).condition(itrial);
        resp(itrial).phase = phase;
        
        save (options.res_filename, 'options', 'expe', 'resp');
        
        if mod(itrial, 8) == 0
           for ijump = 1:11
               Clownladder.State = sprintf('clownladder_jump_%d', ijump);
               pause(0.2)
           end 
           for isplash = 1:4 
               Splash.State = sprintf('splash_%d', isplash);
               pause(0.2) 
           end
           pause (0.6)
           Splash.State = 'empty'; 
           Clownladder.State = 'ground';
        else
            Clownladder.State = sprintf('clownladder_%d%c',mod(itrial, 8),'a');
            pause (0.4)
            Clownladder.State = sprintf('clownladder_%d%c',mod(itrial, 8),'b');
        end

        if itrial == options.(phase).total_ntrials
            gameCommands.Scale = 2; 
            gameCommands.State = 'finish';
        end
        
        % remove just played file from list of possible sound files
        emotionvoices(indexes(toPlay)) = [];

        
    end

     
% response_accuracy = [response_accuracy, response.correct]; 
% resp = repmat(struct(response.button_clicked, 0), 1);



%% 
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
            fprintf('Trials: %d\n', itrial);
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




     
