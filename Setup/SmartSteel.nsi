; Script generated by the HM NIS Edit Script Wizard.

!system "GetVersion.exe SmartSteel.exe"
!include "VersionNo.nsi"

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "SmartSteel"
!define PRODUCT_PUBLISHER "TechSun"
!define PRODUCT_WEB_SITE "http://www.TechSun.co.kr"
!define PRODUCT_DIR_REGKEY "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
!define PRODUCT_UNINST_KEY "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}\Uninstall"
!define PRODUCT_UNINST_ROOT_KEY "hklm"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_HEADERIMAGE
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Component page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY

; MSTN J폴더를 선택하는 페이지
Var vMSTNJFolder
!define TEMP1 $R0 ;Temp variable
Page custom ${PRODUCT_NAME}_NSIS ${PRODUCT_NAME}_NSISLeave

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_NAME}.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "Korean"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Installation\${PRODUCT_NAME}.${PRODUCT_VERSION}.exe"

InstallDir "$PROGRAMFILES\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reverse a string
;; P1 :o: Reversed string
;; P2 :i: Original string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!define StrRev "!insertmacro _StrRev"
!macro _StrRev _REV_ _STR_
   Push "${_STR_}"
   Call StrRev
   Pop ${_REV_}
!macroend

Function StrRev
   Exch $1  ;; Orig string
   Push $0  ;; Reversed string
   Exch
   Push $2  ;; String Len / Counter
   Push $3  ;; Current character

   StrCpy $0 ""
   StrLen $2 "$1"

   IntCmp $2 0 +5
      IntOp $2 $2 - 1
      StrCpy $3 "$1" 1 $2
      StrCpy $0 "$0$3"
      Goto -4

   Pop $3
   Pop $2
   Pop $1
   Exch $0
FunctionEnd

!define StrLoc "!insertmacro StrLoc"

!macro StrLoc ResultVar String SubString StartPoint
  Push "${String}"
  Push "${SubString}"
  Push "${StartPoint}"
  Call StrLoc
  Pop "${ResultVar}"
!macroend

Function StrLoc
/*After this point:
  ------------------------------------------
   $R0 = StartPoint (input)
   $R1 = SubString (input)
   $R2 = String (input)
   $R3 = SubStringLen (temp)
   $R4 = StrLen (temp)
   $R5 = StartCharPos (temp)
   $R6 = TempStr (temp)*/

  ;Get input from user
  Exch $R0
  Exch
  Exch $R1
  Exch 2
  Exch $R2
  Push $R3
  Push $R4
  Push $R5
  Push $R6

  ;Get "String" and "SubString" length
  StrLen $R3 $R1
  StrLen $R4 $R2
  ;Start "StartCharPos" counter
  StrCpy $R5 0

  ;Loop until "SubString" is found or "String" reaches its end
  ${Do}
    ;Remove everything before and after the searched part ("TempStr")
    StrCpy $R6 $R2 $R3 $R5

    ;Compare "TempStr" with "SubString"
    ${If} $R6 == $R1
      ${If} $R0 == `<`
        IntOp $R6 $R3 + $R5
        IntOp $R0 $R4 - $R6
      ${Else}
        StrCpy $R0 $R5
      ${EndIf}
      ${ExitDo}
    ${EndIf}
    ;If not "SubString", this could be "String"'s end
    ${If} $R5 >= $R4
      StrCpy $R0 ``
      ${ExitDo}
    ${EndIf}
    ;If not, continue the loop
    IntOp $R5 $R5 + 1
  ${Loop}

  ;Return output to user
  Pop $R6
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch
  Pop $R1
  Exch $R0
FunctionEnd

Function ${PRODUCT_NAME}_NSIS
    Push ${TEMP1}
    SetOutPath "$INSTDIR"
    File /oname=$INSTDIR\${PRODUCT_NAME}_NSIS.ini "${PRODUCT_NAME}_NSIS.ini"

    !insertmacro MUI_HEADER_TEXT 'Write Module' 'MSTN J 설치 폴더를 선택하세요'

    ; get microstation j folder
    ReadRegStr $1 HKLM SOFTWARE\Bentley\MicroStation\07.01 "PathName"
    ${StrRev} $0 "$1"   ;; $StrVar="gnirtS"
    ${StrLoc} $R0 $0 '\' '<'
    StrCpy $0 "$1" $R0 # get mstn j folder
    WriteINIStr "$INSTDIR\SmartISO_NSIS.ini" "Field 2" "State" "$0"

    InstallOptions::dialog "$INSTDIR\${PRODUCT_NAME}_NSIS.ini"
    Pop ${TEMP1}

  Pop ${TEMP1}
FunctionEnd

