#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\Artwork\Van Peter\turtlestitchlogo.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	 AutoIt Version:
	 Author:         Hans de Jong

	 Script Function:


#ce ----------------------------------------------------------------------------

; -----------------------------------------
; Make sure to update the version number when having made changes
; -----------------------------------------
Local $Version="Version 0.2"

; Variables that can be changed if needed
Local Const $TSRemote = "Remote"			; Browser will be started with the $RemoteURL
Local Const $TSLocalHost = "LocalHost"		; Browser will be started with $LocalURL
Local Const $TSLocalFile = "LocalFile"		; Browser will be starated with the $IndexFile in the most recent subfolder in $OfflineFolder in - in this priority order - Desktop, Documents and Downloads folders

; Here you can set the flavour of the program
Local Const $WhereIsTS = $TSRemote		; Choose which version this is. Choose from $TSRemote, $TSLocalHost and $TSLocalFile


Local Const $LocalHostURL = "http://localhost:8000"
Local Const $RemoteURL = "https://turtlestitch.org/run"
Local Const $OfflineFolder = "TurtleStitch\Offline"
Local Const $IndexFile="index.html"

Local Const $TimeLogFile = "TurtleStTimelog.txt"
Local Const $DeleteTimeLogOlderThan = 432000	; delete TimeLogFiles that have not been modified for more than 5 days (= 432000 seconds)

if @Compiled=False then $Version = stringreplace(@ScriptName,".au3","")


; -----------------------------------------
; #includes
; -----------------------------------------

#include <WinAPIShellEx.au3>
#include <Date.au3>
#include <MsgBoxConstants.au3>
#include <Misc.au3>
#include <File.au3>

;First find the path of the download folder on this machine
Local $s_Path_Downloads = _WinAPI_ShellGetKnownFolderPath($FOLDERID_Downloads)
Local $s_Path_Documents = _WinAPI_ShellGetKnownFolderPath($FOLDERID_Documents)
Local $s_Path_Desktop = _WinAPI_ShellGetKnownFolderPath($FOLDERID_Desktop)

Local $TimeLogPath = $s_Path_Downloads & "\" & $TimeLogFile

; Log the time that the program was started

; if the TimeLog file is old then delete it. Old means not modified for a long time.
if WhenLastModified($TimeLogPath) > $DeleteTimeLogOlderThan then FileDelete($TimeLogPath)

; write the timestamp so that we can later find out how long a design took to make
FileWriteLine($TimeLogPath, "TSStart=" & NowAsString() & @CRLF)

;ConsoleWrite ("$NowAsNumber=" & NowAsNumber() & @CRLF)
Local $FileAgeInSeconds = WhenLastModified($TimeLogPath)
;consolewrite ("$FileAgeInSeconds=" & $FileAgeInSeconds & @CRLF)

