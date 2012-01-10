function rabiAmpSequence(makePlot)

if ~exist('makePlot', 'var')
    makePlot = true;
end

basename = 'Rabi';
fixedPt = 6000;
cycleLength = 10000;
numsteps = 81;
nbrRepeats = 1;
stepsize = 200;

% load config parameters from file
load(getpref('qlab','pulseParamsBundleFile'), 'Ts', 'delays', 'measDelay', 'bufferDelays', 'bufferResets', 'bufferPaddings', 'offsets', 'piAmps', 'pi2Amps', 'sigmas', 'pulseTypes', 'deltas', 'buffers', 'pulseLengths');
% if using SSB, uncomment the following line
Ts('12') = eye(2);
pg = PatternGen('dPiAmp', piAmps('q1'), 'dPiOn2Amp', pi2Amps('q1'), 'dSigma', sigmas('q1'), 'dPulseType', pulseTypes('q1'), 'dDelta', deltas('q1'), 'correctionT', Ts('12'), 'dBuffer', buffers('q1'), 'dPulseLength', pulseLengths('q1'), 'cycleLength', cycleLength);

amps = -((numsteps-1)/2)*stepsize:stepsize:((numsteps-1)/2)*stepsize;
%amps = 0:stepsize:(numsteps-1)*stepsize;
patseq = {{pg.pulse('Xtheta', 'amp', amps)}};
calseq = {};

compileSequenceSSB12(basename, pg, patseq, calseq, numsteps, nbrRepeats, fixedPt, cycleLength, makePlot);

end
