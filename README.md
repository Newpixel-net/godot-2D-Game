# 🎮 Critter Wheel Runner

An educational 2D endless runner game with color-matching mechanics, built with Godot Engine 4.x.

## 🎯 Game Overview

**Genre:** Endless Runner + Color Matching
**Target Platform:** Browser (HTML5) - with potential for desktop builds
**Controls:** Arrow Keys / A-D Keys + Touch Buttons

### How to Play

1. Your cat character runs automatically from left to right
2. A spinning wheel with 8 colored animal segments is displayed
3. Portals appear ahead requiring you to match specific animals
4. Rotate the wheel using **Arrow Keys** or **A/D** keys
5. Pass through portals with the correct animal selected to score points
6. Get 3 wrong matches and it's game over!
7. The game speeds up as your score increases

### Animals & Colors

- 🐦 **Bird** - Blue
- 🐱 **Cat** - Orange
- 🐸 **Frog** - Green
- 🐟 **Fish** - Cyan
- 🐰 **Rabbit** - Pink
- 🐕 **Dog** - Brown
- 🦋 **Butterfly** - Purple
- 🐢 **Turtle** - Yellow-Green

---

## 📦 What's Included

This repository contains a **complete, ready-to-play** Godot project with:

### ✅ Core Features Implemented

- ✨ Auto-running player character
- 🎡 Spinning color wheel with 8 animal segments
- 🚪 Portal spawning system with random color requirements
- ✅ Collision detection and color matching logic
- 🎨 Parallax scrolling background (sky, mountains, ground)
- 📊 UI system (score, wrong counter, game over screen)
- ⌨️ Keyboard controls (Arrow Keys + A/D)
- 📱 Touch buttons for mobile/browser
- ⚡ Progressive difficulty (speed increases with score)
- 🎮 Complete game state management

### 📁 Project Structure

```
godot-2D-Game/
├── scenes/                    # All game scenes
│   ├── main.tscn             # Main game scene (START HERE)
│   ├── player.tscn           # Player character
│   └── portal.tscn           # Portal/gate obstacle
├── scripts/                   # All GDScript files
│   ├── game_manager.gd       # Global game state (autoload)
│   ├── main.gd               # Main scene controller
│   ├── player.gd             # Player movement logic
│   ├── wheel.gd              # Wheel rotation and matching
│   ├── portal.gd             # Portal collision and checking
│   └── game_ui.gd            # UI display and interaction
├── ui/                        # UI components (integrated in main.tscn)
├── assets/                    # Graphics and sounds (currently using colored shapes)
├── export/                    # Export builds go here
│   └── html5/                # HTML5 export destination
├── project.godot             # Main Godot project file
├── export_presets.cfg        # HTML5 export configuration
├── icon.svg                  # Project icon
├── GODOT_SETUP_GUIDE.md      # Detailed setup instructions
└── README.md                 # This file
```

---

## 🚀 Getting Started

### Prerequisites

