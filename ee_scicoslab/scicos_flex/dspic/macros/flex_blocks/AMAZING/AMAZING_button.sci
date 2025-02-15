function [x,y,typ] = AMAZING_button(job,arg1,arg2)
  x=[];y=[];typ=[];
  select job
  
  case 'plot' then
    exprs=arg1.graphics.exprs;
    gpin_pin=exprs(1)
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
      [ok,gpin_pin,exprs]=..
      getvalue('Select Button Input',..
      ['Button [1..2] :'],..
      list('vec',-1),exprs)
      if ~ok then 
          break;
      end 
      if(gpin_pin<1 | gpin_pin>2) then
        warning('Accepted values for button are in [1,2]. Keeping previous value.');
        break;
      end
      in=[],
      if exists('outport') then out=ones(outport,1), else out=1, end
      [model,graphics,ok]=check_io(model,graphics,in,out,1,[])
      if ok then
        graphics.exprs=exprs;
        model.rpar=[];
        model.ipar=[gpin_pin];
        model.dstate=[];
        x.graphics=graphics;x.model=model
        break
      end
    end
	
  case 'define' then
    gpin_pin=1
    model=scicos_model()
    model.sim=list('amazing_button',4)
    model.in=[],
    if exists('outport') then model.out=ones(outport,1), else model.out=1, end
    model.evtin=1
    model.rpar=[]
    model.ipar=[gpin_pin]
    model.dstate=[];
    model.blocktype='d'
    model.dep_ut=[%t %f]
    exprs=[sci2exp(gpin_pin)]
    gr_i=['xstringb(orig(1),orig(2),[''AMAZING'' ; ''Button: ''+string(gpin_pin)],sz(1),sz(2),''fill'');']
    x=standard_define([3 2],model,exprs,gr_i)
  end
endfunction
