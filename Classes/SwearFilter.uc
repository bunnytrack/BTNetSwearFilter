class SwearFilter extends Mutator config(BTNetSwearFilter);

var config string WordList[1024];
var config bool bActive;

function PreBeginPlay() {
	// Register mutator
	Level.Game.BaseMutator.AddMutator(self);
	Level.Game.RegisterMessageMutator(Self);
}

simulated event PostBeginPlay() {

	Super.PostBeginPlay();

	Log("");
	Log("+--------------------------------------------------------------------------+");
	Log("| BTNetSwearFilter                                                         |");
	Log("| ------------------------------------------------------------------------ |");
	Log("| Author:      Dizzy <dizzy@bunnytrack.net>                                |");
	Log("| Description: User-controllable swear filter for UT in-game chat          |");
	Log("| Version:     2017-07-24                                                  |");
	Log("| Website:     bunnytrack.net                                              |");
	Log("| ------------------------------------------------------------------------ |");
	Log("| Released under the Creative Commons Attribution-NonCommercial-ShareAlike |");
	Log("| license. See https://creativecommons.org/licenses/by-nc-sa/4.0/          |");
	Log("+--------------------------------------------------------------------------+");

}

function bool MutatorTeamMessage( Actor Sender, Pawn Receiver, PlayerReplicationInfo PRI, coerce string S, name Type, optional bool bBeep ) {

	local int i, k;
	local bool found;

	found = false;

	if (Sender == Receiver) {

		for (i = 0; i < ArrayCount(WordList); i++) {
			
			if (WordList[i] != "") {

				// Check if string contains word
				if (S != ReplaceText(S, WordList[i], "")) {

					found = true;

					S = ReplaceText(S, WordList[i], StrRepeat("*", Len(WordList[i])));

				}

			}

		}

		if (found) {

			if (string(Type) == "Say") {
				PlayerPawn(Sender).Say(S);
			}

			if (string(Type) == "TeamSay") {
				PlayerPawn(Sender).TeamSay(S);
			}

			return false;

		}

	}

	// Otherwise, pass to next message mutator
	if (NextMessageMutator != None) {
		return NextMessageMutator.MutatorTeamMessage(Sender, Receiver, PRI, S, Type, bBeep);
	}

	return Super.MutatorTeamMessage(Sender, Receiver, PRI, S, Type, bBeep);

}

/*
 * Custom ReplaceText function
 */
static final function string ReplaceText(coerce string Haystack, coerce string Needle, coerce string Replacement)
{
	local int i;
	local string Output;
 
	i = InStr(Haystack, Needle);
	while (i != -1) {	
		Output = Output $ Left(Haystack, i) $ Replacement;
		Haystack = Mid(Haystack, i + Len(Needle));	
		i = InStr(Haystack, Needle);
	}
	Output = Output $ Haystack;
	return Output;
}


// Custom
static final function string StrRepeat(string input, int multiplier) {

	local string result;
	local int i;
 
	for (i = 0; i < multiplier; i++) {
		result = result $ input;
	}
 
	return result;
}



static final function string Lower(coerce string Text) {
 
  local int IndexChar;
 
  for (IndexChar = 0; IndexChar < Len(Text); IndexChar++)
    if (Mid(Text, IndexChar, 1) >= "A" &&
        Mid(Text, IndexChar, 1) <= "Z")
      Text = Left(Text, IndexChar) $ Chr(Asc(Mid(Text, IndexChar, 1)) + 32) $ Mid(Text, IndexChar + 1);
 
  return Text;

}

defaultproperties {
	bActive=true
	bAlwaysRelevant=true
	RemoteRole=ROLE_SimulatedProxy
	WordList(0)="fuck"
	WordList(1)="shit"
	WordList(2)="cunt"
}
