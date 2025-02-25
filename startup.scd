var addr = NetAddr.new("127.0.0.1", 57100);
OSCFunc({
	arg msg, time;
	var latency = time - Main.elapsedTime;
	addr.sendBundle(latency, msg)
},'dirt/play').fix;
Server.default.options.numOutputBusChannels = 12;
Server.default.options.memSize = 8192 * 128;
Server.default.options.bindAddress = "0.0.0.0";
Server.default.options.numWireBufs = 64;
Server.default.options.maxNodes = 1024 * 128;
Server.default.latency = 0.1;
// シンセの定義
SynthDef("SinOscSynthBend", {
	arg out, sustain=1, decay=0, pan=0, freq=110, accelerate=0, slide=0, sustainpedal=0.5, vibratoFreq=10, vibratoDepth=0, synthrev=0;
	var fglide, detune, sound, sig1, sig2, env, bendSustain;
	bendSustain = sustainpedal;
	detune = 1.0;
	fglide = EnvGen.ar(Env.perc(0.05, 0.3, 1, \lin), timeScale:bendSustain) * (-1*slide/4) + 1;
	freq = freq * fglide * Line.kr(1, 1+accelerate, bendSustain);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	sig1 = SinOsc.ar(freq).dup;
	sig2 = SinOsc.ar(freq * detune).dup;
	sound = (sig1 + sig2) * 0.5;
	env = EnvGen.ar(Env.linen(0.01, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	env = if(
		synthrev<0.1,
		env,
		(1-env)
	);
	OffsetOut.ar(out, sound*env);
}).add;
SynthDef("SinOscSynthBend2", {
	arg out, sustain=1, decay=0, pan=0, freq=110, accelerate=0, slide=0, sustainpedal=0.5, vibratoFreq=10, vibratoDepth=0;
	var fglide, detune, sound, sig1, sig2, env, bendSustain, attrel;
	bendSustain = sustainpedal;
	attrel = (sustain/2).clip(0,0.005);
	// detune = 1.001;
	detune = 1.0;
	fglide = EnvGen.ar(Env.perc(0.05, 0.3, 1, \lin), timeScale:bendSustain) * (-1*slide/4) + 1;
	freq = freq * fglide * Line.kr(1, 1+accelerate, bendSustain);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	sig1 = SinOsc.ar(freq).dup;
	sig2 = SinOsc.ar(freq * detune).dup;
	sound = (sig1 + sig2) * 0.5;
	env = EnvGen.ar(Env.linen(attrel, sustain-(2*attrel), attrel), doneAction:2);
	//env = EnvGen.ar(Env.pairs([[0,0],[0.03,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	OffsetOut.ar(out, sound*env);
}).add;
SynthDef("SinOscSynthBend3", {
	arg out, sustain=1, decay=0, pan=0, freq=110, accelerate=0, slide=0, sustainpedal=0.5, vibratoFreq=10, vibratoDepth=0;
	var fglide, detune, sound, sig1, sig2, env, bendSustain;
	bendSustain = sustainpedal;
	detune = 1.0;
	fglide = EnvGen.ar(Env.perc(0.05, 0.3, 1, \lin), timeScale:bendSustain) * (-1*slide/4) + 1;
	freq = freq * fglide * Line.kr(1, 1+accelerate, bendSustain);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	sig1 = SinOsc.ar(freq).dup;
	sig2 = SinOsc.ar(freq * detune).dup;
	sound = (sig1 + sig2) * 0.5;
	env = EnvGen.ar(Env.linen(0.6, 0, 0.003, 1, 3.5), timeScale:sustain, doneAction:2);
	OffsetOut.ar(out, sound*env);
}).add;

SynthDef("FastSinSynth", {
	arg out, sustain=1, decay=0, pan=0, freq=110, accelerate=0, vibratoFreq=10, vibratoDepth=0;
	var fglide, detune, sound, sig1, sig2, env, parFreq;
	detune = 1.0;
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	sig1 = SinOsc.ar(freq).dup;
	sig2 = SinOsc.ar(freq * detune).dup * 0.1;
	sound = (sig1 + sig2) * 0.5;
	parFreq = 0.8 + EnvGen.ar(Env.linen(0, 0, 0.6, 10, -7), timeScale:sustain);
	// pan = EnvGen.ar(Env.linen(0, 0, 0.6, (pan), 1), timeScale:sustain); // pan slide
	sound = sound*LFPar.kr(parFreq); // tremoro
	// panning
	// sound = Pan2.ar(sound, FSinOsc.kr(1.43));
	env = EnvGen.ar(Env.linen(0, 0, 0.6, 1, -2), timeScale:sustain, doneAction:2);
	OffsetOut.ar(out, sound*env);
}).add;

SynthDef("superhammondBend", {
	arg out, sustain=1, decay=0, pan, freq, vibrato=0.5, vrate=7, voice=0, perc=0, percf=2, accelerate=0, slide=0, sustainpedal=0.5;
	var freqs, amps, sound, click, env, ampscale, attrel, fglide, bendSustain;
	bendSustain = sustainpedal;
	// attrel = (sustain/2).clip(0,0.005);
	// env = EnvGen.ar(Env.linen(attrel, sustain-(2*attrel), attrel), doneAction:2);
	env = EnvGen.ar(Env.linen(0.1, sustain, 0.1, sustain), doneAction:2);
	fglide = EnvGen.ar(Env.perc(0.05, 0.3, 1, \lin), timeScale:bendSustain) * (-1*slide/4) + 1;
	freq = freq * fglide * Line.kr(1, 1+accelerate, bendSustain);
	freqs = [0.5, 1.4988, 1, 2, 2.9976, 4, 5.0409, 5.9953, 8, 1.001] * freq;
	freqs = 2**(freqs < 63) * freqs; // fold up bottom register
	freqs = freqs / (2**(freqs > 6000)); // fold down high harmonics
	freqs = freqs / (2**(freqs > 6000)); // do it again for the really high notes
	amps = SelectX.kr(voice, #[
		[1, 4, 5, 4, 3, 1, 0, 0, 0], // 0: bass violin 16'
		[0, 0, 8, 0, 4, 0, 0, 0, 0], // 1: tibia 8'
		[0, 7, 8, 1, 2, 0, 0, 0, 0], // 2: bassoon 8'
		[0, 0, 7, 8, 8, 8, 8, 7, 2], // 3: french trumpet 8'
		[4, 0, 5, 5, 4, 5, 3, 3, 6], // 4: string ensemble
		[8, 8, 5, 3, 2, 4, 5, 8, 8], // 5: Blues
		[8, 8, 8, 0 ,0, 0, 0, 0, 3], // 6: Jazz 1
		[8, 8, 8, 8, 8, 8, 8, 8, 8], // 7: Full Shout
		[8, 0, 0, 0, 0, 0, 8, 8, 8], // 8: Bro' Jack
		[0, 0, 8, 8, 0, 0, 0, 0, 0]  // 9: Jazz 2
	]);
	amps = amps - [0, 0, 0, 0, 0, 0, 0.5, 1, 1.5]; // damp brilliance a bit
	amps = 2**(amps-8);
	click = WhiteNoise.ar(1) * XLine.ar(1,1e-6, 0.1);
	sound = 0.5 * Mix.ar( SinOsc.ar(freqs, (2pi ! 9).rand, amps/amps.sum) );
	// オルガンサウンド特有のアタック音が欲しい場合
	//sound = 0.5 * Mix.ar( SinOsc.ar(freqs*(2*click+1), (2pi ! 9).rand, amps/amps.sum) );
	sound = perc * 0.5 * SinOsc.ar(freq*percf, 2pi.rand) * XLine.ar(1,1e-6,2*decay+1) + sound;
	sound = sound + BAllPass.ar(sound, 1000*LFTri.kr(vrate,0,vibrato/2,1));
	// panning
	// sound = Pan2.ar(sound, FSinOsc.kr(1.43));
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;
SynthDef(\superhammondSc, {|out, amp=1, decay=0, pan, freq, vibrato=0.5, vrate=7,
	voice=0, perc=0, percf=2, accelerate=0, speed=1, hpf=700, tremolorate = 0.2, tremolodepth = 0.2, reverb=0, lpf=5000|
	var freqs, amps, sound, click, env, ampscale, attrel, tremolowave;
	// attrel = (sustain/2).clip(0,0.005);
	// freq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
	freqs = [0.5, 1.4988, 1, 2, 2.9976, 4, 5.0409, 5.9953, 8] * freq;
	freqs = 2**(freqs < 63) * freqs; // fold up bottom register
	freqs = freqs / (2**(freqs > 6000)); // fold down high harmonics
	freqs = freqs / (2**(freqs > 6000)); // do it again for the really high notes
	amps = SelectX.kr(voice, #[
		[1, 4, 5, 4, 3, 1, 0, 0, 0], // 0: bass violin 16'
		[0, 0, 8, 0, 4, 0, 0, 0, 0], // 1: tibia 8'
		[0, 7, 8, 1, 2, 0, 0, 0, 0], // 2: bassoon 8'
		[0, 0, 7, 8, 8, 8, 8, 7, 2], // 3: french trumpet 8'
		[4, 0, 5, 5, 4, 5, 3, 3, 6], // 4: string ensemble
		[8, 8, 5, 3, 2, 4, 5, 8, 8], // 5: Blues
		[8, 8, 8, 0 ,0, 0, 0, 0, 3], // 6: Jazz 1
		[8, 8, 8, 8, 8, 8, 8, 8, 8], // 7: Full Shout
		[8, 0, 0, 0, 0, 0, 8, 8, 8], // 8: Bro' Jack
		[0, 0, 8, 8, 0, 0, 0, 0, 0]  // 9: Jazz 2
	]);
	amps = amps - [0, 0, 0, 0, 0, 0, 0.5, 1, 1.5]; // damp brilliance a bit
	amps = 2**(amps-8);
	click = WhiteNoise.ar(1) * XLine.ar(1,1e-6, 0.1);
	sound = 0.5 * Mix.ar( SinOsc.ar(freqs*(2*click+1), (2pi ! 9).rand, amps/amps.sum) );
	sound = perc * 0.5 * SinOsc.ar(freq*percf, 2pi.rand) * XLine.ar(1,1e-6,2*decay+1) + sound;
	sound = sound + BAllPass.ar(sound, 1000*LFTri.kr(vrate,0,vibrato/2,1));
	sound = HPF.ar(sound, hpf);
	tremolodepth = tremolodepth.clip(0, 1) * 0.5;
	tremolowave = (1 - tremolodepth) + SinOsc.ar(tremolorate, 0.5pi, tremolodepth);
	sound = sound * tremolowave;
	sound = LPF.ar(sound, lpf);
	sound = FreeVerb.ar(sound, reverb, 0.5);
	Out.ar(out, amp*sound!2);
}, [0, 1, 1, 1, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]).add;
SynthDef("toumeiSynth", {
	arg out, sustain=1, decay=0, pan, freq, vibrato=0.5, vrate=7, voice=0, perc=0, percf=2, accelerate=0, slide=0, sustainpedal=0.5;
	var freqs, amps, sound, click, env, ampscale, attrel, fglide, bendSustain;
	bendSustain = sustainpedal;
	attrel = (sustain/2).clip(0,0.005);
	// env = EnvGen.ar(Env.linen(0.1, 1, 0.2, 1, 6), timeScale:sustain, doneAction:2);
	env = EnvGen.ar(Env.linen(attrel, sustain-(2*attrel), attrel), doneAction:2);
	fglide = EnvGen.ar(Env.perc(0.05, 0.3, 1, \lin), timeScale:bendSustain) * (-1*slide/4) + 1;
	freq = freq * fglide * Line.kr(1, 1+accelerate, bendSustain);
	freqs = [0.5, 1.4988, 1, 2, 2.9976, 4, 5.0409, 5.9953, 8, 1.001] * freq;
	freqs = 2**(freqs < 63) * freqs; // fold up bottom register
	freqs = freqs / (2**(freqs > 6000)); // fold down high harmonics
	freqs = freqs / (2**(freqs > 6000)); // do it again for the really high notes
	amps = SelectX.kr(voice, #[
		[1, 4, 5, 4, 3, 1, 0, 0, 0], // 0: bass violin 16'
		[0, 0, 8, 0, 4, 0, 0, 0, 0], // 1: tibia 8'
		[0, 7, 8, 1, 2, 0, 0, 0, 0], // 2: bassoon 8'
		[0, 0, 7, 8, 8, 8, 8, 7, 2], // 3: french trumpet 8'
		[4, 0, 5, 5, 4, 5, 3, 3, 6], // 4: string ensemble
		[8, 8, 5, 3, 2, 4, 5, 8, 8], // 5: Blues
		[8, 8, 8, 0 ,0, 0, 0, 0, 3], // 6: Jazz 1
		[8, 8, 8, 8, 8, 8, 8, 8, 8], // 7: Full Shout
		[8, 0, 0, 0, 0, 0, 8, 8, 8], // 8: Bro' Jack
		[0, 0, 8, 8, 0, 0, 0, 0, 0]  // 9: Jazz 2
	]);
	amps = amps - [0, 0, 0, 0, 0, 0, 0.5, 1, 1.5]; // damp brilliance a bit
	amps = 2**(amps-8);
	click = WhiteNoise.ar(1) * XLine.ar(1,1e-6, 0.1);
	sound = 0.5 * Mix.ar( SinOsc.ar(freqs, (2pi ! 9).rand, amps/amps.sum) );
	// sound = perc * 0.5 * SinOsc.ar(freq*percf, 2pi.rand) * XLine.ar(1,1e-6,2*decay+1) + sound;
	// sound = sound + BAllPass.ar(sound, 1000*LFTri.kr(vrate,0,vibrato/2,1));
	Out.ar(out, sound*env);
}).add;

SynthDef("bassSynth", {
	arg out, sustain=1, decay=0, pan, freq, vibrato=0.5, vrate=7, voice=0, perc=0, percf=2, accelerate=0, slide=0, sustainpedal=0.5;
	var freqs, amps, sound, click, env, ampscale, attrel, fglide, bendSustain;
	bendSustain = sustainpedal;
	attrel = (sustain/2).clip(0,0.005);
	env = EnvGen.ar(Env.linen(0.003, 0, 0.6, 1, 6), timeScale:sustain, doneAction:2);
	fglide = EnvGen.ar(Env.perc(0.05, 0.3, 1, \lin), timeScale:bendSustain) * (-1*slide/4) + 1;
	freq = freq * fglide * Line.kr(1, 1+accelerate, bendSustain);
	freqs = [0.5, 1.4988, 1, 2, 2.9976, 4, 5.0409, 5.9953, 8, 1.001] * freq;
	freqs = 2**(freqs < 63) * freqs; // fold up bottom register
	freqs = freqs / (2**(freqs > 6000)); // fold down high harmonics
	freqs = freqs / (2**(freqs > 6000)); // do it again for the really high notes
	amps = SelectX.kr(voice, #[
		[1, 4, 5, 4, 3, 1, 0, 0, 0], // 0: bass violin 16'
	]);
	amps = amps - [0, 0, 0, 0, 0, 0, 0.5, 1, 1.5]; // damp brilliance a bit
	amps = 2**(amps-8);
	click = WhiteNoise.ar(1) * XLine.ar(1,1e-6, 0.1);
	sound = 0.5 * Mix.ar( SinOsc.ar(freqs, (2pi ! 9).rand, amps/amps.sum) );
	// sound = perc * 0.5 * SinOsc.ar(freq*percf, 2pi.rand) * XLine.ar(1,1e-6,2*decay+1) + sound;
	// sound = sound + BAllPass.ar(sound, 1000*LFTri.kr(vrate,0,vibrato/2,1));
	// panning
	// sound = Pan2.ar(sound, FSinOsc.kr(1.43));
	Out.ar(out, sound*env);
}).add;

