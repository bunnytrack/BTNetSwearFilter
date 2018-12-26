# BTNetSwearFilter
A basic swear filter for Unreal Tournament. 

## Installation
1. Place .u file in server's UT/System folder.
2. Add to your server's UT.ini:  
`ServerActors=BTNetSwearFilter.SwearFilter`

## To Do
* Make case-insensitive
* Add more swear words
* Create .ini by default via `SaveConfig()`
* Optionally allow swear words as part of other legitimate words (e.g. "Scunthorpe")