1. **Godot Engine 4.2+** (Download: https://godotengine.org/download/)
   - Use the standard version (NOT .NET)
   - Version 4.2.1 or later recommended

2. **A web browser** (Chrome, Firefox, Edge, Safari)

3. **Python 3** (optional, for running local web server)

### Step 1: Open the Project

1. Launch **Godot Engine**
2. In the Project Manager, click **"Import"**
3. Navigate to this folder and select `project.godot`
4. Click **"Import & Edit"**
5. Wait for Godot to load the project

### Step 2: Run the Game (In Editor)

**Fastest way to test:**

1. Press **F5** (or click the Play button ▶️ at top-right)
2. The game should start immediately!
3. Use **Arrow Keys** or **A/D** to rotate the wheel
4. Try to match the portal colors

**Tip:** Press **Escape** to close the game window and return to the editor.

---

## 🎮 How to Play

### Desktop Controls

- **Left Arrow** or **A** → Rotate wheel counter-clockwise
- **Right Arrow** or **D** → Rotate wheel clockwise
- **Space** or **Escape** → Pause (currently)

### Browser/Touch Controls

Two large buttons appear at the bottom-right:
- **◄ Button** → Rotate left
- **► Button** → Rotate right

### Gameplay Tips

1. **Watch ahead** - Portals spawn in front of you with the required animal name
2. **Rotate quickly** - You have a few seconds to match before reaching the portal
3. **Speed increases** - Every correct match makes you run faster
4. **3 strikes rule** - You get 3 wrong answers before game over
5. **Restart anytime** - Click the "Restart" button on game over screen

---

## 🌐 Exporting to HTML5 (Browser)

### Step 1: Download Export Templates (First Time Only)

1. In Godot, go to **Editor → Manage Export Templates**
2. Click **"Download and Install"**
3. Wait for download to complete (can take 5-10 minutes)
4. Close the template manager

### Step 2: Export the Game

1. Go to **Project → Export...**
2. You should see **"Web"** preset already configured
3. Click on the "Web" preset to select it
4. Click **"Export Project"** at the bottom
5. The export path should already be set to `export/html5/index.html`
6. Click **"Save"**
7. Wait for export to complete (30-60 seconds)

### Step 3: Test in Browser

**⚠️ IMPORTANT:** You cannot just double-click `index.html`! Browsers require a web server for WebAssembly games.

#### Option A: Use Godot's Built-in Server (Easiest!)

1. In the Export window, with "Web" preset selected
2. Click the **"Run in Browser"** button (🌐 icon) at the top
3. Godot will start a local server and open your browser automatically!

#### Option B: Use Python HTTP Server

```bash
cd export/html5
python3 -m http.server 8000
```

Then open: http://localhost:8000

#### Option C: Use Any Local Web Server

- **Node.js**: `npx http-server export/html5 -p 8000`
- **PHP**: `php -S localhost:8000 -t export/html5`
- **VS Code**: Install "Live Server" extension, right-click `index.html` → "Open with Live Server"

---

## 🔧 Customization & Modification

### Want to Change Something?

All game logic is in the `scripts/` folder. Here are common modifications:

#### Change Game Difficulty

Edit `scripts/game_manager.gd`:

```gdscript
const MAX_WRONG_ANSWERS = 3          # Change to 5 for easier game
const INITIAL_SPEED = 200.0          # Starting speed
const SPEED_INCREASE_PER_POINT = 10.0  # Speed boost per point
const MAX_SPEED = 500.0              # Maximum speed cap
```

#### Change Portal Spawn Rate

Edit `scripts/main.gd`:

```gdscript
const MIN_SPAWN_INTERVAL = 2.0  # Seconds between portals (min)
const MAX_SPAWN_INTERVAL = 4.0  # Seconds between portals (max)
```

#### Add More Animals

Edit `scripts/wheel.gd`:

```gdscript
var animals = [
    {"name": "Bird", "color": Color(0.2, 0.6, 1.0)},
    {"name": "Cat", "color": Color(1.0, 0.6, 0.2)},
    # Add more here...
    {"name": "Lion", "color": Color(1.0, 0.8, 0.0)},  # Example
]
```

**Note:** Also update `SEGMENT_COUNT` at the top of the file!

#### Change Player Color

Edit `scripts/player.gd`:

```gdscript
const PLAYER_COLOR = Color(1.0, 0.6, 0.2)  # RGB values (0-1)
```

Or modify the player scene directly:
1. Open `scenes/player.tscn` in Godot
2. Select "Sprite" node (the ColorRect)
3. In Inspector, change the "Color" property
4. Save the scene

---

## 🎨 Adding Real Graphics

Currently, the game uses simple colored shapes (ColorRect nodes). Want to add real sprites?

### How to Replace with Sprites

1. **Add your images** to `assets/sprites/` folder
   - Formats: PNG, JPG, SVG
   - Recommended size: 64x64 to 128x128 pixels

2. **For the Player:**
   - Open `scenes/player.tscn`
   - Delete the "Sprite" ColorRect node
   - Add a new **Sprite2D** node
   - Drag your image from FileSystem to the "Texture" property
   - Adjust scale/position as needed

3. **For Portals:**
   - Open `scenes/portal.tscn`
   - Similar process: replace ColorRect with Sprite2D
   - You may want to use a semi-transparent PNG for the portal effect

4. **For the Wheel:**
   - This is more complex (currently drawn programmatically)
   - Option 1: Draw wheel segments as separate images
   - Option 2: Keep the code-generated wheel (it works well!)

---

## 🐛 Troubleshooting

### Game won't run in Godot Editor

**Error: "Can't find main scene"**
- Solution: Go to **Project → Project Settings → Application → Run**
- Set "Main Scene" to `res://scenes/main.tscn`

**Error: "Parser Error" or "Script Error"**
- Check the Output panel (bottom of Godot) for specific error details
- Copy the error message and ask for help

### HTML5 export issues

**Error: "Export templates not found"**
- Download templates: **Editor → Manage Export Templates → Download and Install**

**Game loads but shows black screen**
- Check browser console (F12) for JavaScript errors
- Make sure you're using a local web server, not `file://`
- Try a different browser (Chrome usually works best)

**Game is very slow in browser**
- This is normal for HTML5 exports, they're slower than native
- Try reducing window resolution in Project Settings
- Consider making a desktop build for better performance

### Wheel not rotating

- Make sure you're clicking on the game window first (to give it focus)
- Try pressing the touch buttons (◄ ►) instead of keyboard
- Check Output console for errors related to input

### Portals not spawning

- Check Output console - there might be errors in `main.gd`
- Make sure `scenes/portal.tscn` exists and loads correctly
- Try running the game in Godot editor (not just exported version)

---

## 📚 Understanding the Code

### Game Flow

1. **Game starts** → `main.tscn` loads
2. **GameManager autoload** initializes (global singleton)
3. **Player** starts moving automatically at base speed
4. **Main script** spawns portals at random intervals
5. **Wheel** listens for input and rotates segments
6. **Portal** checks if player's wheel matches on collision
7. **GameManager** updates score/wrong count
8. **UI** displays current state
9. **Game Over** shows when wrong count reaches 3

### Key Scripts Explained

#### `game_manager.gd` (Singleton/Autoload)

- Tracks global state: score, wrong count, game speed
- Emits signals when state changes (other scripts listen to these)
- Handles game over logic
- This script is accessible from anywhere as `GameManager`

#### `player.gd`

- Attached to the player CharacterBody2D
- Moves the player automatically at current game speed
- Listens to GameManager for speed updates

#### `wheel.gd`

- Creates 8 colored segments programmatically
- Handles rotation input (left/right)
- Smooth rotation animation
- Provides current animal selection to other scripts

#### `portal.gd`

- Each portal instance has a required animal
- Detects when player passes through (Area2D collision)
- Checks if wheel matches the requirement
- Emits visual feedback (green/red flash)
- Notifies GameManager of result

#### `main.gd`

- Orchestrates the whole game
- Spawns portals at intervals
- Camera follows the player
- Manages parallax background scrolling

#### `game_ui.gd`

- Displays score and wrong count
- Shows/hides game over panel
- Handles restart button
- Manages touch control buttons

---

## 🎓 Learning Resources

New to Godot? Check out these resources:

- **Official Godot Docs**: https://docs.godotengine.org/
- **Your First 2D Game Tutorial**: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/
- **GDScript Basics**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
- **Godot Community**: https://godotengine.org/community

### Recommended Next Steps

1. ✅ **Play the game** - Understand how it works
2. 🎨 **Customize colors** - Change the animal colors
3. 🔧 **Tweak difficulty** - Adjust speed and spawn rates
4. 🖼️ **Add graphics** - Replace colored shapes with sprites
5. 🎵 **Add sounds** - Use AudioStreamPlayer for effects
6. 🌟 **New features** - Add power-ups, obstacles, etc.

---

## 🚀 Next Steps: Windows Desktop Build

Want to make a Windows .exe?

1. Go to **Project → Export...**
2. Click **"Add..."** → Select **"Windows Desktop"**
3. Configure the preset:
   - Set export path: `export/windows/CritterWheelRunner.exe`
4. Click **"Export Project"**
5. Run the .exe file!

**Note:** Export templates are needed (same as HTML5, but includes all platforms).

---

## 📝 Credits

- **Game Design**: Educational endless runner concept
- **Engine**: Godot Engine 4.x (https://godotengine.org)
- **Art**: Simple geometric shapes (customizable!)
- **Code**: Fully commented GDScript

---

## 🎮 Have Fun!

This game is fully functional and ready to play! Feel free to:

- ✅ Modify and customize
- ✅ Learn from the code
- ✅ Add new features
- ✅ Share with friends
- ✅ Use as a learning project

**Questions or issues?** Check the troubleshooting section above or review the code comments in the `scripts/` folder.

**Happy gaming! 🐱🎡✨**