SynthDef("MyMoog", {
	arg out, freq = 110, sustain = 1, pan = 0.5, pitch1=4.0, accelerate=0, slide=0, sustainpedal=0.5;
	var detune, sig1, sig2, env, sound, fglide, bendSustain;
	bendSustain = sustainpedal;
	fglide = EnvGen.ar(Env.perc(0.05, 0.3, 1, \lin), timeScale:bendSustain) * (-1*slide/4) + 1;
	freq = freq * fglide * Line.kr(1, 1+accelerate, bendSustain);
	detune = 1.005;
	sig1 = MoogFF.ar(
		Pulse.ar(freq, LFNoise1.ar(1.0,0.3,0.4)),
		freq*pitch1, 3
	).dup;
	sig2 = MoogFF.ar(
		Pulse.ar(freq, LFNoise1.ar(1.0,0.2,0.4)),
		freq*pitch1*1.5, 3
	).dup;
	sound = (sig1 + sig2) * 1;
	env = EnvGen.ar(Env.linen(0.001, 0, 0.6, 1, -5), timeScale:sustain, doneAction:2);
	OffsetOut.ar(out, sound*env);
}).add;

SynthDef(\zure, {|out, sustain=1, pan, accelerate, freq, decay=0, slide=1, detune=1 |
	// var env = EnvGen.ar(Env.linen(0.0001, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	var env = EnvGen.ar(Env.linen(0, 0, 0.6, 1, -2), timeScale:sustain, doneAction:2);
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain);
	var sound = VarSaw.ar(basefreq, 0, Line.ar(0,0.5,sustain*20/slide));
	var sound2 = VarSaw.ar(basefreq*(detune/100+1), 0, Line.ar(0,0.5,sustain*20/slide));
	var sound3 = VarSaw.ar(basefreq*(-1*detune/100+1), 0, Line.ar(0,0.5,sustain*20/slide));
	var lpfEnv = 800 + EnvGen.ar(Env.linen(0, 0, 0.5, 1000, -30), timeScale:sustain);
	sound = sound - DelayN.ar(sound2,0.2, Line.ar(0,1,5*sustain/slide)/basefreq)
	+ DelayN.ar(sound3,0.2, Line.ar(0,1,20*sustain/slide)/basefreq);
	sound = LPF.ar(sound, lpfEnv);
	Out.ar(out, sound*0.5*env);
}).add;
SynthDef(\zure2, {|out, sustain=1, pan, accelerate, freq, decay=0, slide=1, detune=0.008 |
	var attrel = (sustain/2).clip(0,0.005);
	var env = EnvGen.ar(Env.linen(attrel, sustain-(2*attrel), attrel), doneAction:2);
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain);
	var sound = VarSaw.ar(basefreq, 0, Line.ar(0,0.5,sustain*20/slide));
	var sound2 = VarSaw.ar(basefreq*(detune/100+1), 0, Line.ar(0,0.5,sustain*20/slide));
	var sound3 = VarSaw.ar(basefreq*(-1*detune/100+1), 0, Line.ar(0,0.5,sustain*20/slide));
	sound = sound - DelayN.ar(sound2,0.2, Line.ar(0,1,5*sustain/slide)/basefreq)
	+ DelayN.ar(sound3,0.2, Line.ar(0,1,20*sustain/slide)/basefreq);
	Out.ar(out, sound*0.5*env);
}).add;
SynthDef(\insects, {arg out, pan=0, freq=110, sustain=1;
	var modulator, mod1, mod2, mod3, env, f;
	f = 1.43 * (freq / 1108.731);
	modulator = LFSaw.ar(f, 1, 0.5, 0.5);
	mod2 = (modulator * 40.6 * 2pi).cos.squared;
	mod3 = modulator * 3147;
	mod3 = (mod3 * 2pi).cos + ((mod3 * 2 * 2pi).cos * 0.3);
	mod1 = ((Wrap.ar(modulator.min(0.1714) * 5.84) - 0.5).squared * (-4) + 1) * (mod2 * mod3);
	mod1 = (mod1 * 0.1)!2;
	env = EnvGen.ar(Env.linen(0, 0, 1, 1, 10), timeScale: 1/f, doneAction:2);
	OffsetOut.ar(out, mod1*env);
}).add;
SynthDef(\turtledove, { arg out, pan=0, sustain=1, freq=410, slide=0.1, pitch1=0.1, vibratoDepth=0, vibratoFreq=50;
	var dt, n, mul, t, u, chain, env, real=0.5, imag=0;
	env = EnvGen.ar(Env.linen(0.04, 0, 1, 1, 5), timeScale: sustain, doneAction:2);
	freq = freq*(1-slide) + EnvGen.ar(Env.linen(0, 0, 1, freq*slide, 5), timeScale:sustain);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	u = 0;
	u = u + (SinOsc.ar(freq*1.05) * pitch1*0.1);
	u = u + (SinOsc.ar(freq*1) * 0.1);
	OffsetOut.ar(out, u*env);
}).add;
// ハシブトガラス
SynthDef(\jungleCrow, { arg out, pan=0, amp=0.1, variation=0.9, sustain=1, vibratoDepth=0;
	var dt, n, freq, mul, t, u, chain, env, vibratoFreq=70, freqDiffRate=0.1, real=0.5, imag=0;
	env = EnvGen.ar(Env.linen(0.04, 0, 1, 1, 8), timeScale: sustain, doneAction:2);
	freq = 1000 + Rand(0, 10);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	freq = freq*(1-freqDiffRate) + EnvGen.ar(Env.linen(0, 0, 1, freq*freqDiffRate, 7), timeScale:sustain);
	u = 0;
	u = u + (SinOsc.ar(freq*2) * 0.15);
	u = u + (SinOsc.ar(freq*1.95) * 0.07);
	u = u + (SinOsc.ar(freq*1.5) * 0.13);
	u = u + (SinOsc.ar(freq*1.45) * 0.09);
	u = u + (SinOsc.ar(freq*1.04) * 0.07);
	u = u + (SinOsc.ar(freq*1) * 0.09);
	OffsetOut.ar(out, u*env);
}).add;

