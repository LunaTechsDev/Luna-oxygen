/*:
@author LunaTechs - Kino
@plugindesc This plugin allows you to create notifications and event labels within RPGMakerMV/MZ <LunaChatter>.

@target MV MZ

@param audioBytes
@desc The audio files to use when playing sound
@type struct<SoundFile>[]

@param notificationStayTime
@text Notification Stay Time
@desc The amount of time in frames, that the notification should stay on screen.
@default 300

@param enableItemNotifications
@text Enable Item Notifications
@desc Automatically  send item notifications when items are gained or lost(true/false).
@default true


@param animationTypeNotification
@text Animation Type (Notification)
@desc Animation type for the chatter notification windows (slide/fade)
@default slide 

@param marginPadding
@text Margin Padding
@desc The amount of padding from the edge of the game screen when the notification window is on screen.
@default 12

@param maxChatterWindows
@text Maximum Chatter Windows
@desc The maximum number of chatter windows available on screen
@default 10

@param fadeInTime
@text Fade In Time
@desc The time in frames to fade in the chatter window as it enters the screen.
@default 120

@param fadeOutTime
@text Fade Out Time
@desc The time in frames to fade out the chatter window as it leaves the screen.
@default 120

@param enableEventNames
@text Enable Event Names
@desc Enables event names in the editor (true/false)
@default true

@param eventWindowRange
@text Event Window Range
@desc The radius in pixels in which the player will see the chatter window.
@default 120

@param anchorPosition
@text Anchor Position
@desc The anchor position of the  notification windows (topRight, bottomRight, topLeft, bottomLeft).
@default topRight

@param backgroundType
@text Background Type
@desc The background type of the chatter windows.
@default 0

@param eventBackgroundType
@text Event Background Type
@desc The background type of the event chatter windows. 
@default 2

@param templateStrings
@text Template Strings
@desc The template strings that you can draw within the
text window.
@type struct<Template>[]

@param templateJSStrings
@text Template JavaScript Strings
@desc The template JavaScripts you can embed within
the chatter window.
@type struct<JSTemplate>[]


@help

This plugin adds names to events as well as notification windows on the side
of the screen inside of your game.

MIT License
Copyright (c) 2020 LunaTechsDev
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE
*/

/*~struct~Template:
*
* @param id
* @text Identifier
* @desc The identifier used for this text template.
* @default 1
*
* @param text
* @text Text
* @type note
* @desc The text for the string template; has text code support.
* @default \N[1]: Hello Tim
*
*/

/*~struct~JSTemplate:
* @param id
* @text Identifier
* @desc The identifier used for the JS template.
* @default 1
*
* @param code
* @text Code
* @type note
* @desc The code for the code template.
* @default `${$gameActors.actor(1).name}`;
*/

/*~struct~SoundFile:
* @param id
* @text Identifier
* @desc The identifier used in the text window
* @type text
*
* @param name
* @text Name
* @desc The name of the audio SE file
* @type file
*
* @param pitch
* @text Pitch
* @desc The pitch of the audio file
* @type number
* @default 100
*
* @param volume
* @text Volume
* @desc The volume of the audio file
* @type number
* @default 50
*
* @param pan
* @text Pan
* @desc The pan of the audio file
* @type number
* @default 100
*
*/