#!/bin/sh
TP_ID=`xinput --list | grep -i Syn | grep -i Touch | cut -d '=' -f 2 | cut -f 1`
xinput disable $TP_ID
xinput enable $TP_ID

#synclient TapButton2=2
#synclient TapButton3=3
synclient RTCornerButton=0
synclient RBCornerButton=0
synclient LTCornerButton=0
synclient LBCornerButton=0
synclient EmulateMidButtonTime=0
synclient ClickTime=0
synclient Clickpad=0
synclient ClickFinger1=0
synclient ClickFinger2=0
synclient ClickFinger3=0
#synclient VertEdgeScroll=0
#synclient LeftEdge=0
synclient RightEdge=5600
#synclient TopEdge=0
#synclient BottomEdge=100
synclient VertEdgeScroll=1
synclient HorizEdgeScroll=0
synclient CornerCoasting=0
synclient VertTwoFingerScroll=0
synclient HorizTwoFingerScroll=0
synclient LockedDrags=0
synclient TapAndDragGesture=0
synclient CoastingSpeed=0
synclient MaxTapTime=0
synclient MaxDoubleTapTime=0

# 05-2020
#xinput set-prop $TP_ID 
#Synaptics Edges (346):	46, 5600, 34, 600
#Synaptics Finger (347):	25, 30, 0
#Synaptics Tap Time (348):	0
#Synaptics Tap Move (349):	58
#Synaptics Tap Durations (350):	180, 0, 0
#Synaptics ClickPad (351):	0
##Synaptics Middle Button Timeout (352):	0
#Synaptics Two-Finger Pressure (353):	282
#Synaptics Two-Finger Width (354):	7
#Synaptics Scrolling Distance (355):	26, 26
#Synaptics Edge Scrolling (356):	1, 0, 0
#Synaptics Two-Finger Scrolling (357):	0, 0
#Synaptics Move Speed (358):	1.000000, 1.750000, 0.151172, 0.000000
#Synaptics Off (359):	0
#Synaptics Locked Drags (360):	0
#Synaptics Locked Drags Timeout (361):	5000
#Synaptics Tap Action (362):	0, 0, 0, 0, 0, 0, 0
#Synaptics Click Action (363):	0, 0, 0
#Synaptics Circular Scrolling (364):	0
#Synaptics Circular Scrolling Distance (365):	0.100000
#Synaptics Circular Scrolling Trigger (366):	0
#Synaptics Circular Pad (367):	0
#Synaptics Palm Detection (368):	0
#Synaptics Palm Dimensions (369):	10, 200
#Synaptics Coasting Speed (370):	0.000000, 50.000000
#Synaptics Pressure Motion (371):	30, 160
#Synaptics Pressure Motion Factor (372):	1.000000, 1.000000
#Synaptics Grab Event Device (373):	0
#Synaptics Gestures (374):	0
#Synaptics Capabilities (375):	1, 0, 0, 1, 1, 0, 0
#Synaptics Pad Resolution (376):	12, 12
#Synaptics Area (377):	0, 0, 0, 0
#Synaptics Noise Cancellation (379):	6, 6
#
#[  6703.278] (--) synaptics: SYNA8004:00 06CB:CD8B Touchpad: touchpad found
