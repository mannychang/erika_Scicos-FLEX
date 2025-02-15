function libn=ilib_for_link(names,files,libs,flag,makename,loadername,libname,ldflags,cflags,fflags,cc)
// Copyright Enpc 
// Generate a shared library which can be used by link 
// command. 
// names = names of entry points or the name of the library to 
// be built (when flag == 'g') 
// files = object files to be built 
// flag = 'c' or 'f' or '
// 
  [lhs,rhs]=argn(0);
  info=1
  if rhs <= 4 then makename = 'Makelib';end
  if rhs <= 5 then loadername = 'loader.sce';end
  if rhs <= 6 then libname = ""; end
  if rhs <= 7 then ldflags = ""; end 
  if rhs <= 8 then cflags  = ""; end 
  if rhs <= 9 then fflags  = ""; end 
  if rhs <= 10 then cc  = ""; end 
  // generate a loader file
  if info==1 then write(%io(2),'   generate a loader file');end
  
  ilib_link_gen_loader(names,flag,loadername,libs,libname);
  // generate a Makefile
  if info==1 then write(%io(2),'   generate a Makefile: Makelib');end
  ilib_link_gen_Make(names,files,libs,makename,libname,...
		     ldflags,cflags,fflags,cc,flag);
  // we call make
  if info==1 then write(%io(2),'   running the makefile');end
  if libname=="" then libname = names(1);end
  libn=ilib_compile('lib'+libname,makename,files);
endfunction

function ilib_link_gen_loader(names,flag,loadername,libs,libname)
//------------------------------------
  rhs=argn(2)
  if rhs <= 4 then libname = ""; end 
  if rhs <= 3 then libs=[]; end 
  if rhs <= 2 then loadername = 'loader.sce' ; end 
  comp_target = COMPILER;
  // suffix to be used for dll
  if with_lcc()==%T then
  	if getenv('WIN32','NO')=='OK' then
  		lib_suf='dll';
  	end
  
  else if getenv('WIN32','NO')=='OK' then
    	select comp_target
     		case 'VC++'   then lib_suf='dll';
    		else lib_suf='dll';
    	end
  	else
     		lib_suf=ilib_unix_soname();
  	end
  end
  if libname=="" then libname = names(1);end 
    
  fd=mopen(loadername,"w");
  mfprintf(fd,"// generated by builder.sce: Please do not edit this file\n");
  mfprintf(fd,"// ------------------------------------------------------\n");
  mfprintf(fd,"%s_path=get_absolute_file_path(''%s'');\n",libname,basename(loadername+'.x'));
  nl=size(libs,'*') 
  for i=1:nl 
    if part(libs(i),1)=='/' then
      mfprintf(fd,"link(''%s.%s'');\n",libs(i),lib_suf);
    else
      [diri,basenamei,exti]=fileparts(libs(i));
      if (diri == '') then
        mfprintf(fd,"link(%s_path+''%s.%s'');\n",libname,libs(i),lib_suf);
      else
        mfprintf(fd,"link(''%s.%s'');\n",libs(i),lib_suf);
      end
    end
  end 
  mfprintf(fd,"link(%s_path+''lib%s.%s'',[",libname,libname,lib_suf);
  names=names(:)';
  n = size(names,'*');
  for i=1:n
      	mfprintf(fd,"''%s''",names(i))
   
    if i <>n ; mfprintf(fd,","); else mfprintf(fd,"],");end
  end
  mfprintf(fd,"''%s'');\n",flag);
  mclose(fd);
endfunction

