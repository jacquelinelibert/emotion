% tmp = gcf;
% if ~isempty(tmp)
%     close(tmp)
% end

spriteKitPath = '/home/paolot/gitStuff/Beautiful/lib/SpriteKit';
addpath(spriteKitPath);
[G, bkg, confetti, clown] = EmotionGame_test;
LocConfetti = confetti.Location;

cycleNext(confetti)
confetti.Location = clown.Location;
% cycleNext(clown)
for iloop = 1:20
%     cycleNext(Clown)
%     confetti.Location = clown.Location - (iloop * 10)
    confetti.Location(2) = confetti.Location(2) - 10
%     cycleNext(confetti)
    cycleNext(clown)
%     clown.State = 'off'
    cycleNext(confetti)
    
    pause(.1)
end

confetti.Location = clown.Location;

rmpath(spriteKitPath);