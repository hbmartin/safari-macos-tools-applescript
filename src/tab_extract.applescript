on run {searchTerm}
	tell application "Safari"
		set foundTabs to {}
		
		repeat with w in windows
			set windowId to id of w
			if windowId < 0 then
				exit repeat
			end if
			set tabCount to count of tabs of w
			repeat with t from tabCount to 1 by -1
				set theTab to tab t of w
				set tabTitle to name of theTab
				set tabURL to URL of theTab
				
				if (tabTitle contains searchTerm or tabURL contains searchTerm) then
					set end of foundTabs to theTab
				end if
			end repeat
		end repeat
		log foundTabs
		if (count of foundTabs) > 0 then
			make new document
			set newWindow to front window
			log newWindow
			tell newWindow
				repeat with theTab in foundTabs
					move theTab to end of tabs of newWindow
				end repeat
				close tab 1 of newWindow
			end tell
		end if
	end tell
end run