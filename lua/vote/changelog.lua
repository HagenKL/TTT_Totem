<html>

<body bgcolor=#dbdbdb>

<div style="text-align: center;">

<div style="width: 80%; margin: 0px auto; border: 10px solid #ffd5a5; background-color: #ededed; padding: 10px; font-size: 12px; font-family: Tahoma; margin-top: 30px; color: #818181; text-align: left;">

<div style="font-size: 30px; font-family: impact; width: 100%; margin-bottom: 5px;">TTT Totem Changelog</div>

<br>

This is the changelog for Gamefreaks Addons / Totem! (Started Documenting 05/26/2017)<br>
This will only get shown once a day! <br>
It will get updated every time I have time to change something!<br>

<h2>Version 1.3 (10/06/2018):</h2>

- Updated TTT version to commit 1a1f4ac4e9150f9b3a2c65a21136b985c4d6419b <br>
- Updated Enhanced Notification Framework<br>
- A wrong vote now will let you lose 30 HP on the next round<br>
- You will be notified on a wrong vote<br>
- Reworked Role loading mechanic, to ensure that server and client are loading the roles in the same order. <br>
- Added an equipment GUI, indicating what passive items you own. <br>
- Added a tab to the F1 menu "Totem"<br>
<div style=" text-align: left; margin-left: 15px;">
	- Added buttons for binding the keys needed for Totem. <br>
	- Added an option to place a totem automaticially when the round begins.<br>
	- Added various options to disable / enbale clientside visuals.<br>
</div>
- Possible fix for rare red overlay after shinigamis respawn. <br>
- Added indicator above crosshair if the shinigami looks at traitors.<br>
- Added instant respawn if you die in Preparing.<br>
- Shinigami now actually receives roles of traitors, so they will be visible on the scoreboard.<br>
- Shinigami traitor GUI now updates, as traitors die.<br>
- Added small animations to Shinigami traitor GUI.<br>
- Added a start message, to let new players know about the F1 menu.<br>

<h2>Version 1.2.1 (06/10/2017):</h2>

- Fixed ConVar errors. <br>
- Fixed the changelog not being displayed. <br>
- Added a new ConVar to deactivate DeathGrip, but still have a Shinigami. Set ttt_shinigami_only 1 <br>
- Fixed a bug, that caused a red overlay to be displayed if the shinigami was killed by a headshot before. <br>

<h2>Version 1.2 (04/10/2017):</h2>

- Added all the features from the addon <b> TTT Totem Additions </b> ( by tkindanight / saibotk ): <br>
<div style=" text-align: left; margin-left: 15px;"> - A hint on the right side (Shinigami icon), to show that there is a Shinigami active in this round. <br>
- Added a notification for all teammates, to tell them who you are in a DeathGrip with. <br>
- Added a hint above your crosshair, if you're aiming on a player, who is in a DeathGrip with you or one of your teammate. <br>
- Added a GUI for the active Shinigami, displaying all the traitor's names in red boxes at the bottom of your screen. <br> </div>
- Fixed a bug, where the Totemhunter did not get credits for kills. <br>
- Fixed a bug, where the Shinigami was able to vote when in "Shinigamimode". <br>
- General bugfixes / performance improvements. <br>

<h2>Version 1.1.2 (13/08/2017):</h2>

- Added a fellow for the Jackal: <b> Sidekick </b> <br>
<div style=" text-align: left; margin-left: 15px;"> - Jackal has new Item in shop, The "Sidekick Deagle" <br>
- The hit player will turn into his Sidekick and will help him to victory! <br>
- All other players will still see him as the original role until his body gets identified. <br>
- The Sidekick does not have a shop and will turn into a Jackal when the other Jackal dies. <br> </div>

<h2>Version 1.1.1 (28/07/2017):</h2>

- Updated Second Chance GUI and modified health and percentages <br>
- The Little Helper now has a maximum health to block <br>
- Balanced Several Weapons <br>
- Optimized Code <br>

<h2>Version 1.1 (26/07/2017):</h2>

- Added new Passive: <b> Deathgrip </b> <br>
<div style=" text-align: left; margin-left: 15px;"> - Randomly gets distributed to two players in a round with a chance of 66,6% <br>
- If one of the two players die the other one dies too <br>
- When only the three players are alive the perk gets broken <br> </div>

- Added new Role: <b> Shinigami </b> <br>
<div style=" text-align: left; margin-left: 15px;"> - Will only get selected if there is a Death Grip <br>
- If he dies he respawn with a movement speed of 200% and an onehit knife <br>
- Does fight for the innocent and does not even know himself that he is the Shinigami <br> </div>


<h2>Version 1.0.2 (03/06/2017):</h2>

- Updated Door Buster to work with more doors <br>

- Completely Rewrote the Randomat to make event adding easier (thanks to monster010) <br>

<div style="width: 100%; text-align: left; margin: 5px; font-weight: bold;">Bugfixes:</div>

- Fixed a Bug that caused the Invert Event to continue even tho the round already ended <br>



<h2>Version 1.0.1 (03/06/2017):</h2>

<div style="width: 100%; text-align: left; margin: 5px; font-weight: bold;">Bugfixes:</div>

- Fixed a Bug that caused the halos to not get removed on death <br>

- Fixed a Bug that caused the staminup icon to not get properly shown  <br>

- Fixed a few lemonade Bugs <br>

<h2>Version 1.0 (26/05/2017):</h2>

- Started Documenting <br>

- Added new Role: <b> Jackal </b> <br>
<div style=" text-align: left; margin-left: 15px;"> - 3 Credits + Body Armor <br>
- Wins as the last man standing <br> </div>

- Added Command: ttt_forcerole <br>
<div style=" text-align: left; margin-left: 15px;"> - Available options to force are "innocent", "traitor", "detective", "hunter" and "jackal" <br>
- Only Dhalucard may use this command. <br> </div>

<br>

<div style="width: 100%; text-align: left; margin: 5px; font-weight: bold;">Bugfixes:</div>

- Fixed a Bug that caused HUD to disappear when arming a C4 as a traitor <br>

- Fixed a Bug that caused the Role Chat to not be shown  <br>

- Fixed a Bug that prevented the Juggernog from healing the player. (and no you didnt get a staminup instead)  <br>

<div style="width: 100%; text-align: left; margin: 5px; font-weight: bold;">Known Bugs:</div>

- Something is wrong with the Dead Ringer, but I dont know what. ("Achja der DeadRinger funktioniert nicht" - Fisk)

<div style="width: 100%; text-align: left; margin-top: 15px; font-weight: bold;">- Gamefreak</div>

</div>

</div>



</body>

</html>
