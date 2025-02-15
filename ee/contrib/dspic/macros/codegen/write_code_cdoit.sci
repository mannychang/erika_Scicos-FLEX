
//==========================================================================
//write_code_cdoit : generate body of the code for
//                   for all time dependant blocks
//
//input : flag : flag number for block's call
//
//output : txt for cord blocks
//
//12/07/07 Alan Layec
//Copyright INRIA

// Modified for RT purposes by Roberto Bucher - RTAI Team
// roberto.bucher@supsi.ch

function [txt]=write_code_cdoit(flag)

  txt=[];

  for j=1:ncord
    bk=cord(j,1);
    pt=cord(j,2);
    //** blk
    if funtyp(bk)>-1 then
//      if or(bk==act) | or(bk==cap) then
//        if stalone then
//          txt2=call_block42(bk,pt,flag);
//          if txt2<>[] then
//            txt=[txt;
//                 '    '+txt2
//                 ''];
//          end
//        end
//      else
        txt2=call_block42(bk,pt,flag);
        if txt2<>[] then
          txt=[txt;
               '  '+txt2
               ''];
        end
//      end
    //** ifthenelse blk
    elseif funtyp(bk)==-1 then
      ix=-1+inplnk(inpptr(bk));
      TYPE=mat2c_typ(outtb(ix+1)); //** scilab index start from 1
      thentxt=write_code_doit(clkptr(bk),flag);
      elsetxt=write_code_doit(clkptr(bk)+1,flag);
      if thentxt<>[] | elsetxt<>[] then
        txt=[txt;
             '  '+get_comment('ifthenelse_blk',list(bk));]
        //** C **//
        tmp_='*(('+TYPE+' *)'+rdnom+'_block_outtbptr['+string(ix)+'])'
        txt=[txt;
             '  if('+tmp_+'>0) {']
        //*******//
        txt=[txt;
             Indent+thentxt];
        if elsetxt<>[] then
          //** C **//
          txt=[txt;
               '  }';
               '  else {';]
          //*******//
          txt=[txt;
               Indent+elsetxt];
        end
        //** C **//
        txt=[txt;
             '  }']
        //*******//
      end
    //** eventselect blk
    elseif funtyp(bk)==-2 then
      Noutport=clkptr(bk+1)-clkptr(bk);
      ix=-1+inplnk(inpptr(bk));
      TYPE=mat2c_typ(outtb(ix+1)); //** scilab index start from 1
      II=[];
      switchtxt=list()
      for i=1: Noutport
        switchtxt(i)=write_code_doit(clkptr(bk)+i-1,flag);
        if switchtxt(i)<>[] then II=[II i];end
      end
      if II<>[] then
        txt=[txt;
             '  '+get_comment('evtselect_blk',list(bk));]
        //** C **//
        tmp_='*(('+TYPE+' *)'+rdnom+'_block_outtbptr['+string(ix)+'])'
        txt=[txt;
             '  i=max(min((int) '+...
              tmp_+',block_'+rdnom+'['+string(bk-1)+'].nevout),1);'
             '  switch(i)'
             '  {']
        //*******//
        for i=II
         //** C **//
         txt=[txt;
              '   case '+string(i)+' :';]
         //*******//
         txt=[txt;
              BigIndent+write_code_doit(clkptr(bk)+i-1,flag);]
         //** C **//
         txt=[txt;
              BigIndent+'break;']
         //*******//
        end
        //** C **//
        txt=[txt;
             '  }'];
        //*******//
      end
    //** Unknown block
    else
      error('Unknown block type '+string(bk));
    end
  end

endfunction

