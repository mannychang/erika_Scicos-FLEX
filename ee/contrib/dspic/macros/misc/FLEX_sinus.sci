function [x,y,typ] = FLEX_sinus(job,arg1,arg2)
  x=[];y=[];typ=[];
  select job
  case 'plot' then
    exprs=arg1.graphics.exprs;
    
    standard_draw(arg1)
  case 'getinputs' then
    [x,y,typ]=standard_inputs(arg1)
  case 'getoutputs' then
    [x,y,typ]=standard_outputs(arg1)
  case 'getorigin' then
    [x,y]=standard_origin(arg1)
  case 'set' then
    x=arg1
    model=arg1.model;graphics=arg1.graphics;
    exprs=graphics.exprs;
    while %t do
      [ok,A,frq,phase,bias,delay,exprs]=..
      getvalue('Set RTAI-sinus block parameters',..
      ['Amplitude:';
       'Frequency:';
       'Phase:';
       'Bias:';
       'Delay:'],..
      list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs)
      if ~ok then break,end
      if exists('outport') then out=ones(outport,1), in=[], else out=1, in=[], end
      [model,graphics,ok]=check_io(model,graphics,in,out,1,[])
      if ok then
        graphics.exprs=exprs;
        model.rpar=[A;
                    frq;
                    phase;
                    bias;
                    delay];
        model.ipar=[];
        x.graphics=graphics;x.model=model
        break
      end
    end
  case 'define' then
    A=1
    frq=1
    phase=0
    bias=0
    delay=0
    model=scicos_model()
    model.sim=list('rt_sinus',4)
    if exists('outport') then model.out=ones(outport,1), model.in=[], else model.out=1, model.in=[], end
    model.evtin=1
    model.rpar=[A;
                frq;
                phase;
                bias;
                delay]
    model.ipar=[]
    model.blocktype='d'
    model.dep_ut=[%t %f]
    exprs=[sci2exp(A),sci2exp(frq),sci2exp(phase),sci2exp(bias),sci2exp(delay)]
    gr_i=['xstringb(orig(1),orig(2),[''Sine''],sz(1),sz(2),''fill'');']
    x=standard_define([3 2],model,exprs,gr_i)
  end
endfunction