function ilib_link_gen_Make(names,files,libs,makename,libname,ldflags,cflags,fflags,cc,flag)
//------------------------------------
// generate a Makefile for gateway
  [lhs,rhs]=argn(0);
  if rhs <= 2 then libs = [];end
  if rhs <= 3 then makename = 'Makelib';end
  if rhs <= 4 then libname = "";end
  if rhs <= 5 then ldflags = ""; end 
  if rhs <= 6 then cflags  = ""; end 
  if rhs <= 7 then fflags  = ""; end 
  if rhs <= 8 then cc  = ""; end 
  if rhs <= 9 then flag  = "c"; end 
  comp_target = COMPILER;
  if with_lcc()==%T then
  	Makename = makename+'.lcc';
  	ilib_link_gen_Make_lcc(names,files,libs,Makename,libname,...
			       ldflags,cflags,fflags,cc,flag)
  else if getenv('WIN32','NO')=='OK' then
    select comp_target
     case 'VC++'   then Makename = makename+'.mak'
      ilib_link_gen_Make_win32(names,files,libs,Makename,libname,...
			       ldflags,cflags,fflags,cc)
     case 'gcc' then 
      // cygwin assumed 
      Makename = makename;
      ilib_link_gen_Make_unix(names,files,libs,Makename,libname,...
			      ldflags,cflags,fflags,cc)
    else 
       Makename = makename;
       ilib_link_gen_Make_win32(names,files,libs,Makename,libname,...
				ldflags,cflags,fflags,cc)
    end
  else
     Makename = makename;
     ilib_link_gen_Make_unix(names,files,libs,Makename,libname,...
			     ldflags,cflags,fflags,cc)
  end
  end
endfunction

