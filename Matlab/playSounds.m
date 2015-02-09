soundDir = '../Stimuli/Emotion/Emotion_normalized/';
files = classifyFiles(soundDir);
options = [];
[expe, options] = building_conditions2(options);

phase = 'test';
options.(phase).total_ntrials
  
for iTrial = 1 : options.(phase).total_ntrials
    
    
    emotionVect = strcmp({files.emotion}, expe.test.condition(iTrial).voicelabel);
    phaseVect = strcmp({files.phase}, phase);
    possibleFiles = [emotionVect & phaseVect];
    
    
        emotionvoices(possibleFiles).name;
    
    
    [y, Fs] = audioread (emotionvoices(randVect(iFile)).name);
    player = audioplayer (y, Fs);
    playblocking (player); 
     
end
    
