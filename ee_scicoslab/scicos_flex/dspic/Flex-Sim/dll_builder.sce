// Script to build the Flex-Sim dynamic library.
// Author: Dario Di Stefano, Evidence Srl.

//% vcupgrade.exe Flex-iSim.vcproj

if findmsvccompiler() == 'msvc100express'
  VC_BUILD_EXE = 'vcvars32.bat && msbuild ';
  VC_BUILD_OPT = '/t:rebuild ';
  VC_BUILD_PROJ = get_absolute_file_path('dll_builder.sce') + 'FlexSim.vcxproj ';
  VC_BUILD_PERSPECTIVE = '/p:Configuration=release ';
  VC_BUILD_PROPERTIES = '';
elseif findmsvccompiler() == 'msvc90express'
  VC_BUILD_EXE = ascii(34) + 'vcbuild' + ascii(34) + ' ';
  VC_BUILD_OPT = '/r ';
  VC_BUILD_PROJ = get_absolute_file_path('dll_builder.sce') + 'FlexSim.vcproj ';
  VC_BUILD_PERSPECTIVE = 'release ';
  VC_BUILD_PROPERTIES = '';
end

cmd = VC_BUILD_EXE + VC_BUILD_OPT + VC_BUILD_PROJ + VC_BUILD_PERSPECTIVE + VC_BUILD_PROPERTIES;
unix( cmd );
//clear cmd;