;ConsoleWrite("X" & FindNewestFolder($s_Path_Documents & "\" & $OfflineFolder, "*" ) & "x" & @CRLF)

Local $Header=$Version & " " & $WhereIsTS
Local $result= $IDOK  ;initialize the variable for the case shift is not pressed
Switch $WhereIsTS
	Case $TSLocalHost
		if IsShiftPressed() then $result=MsgBox($MB_OKCANCEL,$Header, "Starting browser with " & $LocalHostURL)
		if $result <> $IDOK then exit
		ShellExecute($LocalHostURL)
	Case $TSLocalFile
		Local $LocalFileURL
		$LocalFileURL=FindNewestFolder($s_Path_Desktop & "\" & $OfflineFolder, "*" ) & "\" & $IndexFile

		if Not FileExists($LocalFileURL) then
			$LocalFileURL=FindNewestFolder($s_Path_Documents & "\" & $OfflineFolder, "*" ) & "\" & $IndexFile
			if Not FileExists($LocalFileURL) then
				$LocalFileURL=FindNewestFolder($s_Path_Downloads & "\" & $OfflineFolder, "*" ) & "\" & $IndexFile
				if Not FileExists($LocalFileURL) then
					MsgBox($MB_OK, $Header, "There is no file " & $IndexFile & " in neither " & @CRLF & $s_Path_Desktop & "\" & $OfflineFolder & @CRLF & $s_Path_Documents & "\" & $OfflineFolder & @CRLF & $s_Path_Downloads & "\" & $OfflineFolder )
					Exit
				EndIf
			EndIf
		EndIf

		ConsoleWrite("URL=" & $LocalFileURL & @CRLF)
		$LocalFileURL="file:///" & $LocalFileURL
		if IsShiftPressed() then $result=MsgBox($MB_OKCANCEL,$Header, "Starting browser with " & $LocalFileURL)
		if $result <> $IDOK then exit
		ShellExecute( $LocalFileURL)
	Case $TSRemote
		if IsShiftPressed() then $result=MsgBox($MB_OKCANCEL,$Header, "Starting browser with " & $RemoteURL)
		if $result <> $IDOK then exit
		ShellExecute($RemoteURL)
EndSwitch


; NowAsString() returns the current time in a format of YYYY-MM-DD--hh-mm-ss
Func NowAsString()
	local $Now= _NowCalc()
	ConsoleWrite("Now=" & $Now & @CRLF)
	$Now=stringreplace($Now, "/", "-")
	$Now=StringReplace($Now, " ", "--")
	$Now=StringReplace($Now, ":", "-")
	;ConsoleWrite("Now=" & $Now & @CRLF)
	Return $Now
EndFunc

; WhenLastModified() returns how long ago the file in $FilePath was last modified in seconds
Func WhenLastModified ( $FilePath )
	$FileTime=FileGetTime($FilePath, $FT_MODIFIED, $FT_STRING)
	consolewrite ("Filetime=" & $FileTime & @CRLF)
	Return NowAsNumber() - $FileTime
EndFunc

; NowAsNumber() returns the current time as YYYYMMDDhhmmss
Func NowAsNumber()
	Local $Now = _NowCalc()
	$Now=stringreplace($Now, "/", "")
	$Now=StringReplace($Now, " ", "")
	$Now=StringReplace($Now, ":", "")
	Return $Now
EndFunc

; This function checks whether one of the Shift keys is pressed and returns TRUE if so. False otherwise
Func IsShiftPressed()
	Local $hDLL = DllOpen("user32.dll")
	If _IsPressed("10", $hDLL) Then
		ConsoleWrite("_IsPressed - Shift Key was pressed. @extended = " & @extended & @CRLF)
		DllClose($hDLL)
		Return True
	Else
		DllClose($hDLL)
		Return False
	EndIf
EndFunc   ;==>IsShiftPressed

Func FindIndexFile ($PathToSearch)
	if not FileExists($PathToSearch) then return ""

EndFunc

Func FindNewestFolder($Folder, $SearchFor)
	Local $x
	Local $newest
	Local $Attrib
	Local $FileList = _FileListToArrayRec($Folder, $SearchFor, $FLTAR_FOLDERS, 0, 0, 2)

	$newname = ""
	If IsArray($FileList) Then
		; consolewrite("Filelist[0]=" & $FileList[0]&@CRLF)
		;MsgBox(4096,"",$FileList[0])
		For $x = 1 To $FileList[0]
			;MsgBox(4096,"",$FileList[$x])
			; consolewrite("Filelist["& $x & "]="& $Filelist[$x] & @crlf)
			$Attrib=FileGetAttrib($FileList[$x])
			If FileGetTime($FileList[$x], $FT_MODIFIED, $FT_STRING) > $newest Then
				$newest = FileGetTime($FileList[$x], $FT_MODIFIED, $FT_STRING)
				$newname = $FileList[$x]
				;MsgBox(64,"Newest", $newest)
			EndIf
		Next
	EndIf

	Return $newname
EndFunc   ;==>FindNewestFile