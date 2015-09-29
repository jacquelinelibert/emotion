function  expe_run%(subject) 
    

    subName = 'name';

    cue = {'normalized', 'intact'};
    cue = cue(randperm(length(cue)));
    for icue = 1 : length(cue);
        phase = {'training', 'test'};
        for iphase = 1 : length(phase)
            Expe_Emotion(subName, phase{iphase}, cue{icue});
        end
    end
end
