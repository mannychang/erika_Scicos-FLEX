
//==========================================================================
//generates  static table definitions
//
//Author : Rachid Djenidi, Alan Layec
//Copyright INRIA

// Modified for RT purposes by Roberto Bucher - RTAI Team
// roberto.bucher@supsi.ch

function txt=make_static_standalone42()

  txt=[''];

  //*** Continuous state ***//
  if x <> [] then
   txt=[txt;
        '/* def continuous state */'
        cformatline('static double x[]={'+strcat(string(x),',')+'};',70)
        cformatline('static double xd[]={'+strcat(string(x),',')+'};',70)
        'static int c__1 = 1;'
        'static double c_b14 = 0.;'
        'static int neq='+string(nX)+';'
        '']
  end
  //************************//

  txt=[txt;
       'scicos_block block_'+rdnom+'['+string(nblk)+'];'
       ''];

  //*** Real parameters ***//
  nbrpa=0;strRCode='';lenRCode=[];ntot_r=0;
  if size(rpar,1) <> 0 then
    txt=[txt;
	 '/* def real parameters */'
         '__CONST__ double RPAR[ ] = {'];

    for i=1:(length(rpptr)-1)
      if rpptr(i+1)-rpptr(i)>0  then

        if size(corinv(i),'*')==1 then
          OO=scs_m.objs(corinv(i));
        else
          path=list('objs');
          for l=cpr.corinv(i)(1:$-1)
            path($+1)=l;
            path($+1)='model';
            path($+1)='rpar';
            path($+1)='objs';
          end
          path($+1)=cpr.corinv(i)($);
          OO=scs_m(path);
        end

        //** Add comments **//
	nbrpa=nbrpa+1;
	ntot_r = ntot_r + (rpptr(i+1)-rpptr(i));
        txt($+1)='/* Routine name of block: '+strcat(string(cpr.sim.funs(i)));
        txt($+1)=' * Gui name of block: '+strcat(string(OO.gui));
        txt($+1)=' * Compiled structure index: '+strcat(string(i));

        if stripblanks(OO.model.label)~=emptystr() then
          txt=[txt;cformatline(' * Label: '+strcat(string(OO.model.label)),70)];
        end
        if stripblanks(OO.graphics.exprs(1))~=emptystr() then
          txt=[txt;cformatline(' * Exprs: '+strcat(OO.graphics.exprs(1),","),70)];
        end
	if stripblanks(OO.graphics.id)~=emptystr() then
	  str_id = string(OO.graphics.id);
        else
	  str_id = 'RPARAM[' + string(nbrpa) +']';
	end
        txt=[txt;
             cformatline(' * Identification: '+strcat(string(OO.graphics.id)),70)];
	txt=[txt;cformatline('rpar= {'+strcat(string(rpar(rpptr(i):rpptr(i+1)-1)),",")+'};',70)];
	txt($+1)='*/';
                //******************//

        txt=[txt;
             cformatline(strcat(msprintf('%.16g,\n',rpar(rpptr(i):rpptr(i+1)-1))),70);
             '']
	strRCode = strRCode + '""' + str_id + '"",';
	lenRCode = lenRCode + string(rpptr(i+1)-rpptr(i)) + ',';

      end
    end
    txt=[txt;
           '};']
  else
    txt($+1)='double RPAR[1];';
  end

  txt = [txt;
         '';
         '#ifdef linux';
        ]
  txt($+1) = 'int NRPAR = '+string(nbrpa)+';';
  txt($+1) = 'int NTOTRPAR = '+string(ntot_r)+';';
    
  strRCode = 'char * strRPAR[' + string(nbrpa) + '] = {' + ..
             part(strRCode,[1:length(strRCode)-1]) + '};';

  if nbrpa <> 0 then
    txt($+1) = strRCode;
    lenRCode = 'int lenRPAR[' + string(nbrpa) + '] = {' + ..
               part(lenRCode,[1:length(lenRCode)-1]) + '};';
  else
     txt($+1) = 'char * strRPAR;'
     lenRCode = 'int lenRPAR[1] = {0};'
  end
  txt($+1) = lenRCode;
  txt = [txt;
         '#endif';
         '';
        ]

  //***********************//

  //*** Integer parameters ***//
  nbipa=0;strICode='';lenICode=[];ntot_i=0;
  if size(ipar,1) <> 0 then
    txt=[txt;
           '/* def integer parameters */'
           '__CONST__ int IPAR[ ] = {'];

    for i=1:(length(ipptr)-1)
      if ipptr(i+1)-ipptr(i)>0  then
        if size(corinv(i),'*')==1 then
          OO=scs_m.objs(corinv(i));
        else
          path=list('objs');
          for l=cpr.corinv(i)(1:$-1)
            path($+1)=l
            path($+1)='model'
            path($+1)='rpar'
            path($+1)='objs'
          end
          path($+1)=cpr.corinv(i)($);
          OO=scs_m(path);
        end

        //** Add comments **//
        nbipa=nbipa+1;
	ntot_i = ntot_i + (ipptr(i+1)-ipptr(i));
        txt($+1)='/* Routine name of block: '+strcat(string(cpr.sim.funs(i)));
        txt($+1)=' * Gui name of block: '+strcat(string(OO.gui));
        txt($+1)=' * Compiled structure index: '+strcat(string(i));
        if stripblanks(OO.model.label)~=emptystr() then
          txt=[txt;cformatline(' * Label: '+strcat(string(OO.model.label)),70)];
        end

        if stripblanks(OO.graphics.exprs(1))~=emptystr() then
          txt=[txt;
               cformatline(' * Exprs: '+strcat(OO.graphics.exprs(1),","),70)];
        end

	if stripblanks(OO.graphics.id)~=emptystr() then
	  str_id = string(OO.graphics.id);
        else
	  str_id = 'IPARAM[' + string(nbipa) +']';
	end

        txt=[txt;
               cformatline(' * Identification: '+strcat(string(OO.graphics.id)),70)];
	txt=[txt;cformatline('ipar= {'+strcat(string(ipar(ipptr(i):ipptr(i+1)-1)),",")+'};',70)];
	txt($+1)='*/';

        //******************//

        txt=[txt;cformatline(strcat(string(ipar(ipptr(i):ipptr(i+1)-1))+','),70)];
	strICode = strICode + '""' + str_id + '"",';
	lenICode = lenICode + string(ipptr(i+1)-ipptr(i)) + ',';
      end
    end
    txt=[txt;
         '};']
  else
    txt($+1)='int IPAR[1];';
  end

  txt = [txt;
         '';
         '#ifdef linux';
        ]
  txt($+1) = 'int NIPAR = '+string(nbipa)+';';
  txt($+1) = 'int NTOTIPAR = '+string(ntot_i)+';';

  strICode = 'char * strIPAR[' + string(nbipa) + '] = {' + ..
             part(strICode,[1:length(strICode)-1]) + '};';

  if nbipa <> 0 then
     txt($+1) = strICode;
     lenICode = 'int lenIPAR[' + string(nbipa) + '] = {' + ..
                part(lenICode,[1:length(lenICode)-1]) + '};';
  else
     txt($+1) = 'char * strIPAR;'
     lenICode = 'int lenIPAR[1] = {0};'
  end
  txt($+1) = lenICode;
  txt = [txt;
         '#endif';
         '';
        ]

  //**************************//

  //Alan added opar (27/06/07)
  //*** Object parameters ***//
  if lstsize(opar)<>0 then
    txt=[txt;
          '/* def object parameters */']
    for i=1:(length(opptr)-1)
      if opptr(i+1)-opptr(i)>0  then

        if size(corinv(i),'*')==1 then
          OO=scs_m.objs(corinv(i));
        else
          path=list('objs');
          for l=cpr.corinv(i)(1:$-1)
            path($+1)=l;
            path($+1)='model';
            path($+1)='rpar';
            path($+1)='objs';
          end
          path($+1)=cpr.corinv(i)($);
          OO=scs_m(path);
        end

        //** Add comments **//
        txt($+1)='';
        txt($+1)='/* Routine name of block: '+strcat(string(cpr.sim.funs(i)));
        txt($+1)=' * Gui name of block: '+strcat(string(OO.gui));
        txt($+1)=' * Compiled structure index: '+strcat(string(i));
        if stripblanks(OO.model.label)~=emptystr() then
          txt=[txt;cformatline(' * Label: '+strcat(string(OO.model.label)),70)];
        end
        if stripblanks(OO.graphics.id)~=emptystr() then
          txt=[txt;
               cformatline(' * Identification: '+strcat(string(OO.graphics.id)),70)];
        end
        txt($+1)=' */';
        //******************//

        for j=1:opptr(i+1)-opptr(i)
          txt =[txt;
                cformatline('static __CONST__ '+mat2c_typ(opar(opptr(i)+j-1)) +...
                            ' OPAR_'+string(opptr(i)+j-1) + '[] = {'+...
                            strcat(string(opar(opptr(i)+j-1)),',')+'};',70)]
        end
      end
    end
  end
  //*************************//

  txt=[txt;
       '']
endfunction
