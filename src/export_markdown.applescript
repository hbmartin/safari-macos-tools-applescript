tell application "Safari"
	set linkList to ""
	
	repeat with w in windows
		set windowId to id of w
		if windowId < 0 then
			exit repeat
		end if
		set linkList to linkList & "# Window " & (windowId as string) & "
"
		
		set tabCount to count of tabs of w
		repeat with t from tabCount to 1 by -1
			set theTab to tab t of w
			try
				set theURL to URL of theTab
				set theURL to my replace_chars(theURL, "(", "%28")
				set theURL to my replace_chars(theURL, ")", "%29")
				set linkList to linkList & "* [" & (name of theTab) & "](" & theURL & ")
"
			on error errMsg
				log errMsg
				exit repeat
			end try
		end repeat
		set linkList to linkList & "
"
	end repeat
	
	set {year:y, month:m, day:d, time:t} to (current date)
	set day_str to text -1 thru -2 of ("00" & d)
	set mon_str to text -1 thru -2 of ("00" & (m * 1))
	set d to (y & "-" & mon_str & "-" & day_str & "-" & t) as text
	set theDesktop to path to desktop as text
	set theFile to theDesktop & "SafariSnapshot-" & d & ".md"
	log theFile
	my writeTextToFile(linkList, theFile, true)
end tell



on writeTextToFile(theText, theFile, overwriteExistingContent)
	try
		
		set theFile to theFile as string
		do shell script "touch " & (POSIX path of theFile)
		
		-- Open the file for writing
		set theOpenedFile to open for access file theFile with write permission
		
		-- Clear the file if content should be overwritten
		if overwriteExistingContent is true then set eof of theOpenedFile to 0
		
		-- Write the new content to the file
		write theText to theOpenedFile starting at eof
		
		-- Close the file
		close access theOpenedFile
		
		-- Return a boolean indicating that writing was successful
		return true
		
		-- Handle a write error
	on error errMsg
		log errMsg
		
		-- Close the file
		try
			close access file theFile
		end try
		
		-- Return a boolean indicating that writing failed
		return false
	end try
end writeTextToFile

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars