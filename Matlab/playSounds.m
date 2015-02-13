<<<<<<< HEAD
soundDir = '../Stimuli/Emotion/Emotion_normalized/';
emotionvoices = classifyFiles(soundDir);
options = [];
[expe, options] = building_conditions2(options);

phase = 'test';
options.(phase).total_ntrials
  
for iTrial = 1 : options.(phase).total_ntrials
    
    emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(iTrial).voicelabel);
    phaseVect = strcmp({emotionvoices.phase}, phase);
    possibleFiles = [emotionVect & phaseVect];
    indexes = 1:length(possibleFiles);
    indexes = indexes(possibleFiles);
    %this works
    %this should store all names of possibleFiles 
    toPlay = randperm(length(emotionvoices(indexes)),1);
    
    [y, Fs] = audioread(emotionvoices(indexes(toPlay)).name);
    disp (emotionvoices(indexes(toPlay)).name)
    player = audioplayer (y, Fs);
    playblocking (player); 
    
    % remove just played file from list of possible sound files
    emotionvoices(indexes(toPlay)) = [];
    
end
    
=======

soundDir = '../Stimuli/Emotion/Emotion_normalized/';
emotionvoices = classifyFiles(soundDir);
options = [];
[expe, options] = building_conditions2(options);

phase = 'test';
options.(phase).total_ntrials
  
for iTrial = 1 : options.(phase).total_ntrials
    
    emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(iTrial).voicelabel);
    phaseVect = strcmp({emotionvoices.phase}, phase);
    possibleFiles = [emotionVect & phaseVect];
    indexes = 1:length(possibleFiles);
    indexes = indexes(possibleFiles);
    %this works
    %this should store all names of possibleFiles 
    if isempty(indexes)
        break;
    end
    toPlay = randperm(length(emotionvoices(indexes)),1);
    
    [y, Fs] = audioread([soundDir emotionvoices(indexes(toPlay)).name]);
    fprintf('%s %s \n', emotionvoices(indexes(toPlay)).name, expe.(phase).condition(iTrial).voicelabel);
    player = audioplayer (y, Fs);
    playblocking (player); 
    
    
    
    % remove just played file from list of possible sound files
    emotionvoices(indexes(toPlay)) = [];
    
end
    
>>>>>>> 2f13273f84154e0fe5f581382b5f751412c581b3
