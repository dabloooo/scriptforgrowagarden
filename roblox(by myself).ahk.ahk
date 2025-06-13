; AutoHotkey 1.1
; F1 — Увімкнути/вимкнути авто-режим
; F2 — Зберегти позицію SELL
; F3 — Зберегти позицію GARDEN
; F4 — Зберегти позицію "I want to sell my inventory"

toggle := false
sellX := 0
sellY := 0
gardenX := 0
gardenY := 0
inventoryX := 0
inventoryY := 0
moveTime := 0
moveState := ""

F1::
toggle := !toggle
if (toggle) {
    SetTimer, SpamE, 5
    SetTimer, JumpLoop, 5
    SetTimer, MoveLoop, 10
    SetTimer, SellAction, 60000  ; кожні 60 сек
    TrayTip, AHK, Режим увімкнено, 1
} else {
    SetTimer, SpamE, Off
    SetTimer, JumpLoop, Off
    SetTimer, MoveLoop, Off
    SetTimer, SellAction, Off
    Send, {w up}
    Send, {s up}
    moveTime := 0
    moveState := ""
    TrayTip, AHK, Режим вимкнено, 1
}
return

F2::  ; Зберегти SELL позицію
MouseGetPos, sellX, sellY
TrayTip, AHK, SELL позиція збережена: %sellX%x%sellY%, 2
return

F3::  ; Зберегти GARDEN позицію
MouseGetPos, gardenX, gardenY
TrayTip, AHK, GARDEN позиція збережена: %gardenX%x%gardenY%, 2
return

F4::  ; Зберегти позицію "I want to sell my inventory"
MouseGetPos, inventoryX, inventoryY
TrayTip, AHK, Inventory позиція збережена: %inventoryX%x%inventoryY%, 2
return

SpamE:
Send, {vk45}  ; англійська клавіша E
return

JumpLoop:
Send, {Space}  ; стрибок
return

MoveLoop:
if (!moveTime) {
    moveTime := A_TickCount
    moveState := "forward"
    Send, {w down}
    return
}

elapsed := A_TickCount - moveTime
if (moveState = "forward" and elapsed > 5000) {
    Send, {w up}
    Send, {s down}
    moveState := "backward"
    moveTime := A_TickCount
} else if (moveState = "backward" and elapsed > 5000) {
    Send, {s up}
    Send, {w down}
    moveState := "forward"
    moveTime := A_TickCount
}
return

SellAction:
if (sellX > 0 and sellY > 0) {
    MouseClick, left, %sellX%, %sellY%
    SetTimer, SpamE, Off
    SetTimer, JumpLoop, Off
    SetTimer, MoveLoop, Off
    Send, {w up}
    Send, {s up}
    SetTimer, GardenAndResume, -10000  ; пауза 10 секунд
}
return

GardenAndResume:
; Натискання E
Send, {vk45}
Sleep, 5000  ; пауза після натискання E

; Клік по "I want to sell my inventory"
if (inventoryX > 0 and inventoryY > 0) {
    MouseClick, left, %inventoryX%, %inventoryY%
    Sleep, 3000  ; 3 секунди після кліку
}

; Клік по GARDEN
if (gardenX > 0 and gardenY > 0) {
    MouseClick, left, %gardenX%, %gardenY%
    Sleep, 100
}

; Відновлення дій
if (toggle) {
    moveTime := 0
    moveState := ""
    SetTimer, SpamE, 5
    SetTimer, JumpLoop, 5
    SetTimer, MoveLoop, 10
}
return
