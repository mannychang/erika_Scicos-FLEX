mode(-1);
// specific part
libname='dspic' // name of scilab function library [CUSTOM]
DIR = get_absolute_file_path('loader.sce');

// You should also modify the  ROUTINES/loader.sce with the new 
// Scilab primitive for the path

dspiclib_cg = lib(DIR+'/macros/codegen/')
dspiclib_fb_FLEX = lib(DIR+'/macros/flex_blocks/FLEX/')
dspiclib_fb_comm = lib(DIR+'/macros/flex_blocks/FLEX-Communication/')
dspiclib_fb_DMB = lib(DIR+'/macros/flex_blocks/FLEX-DMB/')
dspiclib_fb_MTB = lib(DIR+'/macros/flex_blocks/FLEX-MTB/')
dspiclib_fb_pc = lib(DIR+'/macros/flex_blocks/FLEX-PC/')
dspiclib_fb_amazing = lib(DIR+'/macros/flex_blocks/AMAZING/')
dspiclib_misc = lib(DIR+'/macros/misc/')
