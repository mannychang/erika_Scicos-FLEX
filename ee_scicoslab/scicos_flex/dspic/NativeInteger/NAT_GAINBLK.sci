function [x,y,typ] = NAT_GAINBLK(job,arg1,arg2)
// Copyright INRIA
//** 14 JAN 2008 : Native integer Gain Block .
//**               This block uses native integer operations
//** 
  x = [];
  y = [];
  typ = [];
  
  select job
  
    //**------------------------------------------------------
    case 'plot' then //** ----------- PLOT -------------------
    
    //** OLD Graphics : to be removed 
    pat = xget('pattern'); //** save the actual color 
    xset('pattern',default_color(0)); //** force the actual defaul color  
    
    orig = arg1.graphics.orig   ;
    sz   = arg1.graphics.sz     ;
    orient = arg1.graphics.flip ;
    
    //** if the "gain" string is logher than 3 chars, display just "" 
    if length(arg1.graphics.exprs(1))>3 then
       gain = " k " ; 
    else 
       gain = arg1.graphics.exprs(1);
    end
    
    //** Left / Right orientation
    if orient then
      xx=orig(1)+[0 1 0 0]*sz(1);
      yy=orig(2)+[0 1/2 1 0]*sz(2);
      x1=0
    else
      xx=orig(1)+[0   1 1 0]*sz(1);
      yy=orig(2)+[1/2 0 1 1/2]*sz(2);
      x1=1/4
    end
  
    gr_i = arg1.graphics.gr_i;
    
    //** Show the the string "gain".
    
    //** coli = gr_i(2); //** original code
    coli = 4 ; //** force a color to differentiate (temp patch) 
    xfpolys(xx',yy',coli);
    xstringb(orig(1)+x1*sz(1),orig(2),gain,(1-x1)*sz(1),sz(2));
      
    xf = 60 ; //** default values  
    yf = 40 ; 
    
    nin  = 1; //** one input 
    nout = 1; //** one output 

    if orient then  //standard orientation: in=left / out=right 
		    
      // set port shape
      out=[0  -1/14
	       1/7 0
	       0   1/14
	       0  -1/14] * diag([xf,yf]); 
      in= [-1/7  -1/14
	         0    0
	       -1/7   1/14
	       -1/7  -1/14] * diag([xf,yf]); 
      dy = sz(2)/(nout+1)
      
      //** OLD Graphics (to be removed) 
      xset('pattern',default_color(1)); 
      for k=1:nout
	     xfpoly(out(:,1)+ones(4,1)*(orig(1)+sz(1)), out(:,2)+ones(4,1)*(orig(2)+sz(2)-dy*k),1);
      end
      dy = sz(2)/(nin+1); 
      for k=1:nin
	     xfpoly(in(:,1)+ones(4,1)*orig(1), in(:,2)+ones(4,1)*(orig(2)+sz(2)-dy*k),1);
      end
    
    else // tilded orientation
      
      out = [0  -1/14
	          -1/7 0
	         0   1/14
	         0  -1/14]*diag([xf,yf])
      in  = [1/7  -1/14
	          0    0
	         1/7   1/14
	         1/7  -1/14]*diag([xf,yf])
      dy = sz(2)/(nout+1)
      
      //** obsolete OLD code 
      xset('pattern',default_color(1));
      for k=1:nout
	      xfpoly(out(:,1)+ones(4,1)*orig(1)-1, out(:,2)+ones(4,1)*(orig(2)+sz(2)-dy*k),1);
      end
      dy=sz(2)/(nin+1)
      for k=1:nin
	     xfpoly(in(:,1)+ones(4,1)*(orig(1)+sz(1))+1,in(:,2)+ones(4,1)*(orig(2)+sz(2)-dy*k),1);
      end
     end
  
    xset('pattern',pat) ; //** restore the original color 
    
    //** ------- Identification ---------------------------
    ident = o.graphics.id
    gh_axes = gca(); //** get the Axes proprieties 
  
    // draw Identification
    if ident <> []& ident <> ''  then
  
      //** Save font state  
      axes_font_style = gh_axes.font_style ;
      axes_font_size  = gh_axes.font_size  ;
      //** axes_font_color = gh_axes.font_color ; //** optional
  
        gh_axes.font_style = options.ID(1)(1) ; 
        gh_axes.font_size  = options.ID(1)(2) ;
        //** font color not yet used 
        rectangle = xstringl(orig(1), orig(2), ident) ;
        w = max(rectangle(3), sz(1)) ;
        h = rectangle(4) * 1.3 ;
        xstringb(orig(1) + sz(1) / 2 - w / 2, orig(2) - h , ident , w, h) ;
  
     //** Restore font state 
     gh_axes.font_style = axes_font_style ;
     gh_axes.font_size  = axes_font_size  ;
     //** gh_axes.font_color = axes_font_color ; //** optional

  end
  //** ----- Identification End -----------------------------

    
    //**-----------------------------------------------------------
    case 'getinputs' then //** GET INPUTS 
    [x,y,typ]=standard_inputs(arg1)
    
    case 'getoutputs' then
    [x,y,typ]=standard_outputs(arg1)
    
    case 'getorigin' then
    [x,y]=standard_origin(arg1)
    
    //** ---------- Set block's parameters -----------------------
    case 'set' then
    x = arg1 ;
    graphics = arg1.graphics  ;
    exprs    = graphics.exprs ;
    model = arg1.model        ;
    
    //** Back compatibility (obsolete)
    if size(exprs,'*')==1 then
      exprs = [exprs; sci2exp(0)];
    end // compatibility
    
    while %t do
      [ok, gain, over, exprs] = getvalue('Native Integer Support: Set Gain parameters',..
			                        ['Gain';..
				                     'Do On Overflow(0=Nothing 1=Saturate 2=Error)'],..
				                     list('mat',[-1,-1],'vec',1),exprs)
      if ~ok then break,end
      //** error message  
      if gain==[] then
	       message('Gain must have at least one element')
      else //** if the "gain" contains something
        if typeof(gain)=="constant" then
           //** if "gain" is a constant : ALL the constant are assumed as REAL (double)
           if isreal(gain) then 
               it = 1;
               ot = 1;
               model.sim=list('gainblk',4);
               model.rpar=gain(:);
               model.opar=list();
           else
               //** other "constant" are NOT supported 
               message("type is not supported");
               ok = %f ;
           end
 
        else //** "gain" is not a constant e.g. int32(55.23) 
          
          //** Do nothing on overflow
          if (over==0) then
	        
	        if (typeof(gain)=="int32") then
	 	       ot = 3 ; 
	 	       model.sim = list('nat_gainblk_i32n',4) ; 
	        elseif (typeof(gain)=="int16") then
	 	       ot = 4 ; 
	 	       model.sim = list('nat_gainblk_i16n',4) ;
	        elseif (typeof(gain)=="int8") then
	 	       ot = 5 ; 
	 	       model.sim=list('nat_gainblk_i8n',4) ;
	        
	        elseif (typeof(gain)=="uint32") then
	 	       ot = 6 ;
	 	       model.sim=list('gainblk_ui32n',4)
	        elseif (typeof(gain)=="uint16") then
	 	       ot = 7
	 	       model.sim=list('gainblk_ui16n',4)
	        elseif (typeof(gain)=="uint8") then
	 	       ot = 8
	 	       model.sim=list('gainblk_ui8n',4)
            else
               message("type is not supported.");
               ok = %f ;
            end
	      
	      //** Saturate on overflow
	      elseif (over==1) then
	        if (typeof(gain)=="int32") then
	 	      ot = 3 ; 
	 	      model.sim = list('gainblk_i32s',4)
	        elseif (typeof(gain)=="int16") then
	 	      ot = 4 ; 
 	 	      model.sim=list('gainblk_i16s',4)
	        elseif (typeof(gain)=="int8") then
	 	      ot = 5
	 	      model.sim = list('gainblk_i8s',4)
	        elseif (typeof(gain)=="uint32") then
	 	      ot = 6
	 	      model.sim=list('gainblk_ui32s',4)
	        elseif (typeof(gain)=="uint16") then
	 	      ot = 7
	 	      model.sim = list('gainblk_ui16s',4)
	        elseif (typeof(gain)=="uint8") then
	 	      ot = 8
	 	      model.sim=list('gainblk_ui8s',4)
            else
              message("type is not supported.");
              ok = %f; 
            end
	      
	      //** Error on overflow 
	      elseif (over==2) then
	        if (typeof(gain)=="int32") then
	 	      ot = 3; 
	 	      model.sim = list('gainblk_i32e',4);
	        elseif (typeof(gain)=="int16") then
	 	      ot = 4 ;
	 	      model.sim = list('gainblk_i16e',4);
	        elseif (typeof(gain)=="int8") then
	 	      ot = 5 ;
	 	      model.sim = list('gainblk_i8e',4);
	        elseif (typeof(gain)=="uint32") then
	 	      ot = 6 ;
	 	      model.sim=list('gainblk_ui32e',4);
	        elseif (typeof(gain)=="uint16") then
	 	      ot = 7 ;
	 	      model.sim = list('gainblk_ui16e',4);
	        elseif (typeof(gain)=="uint8") then
	 	      ot = 8 ;
	 	      model.sim = list('gainblk_ui8e',4);
            else
              message("type is not an integer.");
              ok = %f;
	        end
        else
            message("Do on Overflow must be [0,1,2]");
            ok = %f;
        end
	
          model.rpar = [];
          model.opar = list(gain(:));
        
        end
        
       if ok then
	     [out,in] = size(gain)
	     if out*in<>1 then
	        [model,graphics,ok] = set_io(model,graphics, list([in,-1],ot), list([out,-1],ot),[],[]) ;
	     else
	  	    [model,graphics,ok] = set_io(model,graphics, list([-1,-2],ot),  list([-1,-2],ot),[],[]) ;
	     end
       end
     
	   if ok then
	     //** look 
	     graphics.exprs = exprs ;
	     x.graphics = graphics  ;
	     x.model = model        ;
	     //** switch to native integer computational function
	     //** model.sim(1) = "nat_"+model.sim(1); //** the "nat_" suffix define native integer support 
	     break ; //** EXIT from the infinite while(1) loop
       end
     
     end //** .. of while(1) 
    
    end //** end of "set" 
  
    //** Default "definition" of block's parameters 
    case 'define' then
        gain = 1.0 ;
        in   = -1  ;
        out  = -1  ; 
        in2  = -2  ;
        out2 = -2  ;
        model = scicos_model() ; 
        model.sim  = list('gainblk',4)
        model.in   = in  ; 
        model.out  = out ;
        model.in2  = in2 ;
        model.out2 = out2 ; 
        model.rpar = gain ;
        model.blocktype = 'c' ; 
        model.dep_ut    = [%t %f] ; 
        exprs = [strcat(sci2exp(gain))] ;
        gr_i = ''; //** BEWARE : this function uses explicit plot ! 
        x    = standard_define([2 2], model, exprs, gr_i); 

  end //** end of the switch on 'job' 

endfunction
