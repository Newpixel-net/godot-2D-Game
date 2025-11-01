# Asset Integration Guide

## Critter Wheel Runner - Complete Asset Replacement Guide

This document explains how to replace all placeholder assets (colored shapes) with real graphics, sounds, and animations.

---

## 📋 Table of Contents

1. [Asset Specifications](#asset-specifications)
2. [Player Character Sprites](#player-character-sprites)
3. [Color Wheel Graphics](#color-wheel-graphics)
4. [Portal/Gate Graphics](#portal-gate-graphics)
5. [Background Layers](#background-layers)
6. [UI Elements](#ui-elements)
7. [Audio Files](#audio-files)
8. [Step-by-Step Integration](#step-by-step-integration)

---

## Asset Specifications

### General Requirements

- **Format**: PNG with transparency (for sprites/UI)
- **Color Mode**: RGBA
- **Compression**: Lossless PNG
- **Naming**: lowercase_with_underscores.png
- **Organization**: Place in appropriate `assets/` subfolders

---

## Player Character Sprites

### Required Animations

The player needs **8 color variations** × **3 animations**:

#### Colors Needed
1. Blue
2. Red
3. Green
4. Yellow
5. Purple
6. Orange
7. Pink
8. Brown

#### Animations per Color
1. **Run** - 8 frames, 12 FPS
2. **Jump** - 6 frames, 10 FPS
3. **Idle** - 4 frames, 8 FPS

### Sprite Sheet Specifications

**Option A: Single Large Sprite Sheet**
- Layout: Grid of 8 colors × 18 frames (8+6+4)
- Frame size: 64×64 pixels each
- Total size: 512×1152 pixels
- Format: PNG with transparency
- File: `assets/sprites/player/player_all_colors.png`

**Option B: Individual Color Sheets** (Recommended)
- 8 separate sprite sheets, one per color
- Each sheet: 18 frames (run+jump+idle)
- Frame size: 64×64 pixels
- Layout: Horizontal strip (1152×64) or grid (6×3)
- Files:
  - `assets/sprites/player/blue_dino.png`
  - `assets/sprites/player/red_dino.png`
  - etc.

### Integration Steps

1. **Export your sprites** to the specifications above
2. **Import into Godot**: Place PNG files in `assets/sprites/player/`
3. **Open player scene**: `scenes/player.tscn`
4. **Select AnimatedSprite2D node**
5. **Click "SpriteFrames" in Inspector**
6. **Add animations**:
   - Create "run", "jump", "idle" animations
   - Click each animation → "Add Frames from Sprite Sheet"
   - Select your PNG file
   - Configure frames (8 for run, 6 for jump, 4 for idle)
7. **Set FPS** for each animation
8. **Repeat for all 8 colors** (if using separate sheets)

### Alternative: Script-Based Color Switching

If you want to use **one sprite sheet** and change color programmatically:

1. Use the `blue_dino.png` as base
2. Leave the modulate code in `player.gd` as-is
3. The game will tint the sprite to match colors

**Note**: This gives less control over individual color details.

---

## Color Wheel Graphics

### Wheel Sprite

**Specifications**:
- Size: 300×300 pixels
- Format: PNG with transparency
- Content: Circular wheel divided into 8 equal segments
- Each segment: Different color matching player colors
- Border: White outline (2-3px) between segments
- Center: Optional decorative hub/circle

**File**: `assets/sprites/wheel/color_wheel.png`

### Segment Icons (Optional)

Small animal icons for each segment:
- Size: 48×48 pixels each
- Format: PNG with transparency
- Animals: Bird, Cat, Frog, Fish, Rabbit, Dog, Butterfly, Turtle
- Files: `assets/sprites/wheel/icon_bird.png`, etc.

### Integration Steps

1. **Create wheel graphic** in your art software (Photoshop, Krita, etc.)
2. **Export** to `assets/sprites/wheel/color_wheel.png`
3. **Open ColorWheel scene** (in `GameScene.tscn`)
4. **Select WheelSprite node** (currently draws programmatically)
5. **Option A - Use sprite**:
   - Change Node2D to Sprite2D
   - Set Texture property to your wheel PNG
   - Comment out `create_wheel_segments()` code
6. **Option B - Keep procedural**:
   - Leave code as-is (draws wheel from code)
   - Wheel auto-generates from color data

---

## Portal/Gate Graphics

### Portal Sprite

**Specifications**:
- Size: 200×300 pixels (width×height)
- Format: PNG with transparency
- Design: Glowing ring/archway/gate
- Color: Neutral base (white/gray) - will be tinted by code
- Optional: Animated (4-8 frames for pulsing effect)

**Files**:
- Static: `assets/sprites/portal/portal_gate.png`
- Animated: `assets/sprites/portal/portal_anim.png` (sprite sheet)

### Particle Effects (Optional)

- Success particles: Green sparkles
- Failure particles: Red warning symbols

### Integration Steps

1. **Export portal graphic** to specifications above
2. **Place** in `assets/sprites/portal/`
3. **Open portal scene**: `scenes/portal.tscn`
4. **Select Sprite node** (currently ColorRect)
5. **Replace with Sprite2D**:
   - Right-click Sprite ColorRect → Delete
   - Add new Sprite2D node
   - Set Texture to `portal_gate.png`
6. **If using animation**:
   - Use AnimatedSprite2D instead
   - Configure frames
7. **Test**: Run game, portals should use new graphics

---

## Background Layers

### Layer 1: Sky

**Specifications**:
- Size: 1280×720 pixels (or larger for higher quality)
- Format: PNG or JPG
- Content: Gradient sky (light blue to cyan)
- File: `assets/backgrounds/sky.png`

### Layer 2: Mountains (Far Background)

**Specifications**:
- Size: 1920×400 pixels
- Format: PNG with transparency
- Content: Mountain silhouettes
- Must tile seamlessly (left edge matches right edge)
- File: `assets/backgrounds/mountains.png`

### Layer 3: Trees/Forest (Mid Background)

**Specifications**:
- Size: 1920×600 pixels
- Format: PNG with transparency
- Content: Tree silhouettes or forest
- Must tile seamlessly
- File: `assets/backgrounds/trees.png`

### Layer 4: Ground

**Specifications**:
- Size: 1920×200 pixels
- Format: PNG with transparency
- Content: Grass/terrain pattern
- Must tile seamlessly
- File: `assets/backgrounds/ground.png`

### Creating Tileable Backgrounds

**In Photoshop/Krita**:
1. Create your layer (e.g., 1920px wide)
2. Use **Offset Filter**: Shift by 960px (half width)
3. Fix the seam in the middle
4. Shift back and verify it tiles

**Testing Tileability**:
Place two copies side-by-side - they should blend perfectly.

### Integration Steps

1. **Create all 4 layers** to specifications
2. **Export** to `assets/backgrounds/`
3. **Open GameScene.tscn**
4. **Select ParallaxBackground node**
5. **For each ParallaxLayer**:
   - Find corresponding ColorRect child
   - Replace with Sprite2D
   - Set Texture to your background PNG
   - Check "Region Enabled" in Inspector
   - Set Region Rect to match image size
   - Set "Motion Mirroring" X value (e.g., 1920)
6. **Adjust Motion Scale** if needed:
   - Sky: 0.1
   - Mountains: 0.3
   - Trees: 0.6
   - Ground: 1.0

---

## UI Elements

### Buttons

**Specifications**:
- Size: 128×128 pixels each
- Format: PNG with transparency
- Buttons needed:
  - Jump/Action button (for touch controls)
  - Pause button
  - Play button (for menus)
  - Settings button

**Files**:
- `assets/ui/buttons/button_jump.png`
- `assets/ui/buttons/button_pause.png`
- etc.

### Fonts

**Recommended**:
- Game font: Bold, clear, readable
- Format: TTF or OTF
- License: Free for commercial use

**File**: `assets/ui/fonts/game_font.ttf`

### Integration Steps

1. **Create button graphics**
2. **Place** in `assets/ui/buttons/`
3. **Open GameScene.tscn**
4. **Select button nodes** in UILayer
5. **In Inspector → Icon property**: Load button PNG
6. **For font**:
   - Select Label node
   - Inspector → Theme Overrides → Fonts
   - Load your TTF/OTF file
   - Adjust size as needed

---

## Audio Files

### Background Music

**Specifications**:
- Format: OGG (recommended for web)
- Length: 1-3 minutes, seamless loop
- BPM: 120-140 (upbeat)
- Bitrate: 128 kbps
- Must loop without gap/pop

**File**: `assets/audio/music/background_music.ogg`

### Sound Effects

**Specifications**:
- Format: OGG
- Bitrate: 96 kbps
- Sample rate: 44.1kHz

**Required SFX**:
1. **Jump** (0.1-0.2s): Short "boing" sound
2. **Correct Match** (0.3s): Success chime
3. **Wrong Match** (0.5s): Buzzer/error sound
4. **Game Over** (1-2s): Defeat jingle
5. **Click** (0.1s): UI button click

**Files**:
- `assets/audio/sfx/jump.ogg`
- `assets/audio/sfx/correct.ogg`
- `assets/audio/sfx/wrong.ogg`
- `assets/audio/sfx/game_over.ogg`
- `assets/audio/sfx/click.ogg`

### Creating OGG Files

**From WAV**:
1. Export your audio as WAV (high quality)
2. Use Audacity or similar:
   - File → Export → Export as OGG Vorbis
   - Quality: 5 (128 kbps for music, 3-4 for SFX)
3. Name according to specification

### Integration Steps

1. **Create/export all audio** to OGG format
2. **Place** in `assets/audio/music/` and `assets/audio/sfx/`
3. **Open `scripts/audio_manager.gd`**
4. **Uncomment** the `load_audio_files()` code:
   ```gdscript
   if ResourceLoader.exists("res://assets/audio/music/background_music.ogg"):
       music_player.stream = load("res://assets/audio/music/background_music.ogg")

   sfx_library["jump"] = load("res://assets/audio/sfx/jump.ogg")
   sfx_library["correct"] = load("res://assets/audio/sfx/correct.ogg")
   # etc...
   ```
5. **Save script**
6. **Run game**: Audio should now play

---

## Step-by-Step Integration

### Phase 1: Player Character

1. Create player sprites (all colors, all animations)
2. Export to `assets/sprites/player/`
3. Open `scenes/player.tscn`
4. Replace ColorRect with AnimatedSprite2D
5. Import sprite sheets
6. Configure animations
7. Test in-game

### Phase 2: Backgrounds

1. Create 4 background layers (sky, mountains, trees, ground)
2. Ensure tileability
3. Export to `assets/backgrounds/`
4. Open `GameScene.tscn`
5. Replace ColorRect placeholders with Sprite2D
6. Configure parallax settings
7. Test scrolling

### Phase 3: Color Wheel

1. Create wheel graphic
2. Optional: Create segment icons
3. Export to `assets/sprites/wheel/`
4. Replace procedural wheel or use sprite
5. Test wheel rotation

### Phase 4: Portals

1. Create portal/gate graphic
2. Optional: Animate it
3. Export to `assets/sprites/portal/`
4. Replace ColorRect with Sprite2D/AnimatedSprite2D
5. Test spawning and colors

### Phase 5: UI

1. Create button graphics
2. Choose/download game font
3. Export to `assets/ui/`
4. Update UI nodes with new graphics
5. Test touch controls and buttons

### Phase 6: Audio

1. Create or source music loop
2. Create all 5 sound effects
3. Convert to OGG format
4. Export to `assets/audio/`
5. Update `audio_manager.gd` script
6. Test all sounds in-game

---

## Testing Checklist

After integrating assets:

- [ ] Player runs with new sprites
- [ ] Player animations change (run, jump, idle)
- [ ] Player color changes when passing portal
- [ ] Background layers scroll at different speeds
- [ ] Background tiles seamlessly (no visible seams)
- [ ] Color wheel displays with graphics
- [ ] Portals use new gate graphic
- [ ] Portal colors match wheel colors
- [ ] UI buttons show custom graphics
- [ ] Custom font displays correctly
- [ ] Background music plays and loops
- [ ] Jump sound plays when jumping
- [ ] Success sound on correct match
- [ ] Error sound on wrong match
- [ ] Game over sound at end

---

## Asset Sources (Free/Paid)

### Graphics

- **OpenGameArt.org**: Free game assets
- **itch.io**: Free and paid asset packs
- **Kenney.nl**: High-quality free assets
- **Freepik**: Vector graphics (check license)

### Audio

- **Freesound.org**: Free sound effects
- **OpenGameArt.org**: Music and SFX
- **Incompetech**: Royalty-free music
- **Purple Planet**: Free game music

### Fonts

- **Google Fonts**: Free fonts
- **DaFont**: Game fonts section
- **FontSpace**: Free fonts

**Always check licenses** before using in commercial projects!

---

## Need Help?

If you encounter issues during asset integration:

1. Check that file paths match exactly
2. Verify PNG transparency is preserved
3. Ensure OGG files are actually OGG (not renamed MP3)
4. Test with one asset type at a time
5. Check Godot's Output console for errors

**Common Issues**:
- **"Cannot load texture"**: Check file path and format
- **"Seams in background"**: Tile not seamless, re-export
- **"No audio plays"**: Check file exists, is OGG format
- **"Animation doesn't play"**: Verify FPS and frame count

---

## Final Notes

- Start with **player sprites** - most visible impact
- **Backgrounds** are second priority
- **Audio** can be added last
- **Test frequently** as you integrate
- **Backup** your project before major changes
- **Keep placeholder code** commented out (don't delete)

Good luck with your asset integration! 🎨🎮✨
