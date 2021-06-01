Function RemoveFileExtension(inputFileName)
    IF NOT inStr(inputFileName, ".") > 0 THEN
        ' Period not found
        strReturnvalue = inputFileName
    ELSE
        ' Period found. Locate last 
        intPositionRight = 1
        DO WHILE NOT inStr(right(inputFileName, intPositionRight), ".") > 0
            intPositionRight = intPositionRight + 1
        LOOP
        strReturnvalue = left(inputFileName, len(inputFileName) - intPositionRight)
    END IF

    RemoveFileExtension = strReturnvalue
End Function

'Begin the main Script
'Order of input parameters:
'1. (required) Target path
'2. (optional) Shortcut Name (default: Target name, to skip this argument, pass "")
'3. (optional) shortcut description
'4. (optional) launch command line for program
'5. (optional) shortcut icon path and index
if WScript.Arguments.Count >= 1 then
	Set FSO = CreateObject("Scripting.FileSystemObject")
	Set oWS = WScript.CreateObject("WScript.Shell")
	
	ScriptDir = FSO.GetParentFolderName(WScript.ScriptFullName) & "\"
	TargetPath = WScript.Arguments(0)
	
	'default: LinkPath = Target name
	LinkPath = ScriptDir & RemoveFileExtension(FSO.GetFileName(TargetPath)) & ".lnk"
	if WScript.Arguments.Count >= 2 then 
		if Len(WScript.Arguments(1)) <> 0 then
			'A name was supplied
			LinkPath = ScriptDir & WScript.Arguments(1) & ".lnk"
		end if
	end if
	
	Set oLink = oWS.CreateShortcut(LinkPath)
	oLink.TargetPath = TargetPath
	
	'WScript.Echo ScriptDir
	'WScript.Echo TargetPath
	'WScript.Echo LinkPath
		
	'The following are optional parameters
	if WScript.Arguments.Count >= 3 then
		oLink.Description = WScript.Arguments(2)
		
		if WScript.Arguments.Count >= 4 then
			oLink.Arguments = WScript.Arguments(3)
			
			if WScript.Arguments.Count >= 5 then
				oLink.IconLocation = WScript.Arguments(4)
			end if
		end if
	end if
	'Create the shortcut
	oLink.Save
else
	WScript.Echo "there be no parameters!"
end if