# Unstable

**Unstable** is a 2D side-scrolling game that offers both **single-player** and **multiplayer** modes.

You play as a **scientist** trying to escape a **broken time machine** — one you built yourself. The machine is unstable and randomly teleports you to different time periods. Occasionally, it glitches and sends you back home, where you have a brief moment to collect **items and amulets** to help you survive — or ultimately, **repair or destroy the machine**.

---

## 🎯 Goal

The main objective is to **collect all the necessary tools and notes** to fix the machine and break the **time loop**.

Along the way, you’ll encounter **amulets** that enhance your abilities:

- ⏱️ *Chronometer* – increases running speed  
- 🌿 *Plant* – enables higher jumps  
- 🍕 *Pizza* – grants a temporary double jump

> The amulet system is fully modular — adding new ones is quick and effortless.

The game ends when the player either **encounters a fatal obstacle** or successfully **repairs/destroys the machine**.

---

## 🎮 Controls

- `D` / `→` – Dash  
- `W` / `Space` / `↑` – Jump  
- `S` / `↓` – Dash down

---

## 🕰️ Time Periods

Current eras included in the game:

- **Present Day**  
  <img src="https://github.com/user-attachments/assets/c9448131-f910-43da-8de0-bb770e818c4a" width="600"/>

- **Middle Ages**  
  <img src="https://github.com/user-attachments/assets/a09c87a6-ec5a-44f5-9eed-1082228b227d" width="600"/>

- **Wild West**  
  <img src="https://github.com/user-attachments/assets/547b2ac5-a4d2-4a9a-a42c-e6c7a947e75a" width="600"/>

- **Cyberpunk Future**  
  <img src="https://github.com/user-attachments/assets/5c0d9d0a-826f-4112-8557-4232550ac92b" width="600"/>

---

## 🌐 Multiplayer Mode

Multiplayer follows the same core gameplay as single-player, with a few key differences:

- Certain **amulets are disabled** for balance  
- The goal is to **survive as long as possible**  
- Supports an **unlimited number of players**

> Multiplayer uses **WebRTC** with a **custom signaling server**. STUN/TURN servers are free and publicly available.  
> Works over **LAN** and the **public internet**.

<img src="https://github.com/user-attachments/assets/f76bff51-ed68-4d69-becf-608e795b5a97" width="600"/>

---

## 🔮 Items & Amulets

Below is a list of collectible amulets and tools, each enhancing your survival in unique ways. Some are passive, some active, and some are exclusive to either single-player or multiplayer modes.
![image](https://github.com/user-attachments/assets/f1768c59-e82d-4f05-a8cd-995a34cdf2f1)

---

### 🛠 Tools

- **🔧 Wrench** *(Active – 2s)*  
  Works like a boomerang that destroys small obstacles.  
  > In multiplayer: only affects local decorations (client-side only).

- **🔫 Ameridium Gun** *(Active – 7s)*  
  Fires a massive bullet that explodes on impact, breaking even large obstacles.  
  > In multiplayer: local effect only (client-side decorations).

- **🥚 Strong Egg** *(Active - 2s)*
    Egg that you can throw, very strong can destroy big obstacles.
    > In multiplayer: local effect only (client-side decorations).

---

### 🧬 Passive Amulets

- **🎒 Microbot Backpack** *(Passive – 4s)*  
  Deploys a microbot that flies to nearby obstacles and shrinks them by 50%.  
  > In multiplayer: cosmetic effect only (client-side).

- **🍌 Banana** *(Passive – 3s, Multiplayer Only)*  
  Drops a banana peel that causes other players to slip on contact.

- **❤️ Second Heart** *(Breaks on hit)*  
  Grants one extra life. Breaks upon taking damage.

- **🍕 Pizza** *(Breaks on next epoch)*  
  Temporarily grants the ability to double jump for one entire era.

- **🧬 Lifebuffer** *(Passive – 12s)*  
  Grants a heart if the player has none and stays alive for 12 seconds.

- **🪛 Screwdriver** *(Passive – 4s)*  
  Periodically removes half of the largest nearby obstacle's health.

---

### 🧪 Usable Amulets

- **💊 Slowing Pill** *(Single-player only)*  
  Slows all in-game processes, making everything easier to react to.

- **❓ Mystery Pill**  
  Randomly buffs the player when used. Example: all amulet cooldowns are halved.

- **🧴 Immunity Potion** *(Usable – 5s)*  
  Makes the player invincible for 5 seconds.

- **🌫 Dust** *(Multiplayer only)*  
  Throws dust at opponents, distorting their screen visuals temporarily.

---

### 🧠 Static Amulets

- **⏱ Chronometer**  
  Speeds up the player and allows collecting an **additional amulet** from home next time. But the extra speed makes survival harder.

- **👓 Glasses**  
  Extends the visible area by increasing the player’s camera range.

- **📜 Notes**  
  Lets the player see which epoch is coming next while in the home zone.

- **🌿 Some Plant**  
  Grants green energy that extends dash range, boosts jump height, and enhances downward dashing.


---

## 🧍 Character Customization

Choose and personalize your character's appearance before you dive into chaos.

<img src="https://github.com/user-attachments/assets/ea3e2d00-3014-4d2c-822e-74459e3361e3" width="400"/>