Function ${PRODUCT_NAME}_NSISLeave
    ReadINIStr $vMSTNJFolder "$INSTDIR\${PRODUCT_NAME}_NSIS.ini" "Field 2" "State"

    ${StrRev} $0 $vMSTNJFolder  ;; $StrVar="gnirtS"
    ${StrLoc} $R0 $0 '\' '<'
    StrCpy $0 $vMSTNJFolder $R0
    ${StrRev} $1 $0  ;; $StrVar="gnirtS"
    ${StrLoc} $R0 $1 '\' '<'
    StrCpy $0 "$0" $R0 # get mstn j folder

    ;copy macro and pen table files to workspace\system\macros and workspace\system\tables\pen folder
    ${If} $0 != ""
        File /oname=$0\Program\MicroStation\mdlapps\FWPTool.ma  "Backup\FWPTool.ma"
    ${EndIf}
FunctionEnd

;-------------------------------
; Install Visual Studio Redistributables 2008+ SP1
; 2013.06.10
Function InstallVC2008Redist
   Push $R0
   ClearErrors
   ; check Redistributables is installed on x64
   ReadRegDword $R0 HKLM "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{887868A2-D6DE-3255-AA92-AA0B5A59B874}" "Version"
   IfErrors 0 VSRedistInstalled
   ; check Redistributables is installed on x26
   ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{887868A2-D6DE-3255-AA92-AA0B5A59B874}" "Version"
   ; if VS 2008+ redist SP1 not installed, install it
   IfErrors 0 VSRedistInstalled
   IfFileExists "$INSTDIR\Temp\vcredist_x86_sp1.exe"  0 VSRedistInstalled
       ExecWait "$INSTDIR\Temp\vcredist_x86_sp1.exe"
   Delete "$INSTDIR\Temp\vcredist_x86_sp1.exe"

VSRedistInstalled:
   Pop $R0
FunctionEnd
   
Section "${PRODUCT_NAME}" SEC01
  SectionIn RO   ; 필수 설치 요소
  
  SetOutPath "$INSTDIR"
  SetOverwrite on
  File "${PRODUCT_NAME}.exe"

  SetShellVarContext all             ;;; create folders for all users - 2012.06.04 added by humkyung
  CreateDirectory "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe"

  File "${PRODUCT_NAME}.exe"
  File "python26.dll"
  File "is_vc90.dll"
  File "isutil_vc90.dll"
  File "isgui_vc90.dll"
  File "occlib_vc90.dll"
  File "sdnflib_vc90.dll"
  File "AutoUp_vc90.dll"
  File "BugTrap.dll"
  File "SmartLMSLib_vc90.dll"
  
  File "OpenCASCADE_release\*.dll"

  File "readme.txt"
  File "rgb.txt"
  
  SetOutPath "$INSTDIR\Backup"
  File "Backup\*.*"
  SetOutPath "$APPDATA\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
  File "Backup\SmartSteel.mdb"
     
  SetOutPath "$INSTDIR\Temp"
  File "Temp\vcredist_x86_sp1.exe"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"

  SetShellVarContext all
  
  CreateShortCut "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

; 설치하고 난 후...
Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${PRODUCT_NAME}.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "Version" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}\License" "IP" "175.126.145.37"
  WriteRegDWORD HKLM "${PRODUCT_DIR_REGKEY}\License" "Port" "2002"
 	
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PRODUCT_NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  
  Sleep 1000
  
  call InstallVC2008Redist
  ExecShell "open" "$INSTDIR\readme.txt"
SectionEnd

Function .onInit
    ReadRegStr $R0 HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
    StrCmp $R0 "" done

    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
        "${PRODUCT_NAME} is already installed. $\n$\nClick `OK` to remove the \
        previous version or `Cancel` to cancel this upgrade." \
        IDOK uninst
        Abort done

;Run the uninstaller
uninst:
       ClearErrors
       ExecWait '"$R0" _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
       ;abort          ; 프로그램 종료

       IfErrors no_remove_uninstaller
    ;You can either use Delete /REBOOTOK in the uninstaller or add some code
    ;here to remove the uninstaller. Use a registry key to check
    ;whether the user has chosen to uninstall. If you are using an uninstaller
    ;components page, make sure all sections are uninstalled.
no_remove_uninstaller:
done:
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name)는(은) 완전히 제거되었습니다."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(^Name)을(를) 제거하시겠습니까?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"

  Delete "$INSTDIR\*.exe"
  Delete "$INSTDIR\*.dll"

  SetShellVarContext all             ;;; create folders for all users - 2012.06.04 added by humkyung

  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}\Website.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  RMDir  "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
  
  Delete "$INSTDIR\Backup\*.*"
  RMDir "$INSTDIR\Backup"
  
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