function ilib_link_gen_Make_unix(names,files,libs,Makename,libname, ...
				 ldflags,cflags,fflags,cc)
  
  if libname=="" then libname = names(1);end 
    
  fd=mopen(Makename,"w");
  mfprintf(fd,"# generated by builder.sce: Please do not edit this file\n");
  mfprintf(fd,"# ------------------------------------------------------\n");
  mfprintf(fd,"SCIDIR = %s\n",SCI);
  mfprintf(fd,"OBJS = ")
  for x=files(:)' ; mfprintf(fd," %s",x);end
  mfprintf(fd,"\n") ;
  mfprintf(fd,"OTHERLIBS = ")
  
  // add .a 
  // for compatibility test if we have already a .a
  for x=libs(:)' ;
   [path,fname,extension]=fileparts(x);
   if (extension == '') then
     mfprintf(fd," %s.a",x);
   else
     mfprintf(fd," %s",x);
   end
  end
    
  mfprintf(fd,"\n") ;
  mfprintf(fd,"LIBRARY = lib%s\n",libname);
  mfprintf(fd,"include $(SCIDIR)/Makefile.incl\n");
  if cc<>"" then 
    mfprintf(fd,"CC="+cc+ "\n");
  end
  if getenv('WIN32','NO')=='OK' then
    // cygwin 
    mfprintf(fd,"OTHERLIBS = ");
    for x=libs(:)' ; mfprintf(fd," %s.a",x);end
    mfprintf(fd,"\n");
    mfprintf(fd,"CFLAGS = $(CC_OPTIONS) -DFORDLL -I\""$(SCIDIR)/routines\"""+...
	     " -Dmexfunction_=mex$*_  -DmexFunction=mex_$* "+ cflags +" \n"); 
    mfprintf(fd,"FFLAGS = $(FC_OPTIONS) -DFORDLL -I\""$(SCIDIR)/routines\"""+...
	     " -Dmexfunction=mex$* "+ fflags +"\n"); 
  else
     mfprintf(fd,"CFLAGS = $(CC_OPTIONS) "+cflags+ "\n");
     mfprintf(fd,"FFLAGS = $(FC_OPTIONS) "+fflags+ "\n");
  end
  mfprintf(fd,"EXTRA_LDFLAGS = "+ ldflags+ "\n");
  if getenv('WIN32','NO')=='OK' then
    // cygwin assumed : we use a specific makedll 
    // and not libtool up to now XXX 
    mfprintf(fd,"include $(SCIDIR)/config/Makecygdll.incl\n");
  else
     mfprintf(fd,"include $(SCIDIR)/config/Makeso.incl\n");
  end
  mclose(fd);
endfunction

function ilib_link_gen_Make_win32(names,files,libs,Makename,libname,ldflags, ...
				  cflags,fflags,cc)
				  
  if libname=="" then libname = names(1);end 
  fd=mopen(Makename,"w");
  mfprintf(fd,"# generated by builder.sce : Please do not edit this file\n");
  mfprintf(fd,"# ------------------------------------------------------\n");
  mfprintf(fd,"SCIDIR =%s\n",SCI);
  mfprintf(fd,"SCIDIR1 =%s\n",pathconvert(SCI,%f,%f,'w'));
  mfprintf(fd,"# name of the dll to be built\n"); 
  mfprintf(fd,"LIBRARY = lib%s\n",libname);
  mfprintf(fd,"# list of objects file\n");
  mfprintf(fd,"OBJS =");
  for x=files(:)' ; mfprintf(fd," %s",strsubst(x,".o",".obj"));end
  mfprintf(fd,"\n# added libraries \n");
  mfprintf(fd,"OTHERLIBS = ");
  for x=libs(:)' ; mfprintf(fd," ""%s.ilib"" ",x);end
  mfprintf(fd,"\n");
  mfprintf(fd,"!include $(SCIDIR1)\\Makefile.incl.mak\n");
  if cc<>"" then 
    mfprintf(fd,"CC="+cc+ "\n");
  end
  
  if findmsvccompiler() <>'msvc90express' then
    mfprintf(fd,"CFLAGS = $(CC_OPTIONS) -DFORDLL -I\""$(SCIDIR)/routines\"""+...
	   " -Dmexfunction_=mex$*_  -DmexFunction=mex_$* "+ cflags +" \n"); 
    mfprintf(fd,"FFLAGS = $(FC_OPTIONS) -DFORDLL -I\""$(SCIDIR)/routines\"""+...
	   " -Dmexfunction=mex$* "+ fflags +"\n"); 	   
  else	   
    mfprintf(fd,"CFLAGS = $(CC_OPTIONS) -DFORDLL -I\""$(SCIDIR)/routines\"""+...
	   " "+ cflags +" \n"); 
	  mfprintf(fd,"FFLAGS = $(FC_OPTIONS) -DFORDLL -I\""$(SCIDIR)/routines\"""+...
	   " "+ fflags +"\n"); 
  end
  
  mfprintf(fd,"EXTRA_LDFLAGS = "+ ldflags+"\n");
  mfprintf(fd,"!include $(SCIDIR1)\\config\\Makedll.incl \n");
  mclose(fd);
endfunction

//----------------------------------------------------------------------------------------------
function ilib_link_gen_Make_lcc(names,files,libs,Makename,libname,ldflags,cflags,fflags,cc,flag)
// Allan CORNET
// INRIA 2004
  
  if libname == "" then libname = names(1);end 
  fd=mopen(Makename,"w");
  mfprintf(fd,"# ------------------------------------------------------------\n");
  mfprintf(fd,"# generated by builder.sce (lcc): Please do not edit this file\n");
  mfprintf(fd,"# ------------------------------------------------------------\n\n");
  mfprintf(fd,"SCIDIR =%s\n",SCI);
  mfprintf(fd,"SCIDIR1 =%s\n",pathconvert(SCI,%f,%f,'w'));
  mfprintf(fd,"DUMPEXTS=""$(SCIDIR1)\\bin\\dumpexts""\n");
  if ( with_atlas()==%T ) then
  	mfprintf(fd,"SCIIMPLIB=$(SCIDIR1)\\bin\\LibScilabLCC.lib $(SCIDIR1)\\bin\\atlaslcc.lib $(SCIDIR1)\\bin\\libf2clcc.lib $(SCIDIR1)\\bin\\arpacklcc.lib $(SCIDIR1)\\bin\\lapacklcc.lib\n\n");
  else
  	mfprintf(fd,"SCIIMPLIB=$(SCIDIR1)\\bin\\LibScilabLCC.lib\n\n");
  end
  mfprintf(fd,"CC=lcc\n");
  mfprintf(fd,"LINKER=lcclnk\n");
  //mfprintf(fd,"CFLAGS=-I""$(SCIDIR)/routines"" -Dmexfunction_=mex$*_  -DmexFunction=mex_$* "+ cflags +" \n"); 
  mfprintf(fd,"CFLAGS=-I""$(SCIDIR)/routines"" -I""$(SCIDIR)/routines/f2c"" -Dmexfunction_=mex$*_ -DmexFunction=mex_$* -DWIN32 -DSTRICT -DFORDLL -D__STDC__ -DHAVE_EXP10 "+ cflags +" \n"); 
  mfprintf(fd,"LINKER_FLAGS=-dll -nounderscores\n");
  mfprintf(fd,"EXTRA_LDFLAGS = "+ ldflags+"\n");
  mfprintf(fd,"O=.obj\n");
 
  mfprintf(fd,"# name of the dll to be built\n"); 
  mfprintf(fd,"LIBRARY = lib%s\n",libname);
  mfprintf(fd,"\n# list of objects file\n");
  
  if (flag =='c') then
  	mfprintf(fd,"OBJSC =");
  	for x=files(:)' ;
  		x=strsubst(x,".obj","");
   		x=strsubst(x,".o","");
   		mfprintf(fd," %s$(O)",x);
   	end
  
  	mfprintf(fd,"\nOBJSF=\n");
  else
  	mfprintf(fd,"OBJSC =\n");
  	mfprintf(fd,"\nOBJSF=");
  	for x=files(:)' ;
  		x=strsubst(x,".obj","");
   		x=strsubst(x,".o","");
   		mfprintf(fd," %s$(O)",x);
   	end
  end
  
  mfprintf(fd,"\nOBJS = $(OBJSC) $(OBJSF)\n");
  
  mfprintf(fd,"\n# added libraries \n");
  mfprintf(fd,"OTHERLIBS =");
  for x=libs(:)' ;
  	mfprintf(fd," ""%s.ilib""",x);
  end
  mfprintf(fd,"\n");
  
  mfprintf(fd,"\nall :: $(LIBRARY).dll\n");
  mfprintf(fd,"\n$(LIBRARY).dll: $(OBJS)\n");
  mfprintf(fd,"	$(DUMPEXTS) -o ""$(LIBRARY).def"" ""$*"" $(OBJS)\n");
  mfprintf(fd,"	$(LINKER) $(LINKER_FLAGS) $(OBJS) $(OTHERLIBS) $(SCIIMPLIB) $(XLIBSBIN) $(TERMCAPLIB) $(EXTRA_LDFLAGS) $*.def -o $(LIBRARY).dll\n\n");
 

  for x=files(:)' ;
  	x=strsubst(x,".obj","");
   	x=strsubst(x,".o","");
  	mfprintf(fd,"%s$(O):\n",x);
  	if (flag =='c') then
  		mfprintf(fd,"	$(CC) $(CFLAGS) $*.c\n\n");
  	else
  		mfprintf(fd,"	@$(SCIDIR1)\\bin\\f2c.exe $*.f \n");
		mfprintf(fd,"	@$(CC) $(CFLAGS) $*.c \n");
		mfprintf(fd,"	del $*.c \n");
	end
  end
	
  mfprintf(fd,"clean:\n");
  mfprintf(fd,"	del *.obj\n");
  mfprintf(fd,"	del *.dll\n");
  mfprintf(fd,"	del *.lib\n");
  mfprintf(fd,"	del *.def\n");
 
 mclose(fd);
endfunction
//----------------------------------------------------------------------------------------------