SynthDef("noiseman", {
	arg out, sustain=1, decay=0, pan=0, freq=110, accelerate=0, slide=0, sustainpedal=0.5, vibratoFreq=10, vibratoDepth=0;
	var fglide, detune, sound, env, bendSustain;
	bendSustain = sustainpedal;
	// detune = 1.001;
	detune = 1.0;
	fglide = EnvGen.ar(Env.perc(0.05, 0.3, 1, \lin), timeScale:bendSustain) * (-1*slide/4) + 1;
	freq = freq * fglide * Line.kr(1, 1+accelerate, bendSustain);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	sound = PinkNoise.ar(1!2);
	sound = BPF.ar(sound, freq) * 2;
	env = EnvGen.ar(Env.linen(0.01, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	//env = EnvGen.ar(Env.pairs([[0,0],[0.03,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -1), timeScale:sustain, doneAction:2);
	OffsetOut.ar(out, sound*env);
}).add;

SynthDef(\nailClapper,{
	arg out, decay=0, pan=0, freq=110, sustain=0.1, synthrev=0;
	var sig, env;
	sig=PinkNoise.ar(1!2);
	sig=HPF.ar(sig,freq);
	env = EnvGen.ar(Env.linen(0, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	env = if(
		synthrev<0.1,
		env,
		(1-env)
	);
	OffsetOut.ar(out, sig*env);
}).add;
SynthDef(\branch, {|out, rate=1, sustain=1, pan, n, delay=1, pitch1=1 |
	var env, sound;
	var spr = 0.005 * delay;
	env = EnvGen.ar(Env.linen(0, 0, 0.2, 1, -10), timeScale:Rand(0.03,0.11), doneAction:2);
	sound = BPF.ar(LPF.ar(WhiteNoise.ar(1), 7500*pitch1), 1500*pitch1);
	sound = Mix.arFill(4, {arg i; sound * 0.5 * EnvGen.ar(Env.new([0,0,1,0],[spr*(i**(0.clip(0,5)+1)),0,0.04/rate]))});
	sound=sound+((Rand(0.4,0.8))*DelayN.ar(sound, sustain, sustain*Rand(0.05,0.2)));
	sound=LPF.ar(sound, Rand(1000,4000));
	sound=sound+(0.1*FreeVerb.ar(sound, 1, 0.8, 0.2));
	sound=sound*10;
	Out.ar(out, sound*env)
}).add;
SynthDef(\branchStatic, {|out, rate=1, sustain=1, pan, n, delay=1, pitch1=1 |
	var env, sound;
	var spr = 0.005 * delay;
	env = EnvGen.ar(Env.linen(0, 0, 0.2, 1, -10), timeScale:0.1, doneAction:2);
	sound = BPF.ar(LPF.ar(WhiteNoise.ar(1), 7500*pitch1), 1500*pitch1);
	sound = Mix.arFill(4, {arg i; sound * 0.5 * EnvGen.ar(Env.new([0,0,1,0],[spr*(i**(0.clip(0,5)+1)),0,0.04/rate]))});
	sound=sound+(0.4*DelayN.ar(sound, sustain, sustain*0.1));
	sound=LPF.ar(sound, 4000);
	sound=sound+(0.1*FreeVerb.ar(sound, 1, 0.8, 0.2));
	sound=sound*40;
	Out.ar(out, sound*env)
}).add;

SynthDef("rustling", {
	arg out, sustain=1, pan;
	var sig, grazing, pebble, branch, footsteps, env, pitchShift;
	env = EnvGen.ar(Env.linen(0.2, 0, 0.25, 1, -5), timeScale:sustain, doneAction:2);

	pitchShift=[0.4,0.5,0.6,1.0].choose;
	grazing=PinkNoise.ar(1);
	grazing=if(
		pitchShift==1.0,
		grazing*0.85,
		PitchShift.ar(grazing, 0.1, pitchShift, 0, 0);
	);
	grazing=LPF.ar(grazing,2000);
	grazing=HPF.ar(grazing,8000);
	grazing=grazing*3;

	pebble=LPF.ar(GrayNoise.ar(1), 1000);
	pebble=LPF.ar(pebble,3000);
	pebble=HPF.ar(pebble,4000);
	pebble=pebble*4;
	pebble=pebble*(EnvGen.ar(Env.linen(sustain*0.6, 1, 0.1, 1)));

	branch=BPF.ar(LPF.ar(WhiteNoise.ar(100), 7500), 1500);
	branch = Mix.arFill(4, {arg i; branch * 0.5 * EnvGen.ar(Env.new([0,0,1,0],[0.005*(i**(0.clip(0,5)+1)),0,0.04]))});
	branch=branch*(EnvGen.ar(Env.linen(0, 0, 0.2, 1, -10), timeScale:Rand(0.06,0.11)));
	branch=DelayN.ar(branch, sustain, sustain*Rand(0.15,0.5));
	branch=branch+((Rand(0.4,0.8))*DelayN.ar(branch, sustain, sustain*Rand(0.1,0.7)));
	branch=LPF.ar(branch, Rand(3000,5000));
	branch=branch+(0.1*FreeVerb.ar(branch, 1, 0.8, 0.2));
	branch=branch*0.017;

	footsteps=SinOsc.ar([65.406,69.296]).dup;
	footsteps=HPF.ar(footsteps, 300);
	footsteps=footsteps*(EnvGen.ar(Env.linen(0, 0, 0.2, 1, -5), timeScale:Rand(0.1,0.2)));
	footsteps=DelayN.ar(footsteps, sustain, sustain*0.1);
	footsteps=footsteps*0.29;

	sig=(grazing*(Rand(0.0,1.0)))+(pebble*Rand(0.5,1.0))+(branch*(Rand(0.0,1.0)**2))+(footsteps*Rand(0.5,1.0));
	sig=sig*10;

	Out.ar(out, sig*env);
}).add;
SynthDef("higurashi", {
	arg out, freq=4186, sustain=1, decay=0, accelerate=0, slide=0;
	var fglide, detune, sound, sig1, env, parFreq, freqDiffRate, lpf, chain, vibratoFreq=8, vibratoDepth=0.4, real=0.4, imag=0;
	detune = 1.0;
	freq = freq - (456.699*slide);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	freqDiffRate = 0.05;
	freq = freq*(1-freqDiffRate) + EnvGen.ar(Env.linen(0.07, 0.3, 0.5, freq*freqDiffRate, -2), timeScale:sustain);
	lpf = freq+Rand(1000, 3000);
	freq = freq*(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	sig1 = Saw.ar([freq,freq]);
	sig1 = sig1+0.1*Saw.ar([(freq*2),(freq*2)]);
	sig1 = sig1+0.2*Saw.ar([(freq/2),(freq/2)]);
	sig1 = sig1 + (PinkNoise.ar(1!2)/20);
	sig1 = LPF.ar(sig1, lpf);
	sound = sig1 / 2;
	parFreq = Rand(7, 9) + EnvGen.ar(Env.linen(0, 0, 0.6, 5, -2), timeScale:sustain);
	sound = sound*Pulse.kr(parFreq); // tremoro
	// spectral-conformer
	chain = sound.asArray.collect { |x| FFT(LocalBuf(2048), x) };
	sound = IFFT(
		PV_ConformalMap(chain, real.linlin(0.0,1.0,0.01,2.0), imag.linlin(0.00,1.0,0.01,10.0))
	).tanh;

	env = EnvGen.ar(Env.linen(0, 0, 0.6, 1, -2), timeScale:sustain, doneAction:2);
	Out.ar(out, sound*env);
}).add;
// ハシボソガラス
SynthDef(\carrionCrow, { arg out, pan=0, amp=0.1, variation=0.9, sustain=1;
	var dt, n, freq, mul, t, u, chain, env, vibratoFreq=50, vibratoDepth=2, freqDiffRate=0.25, real=0.5, imag=0;
	env = EnvGen.ar(Env.linen(0.0, 0, 1, 1, 5), timeScale: sustain, doneAction:2);
	// n = Rand(40, 46);
	n = 45;
	// dt = 25.0 + Rand(-1.7, 1.7);
	dt = 25;
	dt = dt + LFNoise2.kr(2, variation) * 0.0006;
	// freq = 1244.508 + Rand(0, 323.474);
	freq = 1244.508;
	freq = freq*(1-freqDiffRate) + EnvGen.ar(Env.linen(0, 0, 1, freq*freqDiffRate, 5), timeScale:sustain);
	t = Impulse.ar(dt.reciprocal, 0, 100);
	mul = PulseCount.ar(t) < n;
	u = BPF.ar(mul * t, freq, 0.1);
	u = BPF.ar(u, freq, 0.4);
	u = HPF.ar(u, 6000);
	u = LPF.ar(u, 2000);
	// spectral-conformer
	chain = u.asArray.collect { |x| FFT(LocalBuf(2048), x) };
	2.do{
		u = IFFT(
			PV_ConformalMap(chain, real.linlin(0.0,1.0,0.01,2.0), imag.linlin(0.00,1.0,0.01,10.0))
		).tanh;
	};
	u = u*10;
	Out.ar(out, u*env);
}).add;
SynthDef("frog", { arg out, pan=0, variation=0.9;
	var dt, n, freq, mul, t, u, amp=0.1;
	n = Rand(7, 35);
	dt = 25.0 + Rand(-1.7, 1.7);
	dt = dt + LFNoise2.kr(2, variation) * 0.001;
	freq = 901 + Rand(0, 65);
	t = Impulse.ar(dt.reciprocal, 0, 100);
	mul = PulseCount.ar(t) < n;
	u = BPF.ar(mul * t, freq, 0.1);
	u = BPF.ar(u, freq, 0.2);
	u = u * 5;
	DetectSilence.ar(u, doneAction:2);
	Out.ar(out, u*amp);
}).add;
SynthDef(\liminalbd, {|out, rate=1, sustain=1, pan, voice=0, n, speed=1, accelerate|
	var env, sound, freq;
	n = ((n>0)*n) + ((n<1)*3);
	freq = (n*10).midicps;
	env = EnvGen.ar(Env.linen(0.01, 0, 1, 1, -3), timeScale:sustain, doneAction:2);
	sound = LPF.ar(SinOscFB.ar(XLine.ar(freq.expexp(10, 2000, 1000, 8000), freq, 0.025/rate), voice), 9000);
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\liminalhc, {|out, sustain=1, pan, accelerate, n, speed=1|
	var env, sound, freq, accel;
	env = EnvGen.ar(Env.linen(0.01, 0, 0.3, 1, -3), timeScale:sustain, doneAction:2);
	accel = Line.kr(1, 1+accelerate, 0.2*sustain);
	freq = 2000*accel*(n/5 + 1).wrap(0.5,2);
	sound = HPF.ar(LPF.ar(WhiteNoise.ar(1), 3*freq), freq);
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\liminalclap, {|out, rate=1, sustain=1, pan, n, delay=1, pitch1=1 |
	var env, sound;
	var spr = 0.005 * delay;
	env = EnvGen.ar(Env.linen(0.01, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	sound = BPF.ar(LPF.ar(WhiteNoise.ar(1), 7500*pitch1), 1500*pitch1);
	sound = Mix.arFill(4, {arg i; sound * 0.5 * EnvGen.ar(Env.new([0,0,1,0],[spr*(i**(n.clip(0,5)+1)),0,0.04/rate]))});
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;
SynthDef("frogDummy", { arg out, pan=0, variation=0.9, freq=440;
	var dt, n, mul, t, u, amp=0.1;
	n = Rand(7, 35);
	dt = 25.0 + Rand(-1.7, 1.7);
	dt = dt + LFNoise2.kr(2, variation) * 0.001;
	t = Impulse.ar(dt.reciprocal, 0, 100);
	mul = PulseCount.ar(t) < n;
	u = BPF.ar(mul * t, freq, 0.1);
	u = BPF.ar(u, freq, 0.2);
	u = u * 5;
	DetectSilence.ar(u, doneAction:2);
	Out.ar(out, u*amp);
}).add;
SynthDef("sawBass", {
	arg sustain=1, pan=0, freq=110, out=0, maxDistort=0;
	var sound, env, lpfEnv, distortEnv;
	lpfEnv = freq*4 + EnvGen.ar(Env.linen(0, 0, 0.5, 6000, -30), timeScale:sustain);
	distortEnv = EnvGen.ar(Env.linen(0.04, 0.1, 0.4, maxDistort*0.1, 0), timeScale:sustain);
	sound = VarSaw.ar(freq).dup!2 * 0.5;
	sound =  sound + (VarSaw.ar(freq*2).dup!2 * 0.41);
	sound = LPF.ar(sound, lpfEnv);
	sound = CrossoverDistortion.ar(sound, amp: distortEnv, smooth: 0.01);
	sound=NumChannels.ar([sound*(1-pan)/2, sound*(1+pan)/2], 2);
	env = EnvGen.ar(Env.linen(0.01, 0, 1, 1, -3), timeScale:sustain, doneAction:2);
	Out.ar(out, sound*env);
}).add;
SynthDef(\liminalfm, {
	var sustain = \sustain.kr(1);
	var lfofreq = \lfofreq.kr(1);
	var lfodepth = \lfodepth.kr(0);
	var freq = \freq.kr(440);
	var tremolo = 1 + (LFTri.kr(lfofreq) * lfodepth);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var voice = \voice.kr(0);
	var synthrev = \synthrev.kr(0);
	// overall envelope
	var env = EnvGen.ar(Env.linen(0.00, 0.1, 0.9, 1, 1), timeScale:sustain, doneAction:2);
	// operator output levels
	var amps = Array.fill(6, { |i| (\amp++(i+1)).asSymbol.kr(1)});
	// operator frequency ratios
	var ratios = Array.fill(6, {|i| (\ratio++(i+1)).asSymbol.kr(1)});
	// operator frequency detuners
	var detunes = Array.fill(6, {|i| (\detune++(i+1)).asSymbol.kr(rand2(0.1))});
	// feedback -- for presets only
	var feedback = \feedback.kr(0.0);
	// operator envelopes
	var eglevels = Array.fill(6, {|i|
		Array.fill(4, { |n| (\eglevel++(i+1)++(n+1)).asSymbol.kr(1) })
	});
	var egrates = Array.fill(6, {|i| [
		// Supercollider envelopes use seconds for the durations of segments.
		// So higher values mean transitions are slower.
		// DX7s envelopes use rates, which is the inverse of time, 1/time.
		// Higher values in DX7 mean transitions are faster.
		max(0.1 / ((\egrate++(i+1)++1).asSymbol).ir(10), 0.001),
		max(0.1 / ((\egrate++(i+1)++2).asSymbol).ir(0.3), 0.001),
		max(0.1 / ((\egrate++(i+1)++3).asSymbol).ir(0.1), 0.001),
		max(0.1 / ((\egrate++(i+1)++4).asSymbol).ir(0.1), 0.001),
	]});
	// modulation matrix
	var mods = Array.fill2D(6, 6, { |r, c|
		(\mod++(r+1)++(c+1)).asSymbol.kr(0) * if(r == c, feedback, 1)
	});
	var presets = SelectX.kr(voice, [
		[ // user-defined
			ratios,	detunes, amps, eglevels, egrates, mods,
		],
	] ++
	// randomly generated presets
	Array.fill(5, { [
		// ratios
		Array.fill(6, {
			[0.25, 0.5, 1, 2, 3, 4, 5, 6, 7, 11.rand + 1, 13.rand + 1, 15.rand + 1].wchoose(
				[1, 2, 8, 4, 3, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.25].normalizeSum)
		}),
		// detunes
		Array.fill(6, { rand2(7) }),
		// amps
		Array.fill(6, { 1.0.rand * 0.5.coin.asInteger }),
		// EG levels
		Array.fill2D(6, 4, {1.0.rand}),
		// EG rates
		Array.fill2D(6, 4, {1.0.rand}),
		// mods
		Array.fill2D(6, 6, {|r,c| 1.0.rand * 0.25.coin.asInteger * if(r == c, feedback, 1)}),
	]})
	);

	var envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.new(
				// EG levels
				[0]++Array.fill(4, { |n| presets[3][i][n] }),
				// EG rates
				Array.fill(4, { |n| presets[4][i][n] })
			),
			timeScale:sustain,
		);
	});

	var ctls = Array.fill(6, { |i|
		[freq * tremolo * presets[0][i] + presets[1][i], 0, envs[i]]
	});

	var sound = FM7.ar(ctls, presets[5]) * amps;
	sound = Mix.ar(sound) * (-15.dbamp);
	env = if(
		synthrev<0.1,
		env,
		(1-env)
	);
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;
SynthDef("simpleSawWave", {
	arg amp=1, sustain=1, pan=0, freq=110, accelerate=0, lpf=5000, out=0;
	var sound, env;
	freq = freq * Line.kr(1, 1+accelerate, max(0.5, sustain));
	sound = Saw.ar(freq).dup!2 * 0.5;
	sound = LPF.ar(sound, lpf);
	sound=NumChannels.ar([sound*(1-pan)/2, sound*(1+pan)/2], 2);
	env = EnvGen.ar(Env.linen(0.1, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	Out.ar(out, sound*env*amp);
}).add;
SynthDef("softSawWave", {
	arg amp=1, sustain=1, pan=0, freq=110, accelerate=0, lpf=5000, out=0;
	var sound, env;
	freq = freq * Line.kr(1, 1+accelerate, max(0.5, sustain));
	sound = Saw.ar(freq).dup!2 * 0.5;
	sound = LPF.ar(sound, Line.kr(lpf, lpf*0.01, sustain));
	sound=NumChannels.ar([sound*(1-pan)/2, sound*(1+pan)/2], 2);
	env = EnvGen.ar(Env.linen(0.1, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	Out.ar(out, sound*env*amp);
}).add;
SynthDef("simpleSineWave", {
	arg amp=1, sustain=1, pan=0, freq=110, accelerate=0, lpf=5000, out=0;
	var sound, env;
	freq = freq * Line.kr(1, 1+accelerate, max(0.5, sustain));
	sound = SinOsc.ar(freq).dup!2 * 0.5;
	sound = LPF.ar(sound, lpf);
	sound=NumChannels.ar([sound*(1-pan)/2, sound*(1+pan)/2], 2);
	env = EnvGen.ar(Env.linen(0.01, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	Out.ar(out, sound*env*amp);
}).add;
SynthDef("vibratoSineWave", {
	arg amp=1, sustain=1, pan=0, freq=110, accelerate=0, lpf=5000, vibratoFreq=10, vibratoDepth=0, octaveMix=0, out=0;
	var sound, env;
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	freq = freq * Line.kr(1, 1+accelerate, 0.5);
	sound = SinOsc.ar(freq).dup!2 * 0.5;
	sound = sound + (SinOsc.ar(freq*2).dup!2 * octaveMix * 0.5);
	sound = LPF.ar(sound, lpf);
	sound=NumChannels.ar([sound*(1-pan)/2, sound*(1+pan)/2], 2);
	env = EnvGen.ar(Env.linen(0.03, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	Out.ar(out, sound*env*amp);
}).add;
SynthDef(\superpiano,{|out, sustain=1, pan, velocity=1, detune=0.1, muffle=1, stereo=0.2, freq=440, voice=0 |
	var env = SelectX.kr(voice, [
		EnvGen.ar(Env.linen(0.002, 0.996, 0.002, 1,-3), timeScale:sustain, doneAction:2);, // 0:
		EnvGen.ar(Env.linen(0.6, 0, 0.003, 1, 7), timeScale:sustain, doneAction:2) // 1:
	]);
	// the +0.01 to freq is because of edge case rounding internal to the MdaPiano synth
	var sound = MdaPiano.ar(freq+0.01, vel:velocity*100, hard:0.8*velocity, decay:0.1*sustain,
		tune:0.5, random:0.05, stretch:detune, muffle:0.8*muffle, stereo:stereo);
	Out.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env))
}).add;
SynthDef(\pad, {
	| out = 0, amp = 1, freq = 440, gate=1, a = 0.1, s = 10, r = 1|
	var freqs = { freq * LFNoise2.kr(freq:1,mul:0.01,add:1) }!24;
	var gen = LFSaw.ar(freq:freqs) * 0.1;
	var fmod = 1;
	//var fmod = LFCub.kr(freq:1/12).range(1, LFNoise2.kr(freq:1).range(6,7)); // sharper sound
	var rqmod = LFNoise2.kr(freq:1/8).range(0.1,1.0);
	// var modspeed = 1/s;
	var modspeed = 1/(Rand(0.4,10));
	// var modspeed = 10; // tremolo sound
	// var modspeed = 10000*LFNoise2.ar(freq:4/s); // wobble sound (works best with sharper sounding pad)
	var snd = RLPF.ar(in:gen, freq:SinOsc.kr(modspeed).range(freqs*0.8, freqs*1.2) * fmod, rq:rqmod);
	// var env = EnvGen.ar(Env.new(levels:[0,1,1,0], times:[a, s, r]), gate, doneAction:2);
	Out.ar(bus:out, channelsArray:Splay.ar(snd*amp));
}).add;
SynthDef("rain2", {
	arg amp=1;
	var out=0;
	p=PinkNoise.ar(1!2);
	p=HPF.ar(p, 1600);
	p=LPF.ar(p, 4390);
	Out.ar(out, p*0.05*amp);
}, [1]).add;
SynthDef("river", {
	arg amp=1;
	var out=0;
	p=PinkNoise.ar(1!2);
	p=HPF.ar(p, 475);
	p=LPF.ar(p, 2500);
	Out.ar(out, p*0.05*amp);
}, [1]).add;
SynthDef("sawDry", {
	arg freq = 440, amp = 0.2, parFreq=0, pan2Freq=0, pan=0,
	vibratoFreq=3, vibratoDepth=0, actave=1, bpf=440;
	var sig, out=0, chain, in, z, y, oct, left, right, mod;
	sig = SawDPW.ar(actave*freq*(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50))), 0, amp);
	// tremoro
	sig = if(
		parFreq>0.1,
		sig*LFPar.ar(parFreq),
		if(
			LFPar.ar(parFreq)>0,
			sig*(LFPar.ar(parFreq) + (1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
			sig*(LFPar.ar(parFreq) + (-1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
		)
	);
	// panning
	sig = if(
		pan2Freq>0.1,
		Pan2.ar(sig, LFPar.ar(pan2Freq)),
		Pan2.ar(sig, LFPar.ar(pan2Freq)*pan2Freq*10)
	);¥
	sig = sig * 0.1;
	// sig = LPF.ar(sig, lpf);
	sig = BPF.ar(sig, bpf);
	Out.ar(out, sig);
}, [0, 10, 1, 1, 1, 1, 1, 1, 10, 10, 10]).add;
SynthDef("sineDry", {
	arg freq = 440, amp = 0.2, parFreq=0, pan2Freq=0, pan=0,
	vibratoFreq=3, vibratoDepth=0, actave=1, bpf=440;
	var sig, out=0, chain, in, z, y, oct, left, right, mod;
	sig = SinOsc.ar(actave*freq*(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50))), 0, amp);
	// tremoro
	sig = if(
		parFreq>0.1,
		sig*LFPar.ar(parFreq),
		if(
			LFPar.ar(parFreq)>0,
			sig*(LFPar.ar(parFreq) + (1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
			sig*(LFPar.ar(parFreq) + (-1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
		)
	);
	// panning
	sig = if(
		pan2Freq>0.1,
		Pan2.ar(sig, LFPar.ar(pan2Freq)),
		Pan2.ar(sig, LFPar.ar(pan2Freq)*pan2Freq*10)
	);
	sig = sig * 0.1;
	// sig = LPF.ar(sig, lpf);
	sig = BPF.ar(sig, bpf);
	Out.ar(out, sig);
}, [0, 10, 1, 1, 1, 1, 1, 1, 10, 10, 10]).add;
SynthDef("sine", {
	arg freq = 440, amp = 0.2, parFreq=0, pan2Freq=0, pan=0,
	vibratoFreq=3, vibratoDepth=0, actave=1, reverb=0, ice=0, distort=0;
	var sig, out=0, chain, in, z, y, oct, left, right, mod;
	sig = SinOsc.ar(actave*freq*(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50))), 0, amp);
	// distort
	mod = CrossoverDistortion.ar(sig, amp: 0.2, smooth: 0.01);
	mod = mod + (0.1 * distort * DynKlank.ar(`[[60,61,240,3000 + SinOsc.ar(62,mul: 100)],nil,[0.1, 0.1, 0.05, 0.01]], sig));
	mod = (mod.cubed * 8).softclip * 0.5;
	sig = SelectX.ar(distort, [sig, mod]);
	// tremoro
	sig = if(
		parFreq>0.1,
		sig*LFPar.ar(parFreq),
		if(
			LFPar.ar(parFreq)>0,
			sig*(LFPar.ar(parFreq) + (1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
			sig*(LFPar.ar(parFreq) + (-1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
		)
	);
	// panning
	sig = if(
		pan2Freq>0.1,
		Pan2.ar(sig, LFPar.ar(pan2Freq)),
		Pan2.ar(sig, LFPar.ar(pan2Freq)*pan2Freq*10)
	);
	// reverb
	z = DelayN.ar(sig, 0.048);
	y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, 1, 15) }));
	32.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1) });
	oct = 1.0 * LeakDC.ar( abs(y) );
	y = SelectX.ar(ice, [y, ice * oct, DC.ar(0)]);
	sig = sig + (0.2*y*reverb);
	sig = sig * 0.1;
	Out.ar(out, sig);
}, [0.1, 0.2, 1, 1, 1, 1, 1, 1, 10, 10, 10]).add;
SynthDef("saw", {
	arg freq = 440, amp = 0.2, parFreq=0, pan2Freq=0, pan=0,
	vibratoFreq=3, vibratoDepth=0, actave=1, reverb=0, ice=0, bpf=440;
	var sig, out=0, chain, in, z, y, oct, left, right, mod;
	sig = SawDPW.ar(actave*freq*(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50))), 0, amp);
	// tremoro
	sig = if(
		parFreq>0.1,
		sig*LFPar.ar(parFreq),
		if(
			LFPar.ar(parFreq)>0,
			sig*(LFPar.ar(parFreq) + (1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
			sig*(LFPar.ar(parFreq) + (-1-(LFPar.ar(parFreq))*((1-(parFreq*10))))),
		)
	);
	// panning
	sig = if(
		pan2Freq>0.1,
		Pan2.ar(sig, LFPar.ar(pan2Freq)),
		Pan2.ar(sig, LFPar.ar(pan2Freq)*pan2Freq*10)
	);
	// reverb
	z = DelayN.ar(sig, 0.048);
	y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.1, 1, 15) }));
	32.do({ y = AllpassN.ar(y, 0.050, [0.050.rand, 0.050.rand], 1) });
	oct = 1.0 * LeakDC.ar( abs(y) );
	y = SelectX.ar(ice, [y, ice * oct, DC.ar(0)]);
	sig = sig + (0.2*y*reverb);
	sig = sig * 0.1;
	// sig = LPF.ar(sig, lpf);
	sig = BPF.ar(sig, bpf);
	Out.ar(out, sig);
}, [0.3, 10, 1, 1, 1, 1, 1, 1, 10, 10, 10]).add;
SynthDef(\zureSc, {|out, amp=1, pan, accelerate, freq, decay=0, detune=1,lpf=8000,hpf=50 |
	var basefreq = freq;
	var sound = VarSaw.ar(basefreq, 0, 1);
	var sound2 = VarSaw.ar(basefreq*(detune/100+1), 0, 1);
	var sound3 = VarSaw.ar(basefreq*(-1*detune/100+1), 0, 1);
	sound = sound - DelayN.ar(sound2,0.2)
	+ DelayN.ar(sound3,0.2);
	sound = LPF.ar(sound, lpf);
	sound = HPF.ar(sound, hpf);
	Out.ar(out, sound!2*0.05*amp);
}, [0, 1, 0, 0, 0, 0.2]).add;
SynthDef(\padDirt, {
	| out = 0, amp = 1, freq = 440, gate=1, sustain=1, modspeed=1|
	var freqs = { freq * LFNoise2.kr(freq:1,mul:0.01,add:1) }!24;
	var gen = LFSaw.ar(freq:freqs) * 0.1;
	var fmod = 1;
	//var fmod = LFCub.kr(freq:1/12).range(1, LFNoise2.kr(freq:1).range(6,7)); // sharper sound
	var rqmod = LFNoise2.kr(freq:1/8).range(0.1,1.0);
	// modspeed = 1/sustain;
	// var modspeed = 1/(Rand(0.4,10));
	// var modspeed = 110; // tremolo sound
	// var modspeed = 1000*LFNoise2.ar(freq:40); // wobble sound (works best with sharper sounding pad)
	var snd = RLPF.ar(in:gen, freq:SinOsc.kr(modspeed).range(freqs*0.8, freqs*1.2) * fmod, rq:rqmod);
	var env = EnvGen.ar(Env.linen(0.1, 0, 0.6, 1, -3), timeScale:sustain, doneAction:2);
	Out.ar(bus:out, channelsArray:Splay.ar(snd*amp*env));
}).add;
SynthDef("higurashiToy", {
	arg out, freq=4186, sustain=1, decay=0, accelerate=0, slide=0;
	var fglide, detune, sound, sig1, env, parFreq, freqDiffRate, vibratoFreq=8, vibratoDepth=0.4;
	detune = 1.0;
	freq = freq - (456.699*slide);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	freqDiffRate = 0.05;
	freq = freq*(1-freqDiffRate) + EnvGen.ar(Env.linen(0.07, 0.3, 0.5, freq*freqDiffRate, -2), timeScale:sustain);
	freq = freq*(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	sig1 = SawDPW.ar([freq,freq]);
	sig1 = sig1+0.1*SawDPW.ar([(freq*2),(freq*2)]);
	sig1 = sig1+0.2*SawDPW.ar([(freq/2),(freq/2)]);
	sig1 = sig1 + (PinkNoise.ar(1!2)/20);
	sound = sig1;
	parFreq = Rand(3.5, 7) + EnvGen.ar(Env.linen(0, 0, 0.6, 5, -2), timeScale:sustain);
	sound = sound*Pulse.kr(parFreq); // tremoro
	env = EnvGen.ar(Env.linen(0, 0, 0.6, 1, -2), timeScale:sustain, doneAction:2);
	Out.ar(out, sound*env);
}).add;
SynthDef("jungleCrowToy", { arg out, pan=0, amp=0.1, sustain=1, vibratoDepth=0, freqRate1=1, freqRate2=1.04, freqRate3=1.45, freqRate4=1.5, freqRate5=1.95, freqRate6=2;
	var freq, u, env, vibratoFreq=70, freqDiffRate=0.1, real=0.5, imag=0;
	env = EnvGen.ar(Env.linen(0.04, 0, 1, 1, 8), timeScale: sustain, doneAction:2);
	freq = 1000 + Rand(0, 10);
	freq = freq *(1+((LFPar.ar(vibratoFreq)+1)*(vibratoDepth/50)));
	freq = freq*(1-freqDiffRate) + EnvGen.ar(Env.linen(0, 0, 1, freq*freqDiffRate, 7), timeScale:sustain);
	u = 0;
	u = u + (SinOsc.ar(freq*freqRate1) * 0.15);
	u = u + (SinOsc.ar(freq*freqRate2) * 0.07);
	u = u + (SinOsc.ar(freq*freqRate3) * 0.13);
	u = u + (SinOsc.ar(freq*freqRate4) * 0.09);
	u = u + (SinOsc.ar(freq*freqRate5) * 0.07);
	u = u + (SinOsc.ar(freq*freqRate6) * 0.09);
	OffsetOut.ar(out, u*env);
}).add;