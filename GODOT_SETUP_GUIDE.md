# Critter Wheel Runner - Complete Godot Setup Guide

## 📋 Table of Contents
1. [Installing Godot Engine](#installing-godot-engine)
2. [Creating Your First Project](#creating-your-first-project)
3. [Understanding Godot Project Structure](#understanding-project-structure)
4. [Configuring HTML5 Export](#configuring-html5-export)
5. [Testing in Browser](#testing-in-browser)
6. [Using Claude Code with Godot](#using-claude-code-with-godot)

---

## 🎮 Installing Godot Engine

### Recommended Version
**Godot 4.2.1** (or latest Godot 4.x stable version)

### Download Links
- **Official Website**: https://godotengine.org/download/
- **Direct Download**: https://godotengine.org/download/archive/

### Installation Steps

#### Windows
1. Go to https://godotengine.org/download/
2. Download **Godot Engine - .NET not required** (Standard version)
3. Extract the ZIP file to a folder (e.g., `C:\Godot\`)
4. Run `Godot_v4.x_stable_win64.exe` (no installation needed!)
5. *Optional*: Create a desktop shortcut

#### Mac
1. Download the macOS version from the website
2. Open the DMG file
3. Drag Godot to Applications folder
4. Run Godot from Applications

#### Linux
1. Download the Linux version
2. Extract the archive
3. Make it executable: `chmod +x Godot_v4.x_stable_linux.x86_64`
4. Run: `./Godot_v4.x_stable_linux.x86_64`

### ✅ Verification
When you launch Godot, you should see the Project Manager window. Success! ✨

---

## 🆕 Creating Your First Project

### Step 1: Open Godot Project Manager
When you launch Godot, you'll see the Project Manager with options to create or import projects.

### Step 2: Create New Project
1. Click **"New Project"** (or "+ New" button)
2. Fill in the details:
   - **Project Name**: `Critter Wheel Runner`
   - **Project Path**: Choose where to save (this repository folder: `/home/user/godot-2D-Game`)
   - **Renderer**: Select **"Forward+"** or **"Mobile"** (Mobile is better for browser)
3. Click **"Create & Edit"**

### Step 3: First Look at Godot Editor
You'll see several panels:
- **Scene** (top-left): Shows your game objects hierarchy
- **FileSystem** (bottom-left): Your project files
- **Inspector** (right): Properties of selected objects
- **Viewport** (center): Where you see and edit your game
- **Bottom Panel**: Output, debugger, animation tools

---

## 📁 Understanding Project Structure

### Essential Files Created by Godot

```
godot-2D-Game/
├── .godot/                  # Godot's internal files (auto-generated)
├── project.godot            # Main project configuration file
├── icon.svg                 # Default project icon
└── (your game files will go here)
```

### Files We'll Create for Critter Wheel Runner

```
godot-2D-Game/
├── scenes/                  # All game scenes
│   ├── main.tscn           # Main game scene
│   ├── player.tscn         # Player character
│   ├── wheel.tscn          # Color wheel
│   ├── portal.tscn         # Portal/gate
│   └── background.tscn     # Parallax background
├── scripts/                 # All GDScript files
│   ├── main.gd             # Main game logic
│   ├── player.gd           # Player movement
│   ├── wheel.gd            # Wheel rotation logic
│   ├── portal.gd           # Portal behavior
│   └── game_manager.gd     # Game state management
├── ui/                      # UI scenes
│   └── game_ui.tscn        # Score, counter, game over screen
├── assets/                  # Graphics and sounds (if added later)
│   ├── sprites/
│   └── sounds/
└── export/                  # Exported builds go here
    └── html5/
```

### Understanding Godot Files

#### `.tscn` Files (Scene Files)
- Scene files contain game objects and their properties
- Think of them as "prefabs" or "templates"
- They store the hierarchy of nodes (game objects)
- **Example**: `player.tscn` contains the cat character, its sprite, collision shape, etc.

#### `.gd` Files (GDScript Files)
- Script files written in GDScript (Python-like language)
- Contain the game logic and behavior
- Attached to nodes in scenes
- **Example**: `player.gd` controls how the cat moves

#### `project.godot`
- Main configuration file
- Stores project settings, input mappings, export settings
- Plain text file (safe to edit manually if needed)

---

## 🌐 Configuring HTML5 Export

### Step 1: Download Export Templates

1. In Godot, go to **Editor → Manage Export Templates**
2. Click **"Download and Install"**
3. Wait for download to complete (can take a few minutes)
4. Close the template manager

### Step 2: Set Up HTML5 Export Preset

1. Go to **Project → Export...**
2. Click **"Add..."** at the top
3. Select **"Web"** from the list
4. Configure these important settings:

#### Essential Settings:
- **Export Path**: `export/html5/index.html`
- **Custom HTML Shell**: (leave default for now)
- **Head Include**: (leave empty for now)

#### Recommended Settings:
- **Vram Texture Compression**: Enable for better performance
  - Check **"For Desktop"** (S3TC)
  - Check **"For Mobile"** (ETC2)

#### Advanced Settings (Optional):
- **Experimental Features → Threads**: Enable if you want better performance (but may have browser compatibility issues)

### Step 3: Save the Export Preset
Click **"Close"** - your settings are automatically saved!

---

## 🧪 Testing in Browser

### Method 1: Test During Development (In Godot Editor)

1. Press **F5** (or click the Play button ▶️ at top-right)
2. First time: Select your main scene (we'll create `scenes/main.tscn`)
3. The game runs in a native window (faster for testing)

### Method 2: Export and Test in Browser

1. Go to **Project → Export...**
2. Select your **Web** export preset
3. Click **"Export Project"**
4. Choose location: `export/html5/index.html`
5. Click **"Save"**

### Running the Exported HTML5 Game

**⚠️ IMPORTANT**: You CANNOT just double-click `index.html`! Browsers block this for security reasons.

#### Option A: Use Python's Built-in Server (Easiest)
```bash
cd export/html5
python3 -m http.server 8000
```
Then open browser to: `http://localhost:8000`

#### Option B: Use Godot's Built-in Server
1. In Godot, go to **Project → Export...**
2. Select Web preset
3. Click **"Run in Browser"** button (🌐 icon)
4. Godot automatically starts a local server and opens your browser!

#### Option C: Use VS Code Live Server
If you have VS Code:
1. Install "Live Server" extension
2. Right-click on `index.html`
3. Select "Open with Live Server"

---

## 💻 Using Claude Code with Godot

### How Godot Projects Work with Claude Code

Claude Code can read and edit ALL Godot files:
- `.gd` scripts (plain text)
- `.tscn` scene files (plain text, but structured)
- `project.godot` (plain text configuration)

### Typical Workflow

1. **Create scene structure in Godot Editor**
   - Add nodes (game objects)
   - Arrange them in hierarchy
   - Set basic properties
   - Save the scene

2. **Let Claude create/edit scripts**
   - Claude can write all `.gd` files
   - Claude can modify scene files if needed
   - Claude can configure `project.godot`

3. **Test in Godot**
   - Open Godot Editor
   - Press F5 to run
   - See the results!

### Best Practices

✅ **DO:**
- Let Claude create all GDScript files
- Ask Claude to explain any code you don't understand
- Test frequently in Godot Editor
- Use Claude to debug errors from Godot's output console

❌ **DON'T:**
- Edit `.tscn` files manually (too complex, use Godot Editor)
- Worry about `.godot/` folder (auto-generated, ignore it)
- Delete `project.godot` (it's your main config!)

### Common Claude Code + Godot Tasks

#### Task 1: Create a new script
```
"Claude, create a player script that makes the character move right automatically"
```

#### Task 2: Modify existing script
```
"Claude, add jump functionality to player.gd"
```

#### Task 3: Debug an error
```
"Claude, I'm getting this error in Godot: [paste error here]. Can you fix it?"
```

#### Task 4: Explain code
```
"Claude, explain what this function does in wheel.gd"
```

---

## 🎯 Quick Start Checklist

Before starting game development, make sure you have:

- [ ] Godot 4.x installed and running
- [ ] Created "Critter Wheel Runner" project in this folder
- [ ] Downloaded export templates
- [ ] Set up Web export preset
- [ ] Tested that you can run a basic scene (press F5)
- [ ] Know how to open the Output console (bottom panel in Godot)

---

## 🐛 Common Issues & Solutions

### Issue 1: "Can't find export templates"
**Solution**: Go to Editor → Manage Export Templates → Download and Install

### Issue 2: "index.html doesn't work when I open it"
**Solution**: You need a local server. Use one of the methods in "Testing in Browser" section above.

### Issue 3: "Script errors in Godot console"
**Solution**: Copy the full error message and share it with Claude. The error usually tells you:
- Which file has the error
- Which line number
- What's wrong

### Issue 4: "Game runs in editor but not in browser"
**Solution**:
- Check browser console (F12) for JavaScript errors
- Make sure you're using a local server, not `file://`
- Try disabling browser extensions that might block content

### Issue 5: "Scenes won't open"
**Solution**: Make sure the `.tscn` file is in your project folder and visible in the FileSystem panel (bottom-left in Godot)

---

## 📚 Next Steps

Now that you understand the basics, you're ready to build the game!

Claude will now create:
1. All necessary scene files (`.tscn`)
2. All game scripts (`.gd`)
3. Complete project structure
4. A detailed README with how to run everything

After Claude creates the files:
1. Open Godot
2. Click "Import" in Project Manager
3. Navigate to this folder
4. Select `project.godot`
5. Click "Import & Edit"
6. Press F5 to run!

---

## 🎓 Learning Resources

- **Official Godot Docs**: https://docs.godotengine.org/
- **"Your First 2D Game" Tutorial**: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/
- **GDScript Reference**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/

---

**Ready to start? Let's build Critter Wheel Runner! 🎮🐱🎡**
