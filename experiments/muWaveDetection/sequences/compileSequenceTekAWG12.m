function compileSequenceTekAWG12(basename, pg, patseq, calseq, numsteps, nbrRepeats, fixedPt, cycleLength, makePlot, plotIdx, seqSuffix)

if ~exist('plotIdx', 'var')
    plotIdx = 20;
end

if ~exist('seqSuffix', 'var')
    seqSuffix = '';
end
% load config parameters from file
params = jsonlab.loadjson(getpref('qlab', 'pulseParamsBundleFile'));
params.measDelay = -64;
ChParams = params.TekAWG12;

nbrPatterns = length(patseq)*nbrRepeats;
calPatterns = length(calseq)*nbrRepeats;
segments = nbrPatterns*numsteps + calPatterns;
fprintf('Number of sequences: %i\n', segments);

% pre-allocate space
ch1 = zeros(segments, cycleLength);
ch2 = ch1; ch3 = ch1; ch4 = ch1;
ch1m1 = ch1; ch1m2 = ch1; ch2m1 = ch1; ch2m2 = ch1;
ch3m1 = ch1; ch3m2 = ch1; ch4m1 = ch1; ch4m2 = ch1;

for n = 1:nbrPatterns;
    for stepct = 1:numsteps
        [patx paty] = pg.getPatternSeq(patseq{floor((n-1)/nbrRepeats)+1}, stepct, ChParams.delay, fixedPt);

        ch1((n-1)*stepct + stepct, :) = patx + ChParams.offset;
        ch2((n-1)*stepct + stepct, :) = paty + ChParams.offset;
        ch3m1((n-1)*stepct + stepct, :) = pg.bufferPulse(patx, paty, 0, ChParams.bufferPadding, ChParams.bufferReset, ChParams.bufferDelay);
    end
end

for n = 1:calPatterns;
    [patx paty] = pg.getPatternSeq(calseq{floor((n-1)/nbrRepeats)+1}, 1, ChParams.delay, fixedPt);

    ch1(nbrPatterns*numsteps + n, :) = patx + ChParams.offset;
    ch2(nbrPatterns*numsteps + n, :) = paty + ChParams.offset;
    ch3m1(nbrPatterns*numsteps + n, :) = pg.bufferPulse(patx, paty, 0, ChParams.bufferPadding, ChParams.bufferReset, ChParams.bufferDelay);
end

% trigger at beginning of measurement pulse
% measure from (6000:9000)
measLength =9600;
measSeq = {pg.pulse('M', 'width', measLength)};
ch1m1 = repmat(pg.makePattern([], fixedPt-500, ones(100,1), cycleLength), 1, segments)';
ch1m2 = repmat(int32(pg.getPatternSeq(measSeq, 1, params.measDelay, fixedPt+measLength)), 1, segments)';


if makePlot
    myn = plotIdx;
    figure
    plot(ch1(myn,:))
    hold on
    plot(ch2(myn,:), 'r')
    plot(5000*ch3m1(myn,:), 'k')
    plot(5000*ch1m1(myn,:),'.')
    plot(5000*ch1m2(myn,:), 'g')
    grid on
    hold off
end

save('testRB.mat', 'ch1', 'ch2')

% add offsets to unused channels
ch3 = ch3 + params.TekAWG34.offset;
ch4 = ch4 + params.TekAWG34.offset;

% make TekAWG file
strippedBasename = basename;
basename = [basename 'TekAWG12' seqSuffix];
options = struct('m21_high', 2.0, 'm41_high', 2.0);
TekPattern.exportTekSequence(tempdir, basename, ch1, ch1m1, ch1m2, ch2, ch2m1, ch2m2, ch3, ch3m1, ch3m2, ch4, ch4m1, ch4m2, options);
disp('Moving AWG file to destination');
if ~exist(['U:\AWG\' strippedBasename '\'], 'dir')
    mkdir(['U:\AWG\' strippedBasename '\']);
end
pathAWG = ['U:\AWG\' strippedBasename '\' basename '.awg'];
movefile([tempdir basename '.awg'], pathAWG);

end